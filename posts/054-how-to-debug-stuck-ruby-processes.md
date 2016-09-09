---
id: 54
title: "How to debug stuck Ruby processes"
date: 2015-05-30 10:03:00 +0200
author: Dalibor Nasevic
tags: [ruby, unix, process, gdb, strace]
summary: "Debugging stuck Ruby processes using gdb, strace and nrdebug."
---

Debugging OS components is fun, especially if you know the right tools and how to use them.

<p style="text-align: center">
  <img style="width: 100%" src="http://www.brendangregg.com/Perf/linux_observability_tools.png" alt="Global Day Of Coderetreat 2014" title="Global Day Of Coderetreat 2014">
  <span>© Brendan D. Gregg - <a href="http://www.brendangregg.com/linuxperf.html">http://www.brendangregg.com/linuxperf.html</a></span>
</p>

I remember once debugging a stuck Ruby process that turned out to be an infinite loop caused by a timezone change (different countries change DST at different dates). Interesting thing about it was that it took us a year to find and fix it because the year before it dissapeared shortly when DST for the other country changed. We couldn't reproduce it anymore, only until the next year when it started again...

Once you find and fix the issue everything looks reasonable. But, having the problem at hand and wondering what's causing it can be quite challenging and interesting or frustrating. It can take some time to get to the bottom of it.

One important [advice](http://www.slideshare.net/jamesgolick/how-to-debug-anything) with debugging is that when you put your debugging hat, you need to change your mindset and forget everything you think you know, and then use the available tools to get a third party opinion.

There are 2 useful tools to help you debug stuck processes: 

- `gdb` - attach and debug a running process
- `strace` - trace process system calls and signals

I found this well packed [Ruby script](https://github.com/newrelic/rpm/blob/master/bin/nrdebug) in New Relic's RPM tool that's not marketed well enough (none of the blog posts on GDB and Ruby seems to link to it). What the script does is, it connects to the process with GDB, gathers C and Ruby-level backtraces and some other useful process details and writes them to a file. Easy to use, just give it the PID and call with sudo permissions. If you're using `rvm` or `rbenv`, you will need `rvmsudo` or `rbenv sudo` to get the right permissions.

```bash
sudo ruby nrdebug.rb <pid>
```

Once we have the Ruby backtrace, it's usually very easy to identify why the process got stuck.

If you like to dig some more and understand some of the C level calls, Chad Fowler has an interesting [blog post](http://chadfowler.com/blog/2014/01/26/the-magic-of-strace/) on `strace`.
