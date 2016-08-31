---
id: 69
title: "Managing ActiveRecord connections with Octoshark"
date: 2016-08-30 08:30:00 +0100
author: Dalibor Nasevic
tags: [octoshark, active record, database connections, rails]
---

I wrote [Octoshark](https://github.com/dalibor/octoshark) a while ago but never really put any words about it on my blog. Now that I have been using it successfully in production for about a year handling millions of API requests per day and sending millions of emails per day for both [GoDaddy Email Marketing](https://www.godaddy.com/online-marketing/email-marketing) and [Mad Mimi](https://madmimi.com/), let's do that.

<p style="text-align:center;">
  <img src="/images/octoshark.png" alt="Octoshark" title="Octoshark logo design by Sascha Michael Trinkaus">
</p>

### What is Octoshark?

Octoshark is a simple ActiveRecord connection manager. It provides connection switching mechanisms that can be used in various scenarios like master-slave, sharding or multi-tenant architecture.

There are many other gems that solve the problem of accessing data from different databases and develop more complex features for the architecture they are designing for. Just to mention few: [Octopus](https://github.com/thiagopradi/octopus), [Apartment](https://github.com/influitive/apartment), [db-charmer](https://github.com/kovyrin/db-charmer), [makara](https://github.com/taskrabbit/makara), but there are many many more.

I played with some of them and took the architecture of the system I was designing from monolithic, through sharding to multi-tenant. Octoshark was born on that journey as the minimal building block that I needed to migrate the system from one architecture to another.

Octoshark was written with the following goals in mind:

- be simple and do one thing - connection switching
- be easy to maintain and upgrade with Rails versions
- patch ActiveRecord as little as possible


### Octoshark Connection Managers

Octoshark has two connection managers: `ConnectionPoolsManager` for managing connection pools using persistent connections and `ConnectionManager` for managing non-persistent connections. It depends on the application performance and scaling requirements which one to use. Both can be combined and multiple instances of each manager can be used at the same time.

If the number of consumers (application and worker servers) is somewhat limited, `ConnectionPoolsManager` would be the preferred option. Standard Rails application has a single connection pool per ActiveRecord class and connection spec, and `ConnectionPoolsManager` makes it possible to use multiple connection pools.

For big infrastructures with lots of consumers where max connections limit on database servers is reached and horizontal scale is a need, `ConnectionManager` is the option to use. Because it uses non-persistent connections it comes up with a performance penalty for re-establishing connections over and over again. Some ActiveRecord plugins that depend on having an active database connection at bootup time will need a change in order to work with the non-persistent connections.


### How to use Octoshark

Create a connection pools manager:

```ruby
CONN_MANAGER = Octoshark::ConnectionPoolsManager.new({
  c1: config1,
  c2: config2
})
```

`c1` and `c2` are identifiers for the pools and `config1` and `config2` are standard ActiveRecord database configs like:


```ruby
config = {
  adapter:  'mysql2',
  host:     'localhost',
  port:     3306,
  database: 'database',
  username: 'root',
  password: 'pass',
  pool:     3,
  encoding: 'utf8',
  reconnect: false
}
```

To switch a connection using a specific pool:

```ruby
CONN_MANAGER.with_connection(:c1) do |connection|
  connection.execute("SELECT 1")
end
```

Multiple `with_connection` blocks can be nested:

```ruby
CONN_MANAGER.with_connection(:c1) do
  # run queries on connection specified with :c1

  CONN_MANAGER.with_connection(:c2) do
    # run queries on connection specified with :c2
  end

  # run queries on connection specified with :c1
end
```

When using a single connection pool per database server, database connections can be switched by using the second and optional argument of `with_connection` method. This option is MySQL specific for now and it uses the `USE database_name` statement to switch the connection.

```ruby
CONN_MANAGER.with_connection(:c1, database_name) do |connection|
  connection.execute("SELECT 1")
end
```

Using non-persistent connections with `Octoshark::ConnectionManager` has the same API:

```ruby
CONN_MANAGER = Octoshark::ConnectionManager.new
```

Opening a new connection, executing query and closing a connection:

```ruby
CONN_MANAGER.with_connection(config) do |connection|
  connection.execute("SELECT 1")
end
```


### Using Octoshark with ActiveRecord models

ActiveRecord model can use Octoshark connection if we override the `Model.connection` method.

```ruby
class Post < ActiveRecord::Base
  def self.connection
    CONN_MANAGER.current_connection
  end
end
```

Or, to change the connection of many models, define a module and include it in models.

```ruby
module ShardingModel
  extend ActiveSupport::Concern

  module ClassMethods
    def connection
      CONN_MANAGER.current_connection
    end
  end
end
```

To use a specific database connection for a model, just open a `with_connection` block:

```ruby
CONN_MANAGER.with_connection(:c1) do
  # run queries on c1
  Post.first
end
```

`CONN_MANAGER.current_connection` returns the active connection while the execution is in the `with_connection` block or raises `Octoshark::Error::NoCurrentConnection` outside of the `with_connection` block. In some designs, falling back to the default database connection in the application might be preferable and that can be done using `CONN_MANAGER.current_or_default_connection`.

Connection switching is usually done on the entry-point of the application. In Rails applications that is from within an `around_filter` for controllers and similarly for background jobs:

```ruby
around_filter :select_connection

def select_connection(&block)
  CONN_MANAGER.with_connection(current_user.connection, &block)
end
```

### Conclusion

Scaling Rails horizontally and building sharding or multi-tenant architecture is an exciting project. It involves reuse and customization of some ActiveRecord components. I wish ActiveRecord connection management with Rails was done in a way to allow for extention or replacement instead of the shutgun integration like using `ActiveRecord::Base.clear_active_connections!` to return current thread connections back to the pool after each request.

With that in mind, I think it's a matter of how much of ActiveRecord we patch and how carefully we reuse its building blocks. Everything comes up with a maintenance cost, try optimize by minimizing it.
