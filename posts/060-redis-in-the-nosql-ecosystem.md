---
id: 60
title: "Redis in the NoSQL ecosystem"
date: 2015-11-18 08:35:00 +0100
author: Dalibor Nasevic
tags: [redis, nosql]
summary: "Redis storage and what kind of problems it helps solve."
---

**Note**: This is a republish of an article I wrote back in December 2011 on [Siyelo blog](http://blog.siyelo.com/redis-in-the-nosql-ecosystem/).

Redis (<strong>RE</strong>mote <strong>DI</strong>ctionary <strong>S</strong>erver) is key-value in-memory database storage that also supports disk storage for persistence. It supports several [data types](http://redis.io/topics/data-types-intro): Strings, Hashes, Lists, Sets and Sorted Sets; implements [publish/subscribe](http://redis.io/topics/pubsub) messaging paradigm and has [transactions](http://redis.io/topics/transactions).

All these different options place Redis in the NoSQL ecosystem somewhere between simple caching systems like memcache and feature-heavy document databases like MongoDB and CouchDB. The question is: when do you pick Redis over other NoSQL systems?

### Give us some ACID

Before going into the use-cases, let's say one more important thing about Redis. Redis is single threaded which allows it to be [ACID compliant](http://en.wikipedia.org/wiki/ACID) (Atomicity, Consistency, Isolation and Durability). Other [NoSQL databases](http://nosql-database.org/) generally don't provide ACID compliance, or they provide it partially. By default Redis trades some durability in return for speed (default **fsync()** is set to **everysec** which means it will save data to disk every second). But, because Redis is very configurable, you can change how many times it will fsync() the data on disk by using the **appendfsync** command (you can use **appendfsync always** and system will fsync data after every write - it's slow but safest!).

### When to use Redis?

In your production environment you don't need to switch to Redis. You can just [use it for the new things](http://antirez.com/post/take-advantage-of-redis-adding-it-to-your-stack.html) you are implementing. Always pick right tool for the job. For stable, predictable and relational data pick relational database. For temporary, highly dynamic data pick NoSQL database; schema changes can be a big problem and can take forever in big relational databases.

If you have a highly dynamic data that changes often, storage tends to grow quickly and further involves schema adjusting to store them, then Redis can be a potential good choice.

If you need a more featured document oriented database that allows you to perform **range queries**, **regular expression searches**, **indexing**, and **MapReduce** you should check **MongoDB**, **CouchDB** or similar. If you need a simple **caching** with better expiration algorhitms than Redis has then you should check **memcache**.

### Redis Use-Cases

* Access Logger: When you need to log different activities, Redis is a good solution. Because Redis has to keep all stored objects in memory, don't forget to archive data to relational/document database because it can grow quickly after some time.
* Counting Downloads: [Rubygems](https://github.com/rubygems/rubygems.org) uses Redis for counting downloads of gems. See how it's implemented in the [Download](https://github.com/rubygems/rubygems.org/blob/master/app/models/download.rb) model.
* High Score tables: Redis supports data type functions that can be very [handy](http://www.agoragames.com/blog/2011/01/01/creating-high-score-tables-leaderboards-using-redis/).
* Who's Online: Use Redis to implement [who is online](http://www.lukemelia.com/blog/archives/2010/01/17/redis-in-practice-whos-online/) logic in your application.
* Caching: Finding followings, followers or similar is very expensive operation in relational databases, use Redis to cache these data.
* Queues: [Sidekiq](https://github.com/mperham/sidekiq) and [Resque](https://github.com/defunkt/resque) are Redis-backed Ruby libraries for creating background jobs, placing them on multiple queues, and processing them later.
* Live debugging: You need to do live debugging or roll out new features for production testing for specific users only - [Rollout](https://github.com/jamesgolick/rollout) gem does exactly that.
* HN style social news site written in Ruby/Sinatra/Redis/jQuery - [lamernews](https://github.com/antirez/lamernews).


### Redis console

You can use redis-cli to connect to a local or remote Redis server and call commands. Here is an example (first connect to the server using: `redis-cli -p 6379`):


### Redis from Ruby

Here is an example using Ruby to execute commands on Redis server. You need to install [redis gem](https://github.com/redis/redis-rb) by executing `gem install redis` first.

Learn more about Redis [commands](http://redis.io/commands) and give some speed to your web applications for free.

### Real world Redis example

At the end, lets show a real world example how Redis is used in [Rubygems](http://rubygems.org/) for caching gem downloads count. For keeping the code snippet short some code is ommited and/or simplified.

First, in the initializer a new redis object as a global variable `$redis` is instantiated. This object is used in Download model for updating the downloads count for a gem with `self.incr(name)` method and reading the downloads count for a gem with `self.for_rubygem(name)` method. Rubygems is using Sinatra application `Hostess` to speed up gem downloads. Sinatra application is registered as a middleware in the application.rb config file. This application  defines `get "/gems/*.gem"` route which triggers the downloads count to be updated in the Redis database.

Rubygems is doing more download stats like: total downloads, downloads per gem, downloads for a specific gem version, etc. Check out the source code at [Github](https://github.com/rubygems/rubygems.org) for more details.
