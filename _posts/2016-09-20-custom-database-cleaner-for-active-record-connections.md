---
layout: post
title: "Custom Database Cleaner for ActiveRecord connections"
date: 2016-09-20 08:30:00 +0100
categories: [rails, active record, octoshark, mysql]
summary: "Custom database cleaner for cleaning multiple databases in Rails applications when using dynamic ActiveRecord connections."
permalink: /posts/70-custom-database-cleaner-for-active-record-connections
---

Having a clean database state before each test is crucial for avoiding intermittent or random test failures. This kind of test failures usually happen due to the order of tests execution and when some of the previous tests will leave artifacts that cause future tests to fail.

In this blog post I will discuss strategies for cleaning multiple databases and how to write a custom database cleaner for dynamic ActiveRecord connections. By dynamic connections I mean connections that are established with a configuration other than the standard one specified with `database.yml`.

In the examples we will use [Octoshark](/posts/69-managing-activerecord-connections-with-octoshark) connection managers in a multi-tenant architecture, but things are applicable for other similar tools based on ActiveRecord and other multi-database test setups.


### Cleaning multiple databases with Database Cleaner

The most popular tool for cleaning databases with Ruby that supports few ORMs (Object Relational Mappers) is [DatabaseCleaner](https://github.com/DatabaseCleaner/database_cleaner). It has 3 cleaning strategies: truncation, transaction and deletion.

The usual practice is to clean the database before test suite with truncation or deletion strategy depending on which one is faster for the structure of tables. And then clean the database after each test using transaction strategy if everything runs in a single process, or truncation or deletion strategy if there are multiple processes that touch the database (usually when running Javascript tests with a driver that runs in a different process than the test process).

DatabaseCleaner accepts connection pools to configure the cleaning. So, when using `Octoshark::ConnectionPoolsManager`, we can configure it with RSpec in the following way:


```ruby
config.before(:suite) do
  setup_database_cleaner
  DatabaseCleaner.clean_with(:truncation)
end

config.before(:each) do
  setup_database_cleaner
  DatabaseCleaner.start
end

config.after(:each) do
  DatabaseCleaner.clean_with(:transaction)
end

def setup_database_cleaner
  DatabaseCleaner[:active_record, {connection: ActiveRecord::Base.connection_pool}]
  Octoshark::ConnectionPoolsManager.connection_managers.each do |manager|
    manager.connection_pools.each_pair do |connection_name, connection_pool|
      DatabaseCleaner[:active_record, {connection: connection_pool}]
    end
  end
end
```

It's all standard stuff, except the `setup_database_cleaner` method. That method configures DatabaseCleaner to clean the main application database using the standard Rails connection pool and clean the other databases using Octoshark connection pools.


### Cleaning multiple databases with Custom Database Cleaner

An alternative to DatabaseCleaner is [DatabaseRewinder](https://github.com/amatsuda/database_rewinder). DatabaseRewinder supports only ActiveRecord as ORM and has only one cleaning strategy that uses `DELETE` SQL statements. It is smart in a way that it memorizes which tables had inserts during tests and cleans only those tables in order to make the test suite faster.

When using non-persistent connections with `Octoshark::ConnectionManager` or when connections are established dynamically, [DatabaseCleaner](https://github.com/DatabaseCleaner/database_cleaner/blob/master/lib/database_cleaner/active_record/base.rb#L17) and [DatabaseRewinder](https://github.com/amatsuda/database_rewinder/blob/4d3d6da5bcefe21edfe01615449858c98e283f50/lib/database_rewinder.rb#L15) cannot be configured in the test setup because connections and databases are created at a later point.

We can write a custom database cleaner that will work in this scenario. In the following example we have a testing setup of a multi-tenant application that uses 2 non-persistent Octoshark connection managers, one for the main (core) database and another one for the tenant database used by each user in the system:

```ruby
CoreDBManager   = Octoshark::ConnectionManager.new
TenantDBManager = Octoshark::ConnectionManager.new
```

This custom database cleaner is hugely inspired by how DatabaseRewinder tracks which tables to clean. It is written for the MySQL connection adapter, and it can be done for other adapters too.

```ruby
module CustomDatabaseCleaner
  INSERT_REGEX = /\AINSERT(?:\s+IGNORE)?\s+INTO\s+(?:\.*[`"]?(?<table>[^.\s`"]+)[`"]?)*/i

  @@tables_with_inserts = []

  class << self
    def record_inserted_table(connection, sql)
      match = sql.match(INSERT_REGEX)

      if match && match[:table] && tables_with_inserts.exclude?(match[:table])
        tables_with_inserts << match[:table]
      end
    end

    def clean_all
      with_core_db_connection do |connection|
        clean_tables(connection)
      end

      reset_tables_with_inserts
    end

    def clean
      with_core_db_connection do |connection|
        clean_tables(connection, { 'users' => [CURRENT_USER.id] })
      end

      CURRENT_USER.with_tenant do |connection|
        clean_tables(connection)
      end

      reset_tables_with_inserts
    end

    private
    def with_core_db_connection(&block)
      CoreDBManager.with_connection(ActiveRecord::Base.configurations[Rails.env].symbolize_keys, &block)
    end

    def clean_tables(connection, keep_data = {})
      tables_to_clean = connection.tables.reject { |t| t == ActiveRecord::Migrator.schema_migrations_table_name }
      tables_to_clean = tables_to_clean & tables_with_inserts if tables_with_inserts.present?

      tables_to_clean.each do |table|
        connection.disable_referential_integrity do
          table_name = connection.quote_table_name(table)
          keep_ids   = keep_data[table]

          if keep_ids
            connection.execute("DELETE FROM #{table_name} WHERE id NOT IN (#{keep_ids.join(',')});")
          else
            connection.execute("DELETE FROM #{table_name};")
          end
        end
      end
    end

    def reset_tables_with_inserts
      @@tables_with_inserts = []
    end

    def tables_with_inserts
      @@tables_with_inserts
    end
  end
end

module CustomDatabaseCleaner
  module InsertRecorder
    def execute(sql, *)
      CustomDatabaseCleaner.record_inserted_table(self, sql)
      super
    end

    def exec_query(sql, *)
      CustomDatabaseCleaner.record_inserted_table(self, sql)
      super
    end
  end
end

require 'active_record/connection_adapters/abstract_mysql_adapter'
ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter.send(:prepend, CustomDatabaseCleaner::InsertRecorder)
```

We inject the custom database cleaner to record inserts for `execute` and `exec_query` methods by prepending the `CustomDatabaseCleaner::InsertRecorder` module to AbstractMysqlAdapter.

`CustomDatabaseCleaner` checks if SQL queries match the `INSERT_REGEX` and keeps a list of tables with inserts. `CustomDatabaseCleaner.clean_all` and `CustomDatabaseCleaner.clean` methods are similar to what other database cleaners do and can be used like this with RSpec config:


```ruby
config.before(:suite) do
  TenantManager.drop_all
  DatabaseCleaner.clean_all
end

config.after(:each) do
  DatabaseCleaner.clean
end
```

Before test suite, we make a clean state by dropping all tenant databases that were created by the previous tests run using `TenantManager.drop_all` method that just executes a drop table SQL statement and we clean core database with `CustomDatabaseCleaner.clean_all`.

Before each test, we clean both core and tenant databases and we care not to remove the current user record from the core database that acts as a fixture in this test setup.


### Conclusion

Figuring out a test setup for Rails applications that work with multiple databases in scenarious like sharding or multi-tenant can be tricky, especially if using non-persistent database connections. Once figured out how to deal with the connections, writing the custom database cleaner becomes the easy part. It's just a small module that runs `DELETE FROM table_name` SQL statements with a bit of optimization when to run. It would be interesting to see some other custom approaches for test suite configurations when working with multiple databases with Rails.
