---
layout: post
title: "Ruby: stack level too deep (SystemStackError)"
date: 2009-10-11 15:22:00 +0200
categories: [ruby, exceptions]
summary: "Fixing Ruby: stack level too deep by changing system limits with ulimit."
permalink: /posts/5-ruby-stack-level-too-deep-systemstackerror
---

Last months I worked on a web application that measures popularity of words in internet media, can calculate popularity values and compare different words values. It's similar to Google Trends, except that here information are time critical with live updates every 5 minutes.

Implementation of the crawler was a little bit specific because words in different html tags have different values, but using [Hpricot](http://github.com/whymirror/hpricot "Hpricot gem") html parser it was just a few lines of code to implement that. From time to time when new media were added, crawler would encounter some problem specific to that site, that is fixes easily and everything was going well again. It was all well until recently when I started getting `stack level too deep (SystemStackError)` on some of the recently added media in the application.

I was sure that there was no endless recursion in the code (other sites were going well). After a bit of research I found out that newer versions of Ruby (production server used Ruby 1.8.6) may solve the problem with the stack level. But after installing Ruby 1.8.7 with [Ruby Version Manager](http://github.com/wayneeseguin/rvm "Ruby Version Manager") on the production server, I continued getting the same error again.

Then, I thought it may be some bug or issue with Hpricot having deeper recursion than it would be with [Nokogiri](http://github.com/tenderlove/nokogiri "Nokogiri gem"), but after a quick rewrite using Nokogiri parser, it continued again to display the same `stack level too deep (SystemStackError)` exception for the same media.

Next possible solutions that came to my mind was: write custom html parser (which would be time consuming by debugging invalid html tags), or change the stack level if it is possible!? I was getting the error only on production server with 64 bit architecture, and not on development machine with 32 bit architecture.

Finally, I found out about [ulimit](http://ss64.com/bash/ulimit.html "Bash unlimit") command which basically provides control over the resources available to the shell and processes started by it, on systems that allow such control.

You can see the current limits with `ulimit -a`:

```bash
dalibor@kreator:~$ ulimit -a
core file size (blocks, -c) 0
data seg size (kbytes, -d) unlimited
scheduling priority (-e) 20
file size (blocks, -f) unlimited
pending signals (-i) 16382
max locked memory (kbytes, -l) 64
max memory size (kbytes, -m) unlimited
open files (-n) 1024
pipe size (512 bytes, -p) 8
POSIX message queues (bytes, -q) 819200
real-time priority (-r) 0
stack size (kbytes, -s) 8192
cpu time (seconds, -t) unlimited
max user processes (-u) unlimited
virtual memory (kbytes, -v) unlimited
file locks (-x) unlimited
```

And, you can change the stack size using `ulimit -s` command.

```bash
ulimit -s 16384
```

After doubling the stack size to 16384 I stopped getting the `stack level too deep (SystemStackError)` exception.

If you add the above line to .bashrc file on the server, every time you ssh to that machine, it will change the stack size and run all processes in the new environment.

In the end, I solved the problem with that simple solution, hopefully that will prevent you from spending the whole day experimenting with different potential solutions if you have a similar problem. :)
