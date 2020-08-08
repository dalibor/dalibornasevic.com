---
layout: post
title: "Tracing Ruby Code"
date: 2015-02-28 17:46:00 +0100
categories: [ruby, debug]
summary: "Tracing Ruby code execution with TracePoint."
permalink: /posts/51-tracing-ruby-code
---

I'm not a big fan of using debugging tools with Ruby. When I want to check something I'll often just use `puts` (or even `raise` when debugging controller actions/views because it's easier to see the result in browser instead of looking in the logs).

However, there are times when I want to look deeper in the source code and understand how an external library call works. And, when it's some complex code, it becomes difficult to quickly familiarize and get a sense of where things are placed. In such situation, having a trace log with all execution calls in a `file:line` format is quite handy to give me the big picture.

Thanks to Ruby's dynamic nature, we can inspect what's going on during execution. In the old Ruby days, `set_trace_func` was the real thing, but since Ruby 2.0 it is the OO equivalent `TracePoint`.

Here's a simple `trace` method that will write the `line:file` trace points to `/tmp/trace.txt` file.

```ruby
def trace(event_type = :call, *matchers)
  points = []

  tracer = TracePoint.new(event_type) do |trace_point|
    if matchers.all? { |match| trace_point.path.match(match) }
      points << { file: trace_point.path, line: trace_point.lineno, }
    end
  end

  result = tracer.enable { yield }

  File.open('/tmp/trace.txt', 'w') do |file|
    points.each do |point|
      file.puts "#{point[:file]}:#{point[:line]}"
    end
  end

  result
end
```

Once I have the `/tmp/trace.txt` trace log, I would use Vim to navigate the files and get a sense of how code is structured in the library (using `gF` to navigate files and go to the specific line or using [file-line](https://github.com/bogado/file-line) plugin for opening files at specific line).

By default it will `trace` events of type `:call`:

```ruby
trace(:call) do
  FactoryGirl.create(:account) # call we want to trace
end
```

`event_type` can be any of the following:

```ruby
 :line,                      # line of code
 :call, :return              # ruby method
 :class, :end                # start/end of class/module
 :c_call, :c_return          # MRI itself
 :raise                      # exception
 :b_call, :b_return          # ruby block
 :thread_begin, :thread_end  # thread
```

As optional arguments, `trace` method accepts file name `matchers` that I find useful to filter out the trace points to what might be of my interest. For example, if I want to focus on the code in `FactoryGirl` gem (but not ActiveRecord and such), I'll just filter out by file names matching `factory_girl`.

```ruby
trace(:call, 'factory_girl') do
  FactoryGirl.create(:account) # call we want to trace
end
```

[TracePoint](http://ruby-doc.org/core-2.2.0/TracePoint.html) is capable of much more that this and debuggers such as [ByeBug](https://github.com/deivid-rodriguez/byebug) use it, so be sure to check the docs.

One final tip for the end. If you just want to identify the source location of a method call and start looking at the source code from there, you can just do:

```ruby
FactoryGirl.method(:create).source_location
```
