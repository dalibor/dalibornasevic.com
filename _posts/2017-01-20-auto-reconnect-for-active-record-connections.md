---
layout: post
title: "Auto-reconnect for ActiveRecord connections"
date: 2017-01-20 09:00:00 +0100
categories: [rails, active record, mysql]
summary: "Custom auto-reconnect in Rails applications when using ActiveRecord connections."
permalink: /posts/77-auto-reconnect-for-activerecord-connections
---

ActiveRecord has a special config option `reconnect: true` for native auto-reconnect when using MySQL database. With that option in `database.yml`, it will try to reconnect only once as per the [manual](http://dev.mysql.com/doc/refman/5.7/en/auto-reconnect.html) before it fails:

> The MySQL client library can perform an automatic reconnection to the server if it finds that the connection is down when you attempt to send a statement to the server to be executed. If auto-reconnect is enabled, the library tries once to reconnect to the server and send the statement again.

```bash
>> Post.count
   (0.7ms)  SELECT COUNT(*) FROM `posts`
ActiveRecord::StatementInvalid: Mysql2::Error: Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (2): SELECT COUNT(*) FROM `posts`
```

Often we want to have more control over the reconnect strategy in order to give it more than one chance for the connection to recover. Imagine doing a master-slave fail-over or the database server is not stable and it takes about 10 seconds of downtime for the server to become available. To keep the service reliable we'll need to avoid dropping requests during that interval.

One way to do that would be to patch ActiveRecord to auto-reconnect with custom wait intervals like:

```ruby
module Mysql2AdapterPatch
  def execute(*args)
    # During `reconnect!`, `Mysql2Adapter` first disconnect and set the
    # @connection to nil, and then tries to connect. When connect fails,
    # @connection will be left as nil value which will cause issues later.
    connect if @connection.nil?

    begin
      super(*args)
    rescue ActiveRecord::StatementInvalid => e
      if e.message =~ /server has gone away/i
        in_transaction = transaction_manager.current_transaction.open?
        try_reconnect
        in_transaction ? raise : retry
      else
        raise
      end
    end
  end

  private
  def try_reconnect
    sleep_times = [0.1, 0.5, 1, 2, 4, 8]

    begin
      reconnect!
    rescue Mysql2::Error => e
      sleep_time = sleep_times.shift
      if sleep_time && e.message =~ /can't connect/i
        warn "Server timed out, retrying in #{sleep_time} sec."
        sleep sleep_time
        retry
      else
        raise
      end
    end
  end
end

require 'active_record/connection_adapters/mysql2_adapter'
ActiveRecord::ConnectionAdapters::Mysql2Adapter.prepend Mysql2AdapterPatch
```

When connection goes down, it starts trying to reconnect and finally succeeds when server is up.

```bash
>> Post.count
   (0.6ms)  SELECT COUNT(*) FROM `posts`
Server timed out, retrying in 0.1 sec.
Server timed out, retrying in 0.5 sec.
Server timed out, retrying in 1 sec.
Server timed out, retrying in 2 sec.
Server timed out, retrying in 4 sec.
   (1.1ms)  SELECT COUNT(*) FROM `posts`
=> 0
```

What's interesting to note here is that if during a transaction block the connection goes down and reconnects, it will continue executing the following queries and will just swallow the previous queries from the start of the transaction until the moment where connection dropped. That's why when trying to reconnect while `in_transaction` as per the patch above, it's safer to re-raise the connect error.

Here's an example to demonstrate that edge-case:

```ruby
Post.transaction do
  Post.create
  sleep 5
  Post.count
end
```

If the connection is dropped while on the `sleep` call, and then reconnects, it will re-raise the dropped connection error to stop executing following queries because the `Post.create` will not get created.

```bash
   (0.3ms)  BEGIN
  SQL (0.2ms)  INSERT INTO `posts` (`created_at`, `updated_at`) VALUES ('2017-01-18 20:18:14', '2017-01-18 20:18:14')
   (0.2ms)  SELECT COUNT(*) FROM `posts`
Server timed out, retrying in 0.1 sec.
Server timed out, retrying in 0.5 sec.
Server timed out, retrying in 1 sec.
Server timed out, retrying in 2 sec.
   (0.1ms)  ROLLBACK
ActiveRecord::StatementInvalid: Mysql2::Error: MySQL server has gone away: SELECT COUNT(*) FROM `posts`
```

I hope you find this info useful, please share in the comments if you have any thoughts.
