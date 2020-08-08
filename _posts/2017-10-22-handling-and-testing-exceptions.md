---
layout: post
title: "A Walkthrough for Handling and Testing Exceptions"
date: 2017-10-22 10:00:00 +0100
categories: [ruby, rspec, testing, exceptions]
summary: "In a previous blog posts I wrote about the problem of overusing exceptions, and in this one we'll look at some exception handling and testing practices."
permalink: /posts/80-handling-and-testing-exceptions
---

In a previous blog posts I wrote about the problem of [overusing exceptions](/posts/52-don-t-overuse-exceptions), and in this one we'll look at some exception handling and testing practices.

To start with, let's define `LinkCounter` class. `LinkCounter` counts how many links are on a web page. It is initialized with a url, it uses [Faraday](https://github.com/lostisland/faraday) HTTP client to fetch the page content and it uses [Nokogiri](https://github.com/sparklemotion/nokogiri) to parse the HTML content.

```ruby
require 'faraday'
require 'nokogiri'

class LinkCounter
  def initialize(url)
    @url = url
  end

  def count
    doc.css('a').count
  end

  private

  def doc
    Nokogiri::HTML.parse(content)
  end

  def content
    connection.get(@url).body
  end

  def connection
    Faraday.new
  end
end
```

Then, we can use it like this:

```ruby
puts LinkCounter.new('https://example.com').count # 1
```

Pretty simple so far.

### What could possibly go wrong?

To improve the robustness of our `LinkCounter` we need to think about what could fail? We identify the Faraday's `connection.get` call, doing the `GET` HTTP request, as one with highest probably of failure because it depends on the reliability of the network.

> Always rescue very specific exceptions. Never rescue `Exception` and avoid rescuing `StandardError` too because it can hide unexpected errors like `NameError` and `NoMethodError`. See ruby's [exception hierarchy](http://blog.nicksieger.com/articles/2006/09/06/rubys-exception-hierarchy/).

In order to rescue the very specific exceptions, we need to figure out all the exceptions that Faraday can raise. Good libraries usually would have a separate file defining all the errors like it's the case with [Faraday errors](https://github.com/lostisland/faraday/blob/master/lib/faraday/error.rb) or [Redis errors](https://github.com/redis/redis-rb/blob/master/lib/redis/errors.rb) as another example.

Looking at the Faraday error definitions we can see it has the following hierarchy:

```ruby
StandardError
  Faraday::Error
    Faraday::MissingDependency
    Faraday::ClientError
      Faraday::ConnectionFailed
      Faraday::ResourceNotFound
      Faraday::ParsingError
      Faraday::TimeoutError
      Faraday::SSLError
```

### Exploring Faraday errors

We need to explore and understand at what conditions each of the Faraday errors could happen.

So, if we define very small open timeout, we'll see `Faraday::ConnectionFailed` error.

```ruby
Faraday.new(request: { open_timeout: 0.1 }).get('https://example.com') 

# Faraday::ConnectionFailed: execution expired
```

If we define small read timeout, we'll get `Faraday::TimeoutError`.

```ruby
Faraday.new(request: { open_timeout: 1, timeout: 0.1 }).
  get('https://example.com') 

# Faraday::TimeoutError: Net::ReadTimeout
```

Note here that if we set only the `timeout` value, the `open_timeout` will use the same value and we wouldn't be able to reproduce the `Faraday::TimeoutError` error, but we'll get `Faraday::ConnectionFailed` error again.

For docs on timeouts in other popular Ruby gems, you can check out this popular [github repo](https://github.com/ankane/the-ultimate-guide-to-ruby-timeouts).

If we try `GET` request to a nonexistent host we get `Faraday::ConnectionFailed`.

```ruby
Faraday.get('https://example.nonexistent.com') 

# Faraday::ConnectionFailed: Failed to open TCP connection to example.nonexistent.com:443 (getaddrinfo: Name or service not known)
```

 Note that in this case we also have a nice exception message `getaddrinfo: Name or service not known` that distinguishes this error from the error that happens when a connection cannot be opened for an existing host.

If we request a website without SSL support, we get `Faraday::SSLError`.

```ruby
Faraday.get('https://ruby.mk')

# Faraday::SSLError: SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed
```

Finally, if we configure Faraday to raise exceptions on 40x and 50x responses, we'll see it raises `Faraday::ResourceNotFound` error for 404 response:

```ruby
Faraday.new do |faraday| 
  faraday.use Faraday::Response::RaiseError
  faraday.adapter Faraday.default_adapter
end.get('https://httpstat.us/404')

# Faraday::ResourceNotFound: the server responded with status 404
```

And, we'll get `Faraday::ClientError` for 500 response:

```ruby
Faraday.new do |faraday| 
  faraday.use Faraday::Response::RaiseError
  faraday.adapter Faraday.default_adapter
end.get('https://httpstat.us/500')

# Faraday::ClientError: the server responded with status 500
```

Note that in the last two examples I use this handy [httpstat.us](https://httpstat.us/) service that returns the requested status code.

### Handling exceptions

Based on our previous exploration, we conclude that we will retry `Faraday::TimeoutError` and `Faraday::ConnectionFailed` errors except the case when the host does not exist, i.e. exception message is `getaddrinfo: Name or service not known`.

Let's define a general purpose `Retryable` module for that.

```ruby
module Retryable
  SLEEP_INTERVAL = 0.4

  def with_retries(retries: 3, retry_skip_reason: nil, rescue_class: )
    tries = 0

    begin
      yield
    rescue *rescue_class => e
      tries += 1
      if tries <= retries && (retry_skip_reason.nil? || !e.message.include?(retry_skip_reason))
        sleep sleep_interval(tries)
        retry
      else
        raise
      end
    end
  end

  private

  def sleep_interval(tries)
    (SLEEP_INTERVAL + rand(0.0..1.0)) * tries ** 2
  end
end
```

From this module we can use `with_retries` method that by default will retry 3 times the error with an exponential and randomized sleep interval. It also accepts an option `retry_skip_reason` to skip retry when a specific exception message matches the skip reason.

We can now use the `Retryable` module with `LinkCounter` as follows:

```ruby
class LinkCounter
  include Retryable

  # the rest of the code

  def content
    with_retries(
      rescue_class: [Faraday::TimeoutError, Faraday::ConnectionFailed],
      retry_skip_reason: 'getaddrinfo: Name or service not known'
    ) do
      connection.get(@url).body
    end
  end

  def connection
    @connection ||= Faraday.new(
      request: { open_timeout: 10, timeout: 30 }
    ) do |faraday| 
      faraday.use Faraday::Response::RaiseError
      faraday.adapter Faraday.default_adapter
    end
  end
end
```

The other exceptions that Faraday could raise are not temporary and we don't want to retry them. We could either rescue and ignore them or let them raise and be tracked by the exceptions tracking system we have in place. It depends on the use case and if they stop or not our running system.

### Testing exception retries

> Always provide a test / spec that documents why each exception is being handled. This is very important for future readers of the code to understand the failure context better.

We'll use RSpec to test the exception retries. If we focus on the `Faraday::TimeoutError`, the scenarios that we want to test are that 1) an error is retried and 2) retry is not infinite.

```ruby
describe LinkCounter do
  let(:url) { 'http://example.com' }

  it "retries read timeout errors" do
    link_counter = LinkCounter.new(url)
    connection = link_counter.send(:connection)
    expect(connection).to receive(:get).once.and_raise(Faraday::TimeoutError)
    expect(connection).to receive(:get).once.and_return(double(body: '<a href="#">link</a>'))
    allow_any_instance_of(Retryable).to receive(:sleep_interval).and_return(0)

    expect(link_counter.count).to eq(1)
  end

  it "re-raises read timeout error after exausting error retries" do
    link_counter = LinkCounter.new(url)
    connection = link_counter.send(:connection)
    expect(connection).to receive(:get).exactly(4).times.and_raise(Faraday::TimeoutError)
    allow_any_instance_of(Retryable).to receive(:sleep_interval).and_return(0)

    expect {
      expect(link_counter.count)
    }.to raise_error(Faraday::TimeoutError)
  end
end
```

In the above example we use [rspec-mocks](https://github.com/rspec/rspec-mocks) to set expectations for the consecutive calls. In the first spec, for the first `GET` request we expect timeout error and then for the second call we return a body with content that has one link. In the second spec, we expect 4 `GET` requests (1 + 3 retries) and all of them raising timeout error resulting in a final exception being raised.

If you are using [mocha](https://github.com/freerange/mocha), you can set expectations for consecutive invocations like this:

```ruby
connection.expects(:get).
  raises(Faraday::TimeoutError).
  then.returns(stub(get: body: '<a href="#">link</a>'))
```

Let's now cover the other two cases that are 3) retrying open timeout errors and 4) not retrying unknown host errors.

```ruby
describe LinkCounter do
  # the rest of the specs

  it "retries open timeout errors" do
    link_counter = LinkCounter.new(url)
    connection = link_counter.send(:connection)
    expect(connection).to receive(:get).once.and_raise(Faraday::ConnectionFailed.new('execution expired'))
    expect(connection).to receive(:get).once.and_return(double(body: '<a href="#">link</a>'))
    allow_any_instance_of(Retryable).to receive(:sleep_interval).and_return(0)

    expect(link_counter.count).to eq(1)
  end

  it "does not retry unknown host errors" do
    link_counter = LinkCounter.new(url)
    connection = link_counter.send(:connection)
    expect(connection).to receive(:get).once.and_raise(Faraday::ConnectionFailed.new("Failed to open TCP connection to example.nonexistent.com:80 (getaddrinfo: Name or service not known)"))
    allow_any_instance_of(Retryable).to receive(:sleep_interval).and_return(0)

    expect {
      expect(link_counter.count)
    }.to raise_error(Faraday::ConnectionFailed)
  end
end
```

### Final notes

In this walkthough I did not use TDD intentionally to focus on these other important details. And also, we are often surprised by exceptions we cannot predict in development but they appear in production and we handle them after the fact. The important thing is to always document with a spec the very specific exception that happens, in which conditions it happens so that others can understand, improve and refactor the code in the future.
