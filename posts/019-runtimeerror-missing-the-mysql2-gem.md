---
id: 19
title: "RuntimeError: !!! Missing the mysql2 gem"
date: 2011-01-22 22:31:00 +0100
author: Dalibor Nasevic
tags: [rails3, upgrade, database, mysql]
summary: "The confusing error for missing mysql2 gem in Rails 3 application is actually a database.yml config issue."
---

I started migrating my blog from Rails 2 to Rails 3, working up my deployment setup using rvm and phusion passenger. When setting up the staging server, I run into this error:

```bash
RuntimeError: !!! Missing the mysql2 gem. Add it to your Gemfile: gem 'mysql2'
```

`mysql2` gem was already in the Gemfile. After looking around, I found out that I had wrong database adapter because, of course, I have copied the old database.yml from Rails 2 application where is was:

```yaml
production:
  adapter: mysql
  encoding: utf8
  reconnect: false
  database: blog
  pool: 5
  username: root
  password: 
  socket: /var/run/mysqld/mysqld.sock
```

The solution is just to change the adapter from `mysql` to `mysql2`:

```yaml
production:
  adapter: mysql2
  encoding: utf8
  reconnect: false
  database: blog
  pool: 5
  username: root
  password: 
  socket: /var/run/mysqld/mysqld.sock
```
