---
layout: post
title: "Implementing a custom Redis and in-memory bloom filter"
date: 2018-09-11 21:00:00 +0100
categories: [redis, ruby, bloom-filter]
summary: "In our email marketing products, we changed our bloom filter implementation by using a custom Redis and an in-memory bloom filter written in Ruby. We will go through iterations at solving a real problem and writing a custom bloom filter from scratch."
permalink: /posts/82-redis-ruby-bloom-filter
---

My first publication on the [GoDaddy Open Source Blog](https://godaddy.github.io) is out. Here is what it is about:

> In our email marketing and delivery products ([GoDaddy Email Marketing](https://www.godaddy.com/online-marketing/email-marketing) and [Mad Mimi](https://madmimi.com)) we deal with lots of data and work with some interesting data structures like bloom filters. We made an optimization that involved replacing an old bloom filter built in-memory and stored on Amazon S3 with a combination of a Redis bloom filter and an in-memory bloom filter. In this blog post we’ll go through the reasoning for this change as well as the details of the bloom filter implementation we landed on. Let’s first start with a brief introduction to bloom filters...

Read the [full article](https://godaddy.github.io/2018/09/11/redis-ruby-bloom-filter/).
