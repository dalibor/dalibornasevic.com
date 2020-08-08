---
layout: post
title: "Rails 3: Missing stylesheet and javascript files"
date: 2011-01-22 23:23:00 +0100
categories: [rails, upgrade]
summary: "Serving static assets, stylesheet and javascript files in development in Rails 3 applications."
permalink: /posts/20-rails-3-missing-stylesheet-and-javascript-files
---

Rails 3 production environment by default is configured to use application servers (apache, nginx, ...) to serve static assets. If you want to run production environment locally with the assets, you need to precompile the assets with `rake assets:precompile` and start the server in production environment locally with `rails server -e production` using standard development server like mongrel/webrick or similar. And you will need to change the following line in `config/environments/production.rb` so that static assets are served by the ruby server:

```ruby
config.serve_static_assets = false
```

to:

```ruby
config.serve_static_assets = true
```
