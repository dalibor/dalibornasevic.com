---
id: 79
title: "Debugging Rails Views in Production"
date: 2017-06-11 11:00:00 +0100
author: Dalibor Nasevic
tags: [rails, views, debugging]
summary: "How to debug Rails views in production."
---

Today I'm going to share a quick technique for debugging Rails views in production. When there is a nasty bug or performance issue, the easiest way to find the cause is to reproduce it in the environment where it's happening with the real data and in the real context.

The technique involves monkey-patching production code in Rails console that adds print statements, defines or redefines methods that when called will get us some insights to understand what's going on. Investigating and isolating segment by segment, usually using read only operations to prevent undesirable data side effects, and we'll eventually figure out the cause.

It's easy to use this approach with small and isolated classes and methods that can be initialized and called without much setup, but we can use the same approach with the standard request-response cycle to debug views with [ConsoleMethods](http://api.rubyonrails.org/classes/Rails/ConsoleMethods.html) from Rails.

### Find the slow partial

Say we have a controller action that we want to investigate where exactly it's getting slow in the views. Btw, imagine that this is happening only for a single user in production and transaction average metric is not revealing us any useful info.

```ruby
class HomeController < ApplicationController

  before_filter :authenticate_account!

  def index
    # some stuff
  end
end
```

We can now use the [app](http://api.rubyonrails.org/classes/Rails/ConsoleMethods.html#method-i-app) instance available in console to make a `GET` request to `/` path in the app.

```ruby
>> app.get('/')

Started GET "/" for 127.0.0.1 at 2017-06-11 08:45:15 +0200
Processing by HomeController#index as HTML
Completed 401 Unauthorized in 10ms (ActiveRecord: 0.0ms)
=> 302
```

Oh, of course. We cannot get to the view rendering yet because of the before filter and we'll need to authenticate first. We can either login first with another request or we can just stub it for the duration of this console session that will also avoid logging our credentials in production console history.

```ruby
class HomeController
  skip_before_filter :authenticate_account!

  def current_account
    Account.find(1)
  end
end
```

Then, by making the `GET` request to `/` path we'll get the details from the views rendering:

```bash
>> app.get('/')

Started GET "/" for 127.0.0.1 at 2017-06-11 00:59:44 +0200
Processing by HomeController#index as HTML
  Rendered home/_view1.html.erb (0.0ms)
  Rendered home/_view2.html.erb (10000.2ms)
  Rendered home/index.html.erb within layouts/application (10001.3ms)
  Rendered shared/_topnav.html.erb (0.2ms)
  Rendered shared/_flash_messages.html.erb (0.1ms)
  Rendered shared/_header.html.erb (0.1ms)
  Rendered shared/_footer.html.erb (0.0ms)
Completed 200 OK in 10010ms (Views: 10009.8ms | ActiveRecord: 0.0ms)
=> 200
```

From the rendering info, we can see that most of the time, that is around 10 seconds, is spent rendering `home/_view2.html.erb` partial. We have identified that something slow is happening there but we don't know what exactly it is.


### Get the stacktrace

While the request is processing the slow part we can just press `CTRL+C` to stop it and get a stacktrace:

```bash
>> app.get('/')

Started GET "/" for 127.0.0.1 at 2017-06-11 01:05:30 +0200
Processing by HomeController#index as HTML
  Rendered home/_view1.html.erb (0.0ms)
^C  Rendered home/_view2.html.erb (1309.6ms)
  Rendered home/index.html.erb within layouts/application (1310.6ms)
Completed 500 Internal Server Error in 1312ms (ActiveRecord: 0.0ms)

IRB::Abort (abort then interrupt!):
  app/views/home/_view2.html.erb:1:in `sleep'
  app/views/home/_view2.html.erb:1:in `_app_views_home__view__html_erb__3830501997270886489_69842991281620'
  app/views/home/index.html.erb:3:in `_app_views_home_index_html_erb___2357466009542976056_69842998601520'

  Rendered /home/dalibor/.rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/actionpack-4.2.8/lib/action_dispatch/middleware/templates/rescues/_source.erb (5.6ms)
  Rendered /home/dalibor/.rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/actionpack-4.2.8/lib/action_dispatch/middleware/templates/rescues/_trace.html.erb (2.2ms)
  Rendered /home/dalibor/.rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/actionpack-4.2.8/lib/action_dispatch/middleware/templates/rescues/_request_and_response.html.erb (0.7ms)
  Rendered /home/dalibor/.rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/actionpack-4.2.8/lib/action_dispatch/middleware/templates/rescues/diagnostics.html.erb within rescues/layout (18.0ms)
=> 500
```

From the stacktrace we can see that the slow call is the call to `sleep` method in `view2` partial. So, once we know the "what", we can go and start figuring out the "why".

Alternatively to this, we can use `TracePoint` as explained in [tracing ruby](/posts/51-tracing-ruby-code) blog post to get a stacktrace and then play roulette to sample individual calls to figure out what's slow.

```ruby
trace { app.get('/') }
```

[ConsoleMethods](http://api.rubyonrails.org/classes/Rails/ConsoleMethods.html) module has few handy methods that you can check out.

For example, we can get the response body.

```ruby
>> app.response.body.first(15)
=> "<!DOCTYPE html>"
```

We can call routes and helper methods, etc.

```ruby
>> helper.link_to(app.root_path, 'Home')
=> "<a href=\"Home\">/</a>"
```
