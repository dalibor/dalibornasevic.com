---
id: 41
title: "EuRuKo 2013 notes"
date: 2013-06-30 19:33:00 +0200
author: Dalibor Nasevic
tags: [euruko, ruby, rails, matz]
---

[EuRuKo 2013](http://euruko2013.org/ "EuRuKo 2013") is over. It happened in Athens and was perfectly organized by the local volunteers. It's the biggest Ruby conference in Europe, community driven and non profit.

I had a chance to meet the creator of Ruby, Yukihiro "matz" Matsumoto and take a photo with him.

![Dalibor Nasevic & Yukihiro "matz" Matsumoto](/images/dalibor-nasevic-matz.jpg "Dalibor Nasevic & Yukihiro "matz" Matsumoto")

Here are my quick notes on some of the presentations that captured my attention. For full listing please check the official [conf schedule](http://euruko2013.org/schedule/ "EuRuKo 2013 schedule").

### Day 1

Yukihiro "matz" Matsumoto , the creator of the Ruby programming language, opened the conference with his keynote about being a language designer. He encouraging everyone to design their own programming language, DSL, etc. He also talked about the freedom of being a designer and decision maker.

Pat Shaughnessy gave a presentation on [Functional Programming and Ruby](https://speakerdeck.com/pat_shaughnessy/functional-programming-and-ruby "Functional Programming and Ruby") where he compared Haskell and the functional aspects of Ruby.

Simon Kröger & Grzegorz Witek gave an interesting presentation in form of a case study about how they managed to build multi-threaded Rails application with MRI 1.9 that can handle up to 200k requests per minute without going the JRuby or Event Machine route.

### Day 2

Koichi Sasada, core Ruby contributor from Japan, opened the second day of the conference. He gave a keynote on Ruby Garbage Collector [Towards more efficient Ruby 2.1](http://www.atdot.net/~ko1/activities/Euruko2013-ko1.pdf "Towards more efficient Ruby 2.1"). The beginning of his talk was quite funny. He made great atmosphere in the audience by making few jokes on behalf of matz while talking about the history of Ruby. I suggest you check his slides.

Benjamin Smith from Pivotal Labs had an interesting presentation on [Architecting your Rails app for success!](https://speakerdeck.com/benjaminleesmith/architecting-your-rails-app-for-success-euruko-2013 "Architecting your Rails app for success!"). He explained how to split your Rails application into different applications using Rails engines and how to take control over dependencies by using service objects. 

Steve Klabnik had an interesting keynote on being an Irresponsible Programmer and he told us few stories on his takeover of some of [why's](http://en.wikipedia.org/wiki/Why_the_lucky_stiff "why the lucky stiff") projects, his involvement in open-source and why he switched to Linux (thumbs up). He also demonstrated the idea of "Functional Reactive Programming" by live-coding an example using the shoes gem.

Ben Lovell gave a presentation on [Achieving zomgscale with Celluloid and JRuby!](https://speakerdeck.com/benlovell/achieving-zomgscale-with-celluloid-and-jruby "Achieving zomgscale with Celluloid and JRuby!") and Javier Ramírez gave a presentation about all the things you can do with Redis "Fun with Ruby and Redis".

Next EuRuKo is in Ukraine 2014.
