---
layout: post
title: "Simple way to test IO in Ruby"
date: 2013-01-28 22:44:00 +0100
categories: [ruby, rspec]
summary: "Testing IO with Ruby in a simple and custom way."
permalink: /posts/39-simple-way-to-test-io-in-ruby
---

I worked on a small CLI (Command Line Interface) in Ruby over the weekend and I wanted to test the user input on the command line and the output that the program will print out. I figured out this simple FakeIO class that helps me do that.

```ruby
# 'support/fake_io'
class FakeIO

  attr_accessor :input, :output

  def initialize(input)
    @input = input
    @output = ""
  end

  def gets
    @input.shift.to_s
  end

  def puts(string)
    @output << "#{string}\n"
  end

  def write(string)
    @output << string
  end

  def self.each_input(input)
    io = new(input)
    $stdin = io
    $stdout = io

    yield

    io.output
  ensure
    $stdin = STDIN
    $stdout = STDOUT
  end
end
```

Here is a small spec to demonstrate how it can be used:

```ruby
require 'support/fake_io'

class CLI
  def self.run
    loop do
      input = $stdin.gets
      break if input.empty?
      $stdout.puts input
    end
  end
end

describe "CLI" do
  it "can read and write to command line" do
    output = FakeIO.each_input(["line1", "line2", "line3"]) { CLI.run }
    output.should == "line1\nline2\nline3\n"
  end
end
```

**FakeIO.each\_input** method accepts an array of input lines that will be entered on the command line and a block that calls the program. It returns back what will be printed out on the command line as output so we can write expectations on it. We inject the FakeIO instance on the fly as IO dependency and after the block we revert back to default IO.
