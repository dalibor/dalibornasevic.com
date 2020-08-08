---
layout: post
title: "RVM and Passenger for Rails 2 and Rails 3 apps"
date: 2011-01-23 23:03:00 +0100
categories: [rails, rails3, deploy, ubuntu, passenger, apache, rvm]
summary: "Making RVM and Passenger work together for Rails 2 and Rails 3 applications."
permalink: /posts/21-rvm-and-passenger-for-rails-2-and-rails-3-apps
---

If you want to have more control over your development environments when working with Rails applications, you can isolate different sets of gems by using the [RVM](http://rvm.beginrescueend.com/ "Ruby Version Manager") (Ruby Version Manager).

And, if you want to have more control over your production environments, you can make [Phusion Passenger](http://www.modrails.com/ "Phusion Passenger") and RVM work together. This is how I setup my production environment using Apache2 web server on Ubuntu:

1. Install production ruby version with RVM command line tool
2. Install the newest version of bundler (1.0.9) and passenger (3.0.2) gems in the global RVM gemset (version numbers were newest at the time of this writing)
3. Install Passenger module for Apache2 (passenger-install-apache2-module)
4. Add the following lines to your apache2 config `/etc/apache2/apache2.conf` in order to tell Apache2 to run the ruby and passenger from the RVM setup:

```apache
LoadModule passenger_module /home/dalybr/.rvm/gems/ruby-1.8.7-p299@global/gems/passenger-3.0.2/ext/apache2/mod_passenger.so
PassengerRoot /home/dalybr/.rvm/gems/ruby-1.8.7-p299@global/gems/passenger-3.0.2
PassengerRuby /home/dalybr/.rvm/wrappers/ruby-1.8.7-p299@global/ruby
```

5. Create different RVM gemset for each application that you want to deploy
6. Create `config/setup\_load\_paths.rb` file in your application which is used by Passenger to figure out the load paths.

For Rails 3 application (using Bundler) config is:

```ruby
if ENV['MY_RUBY_HOME'] && ENV['MY_RUBY_HOME'].include?('rvm')
  begin
    rvm_path = File.dirname(File.dirname(ENV['MY_RUBY_HOME']))
    rvm_lib_path = File.join(rvm_path, 'lib')
    $LOAD_PATH.unshift rvm_lib_path
    require 'rvm'
    RVM.use_from_path! File.dirname(File.dirname( __FILE__ ))
  rescue LoadError
    # RVM is unavailable at this point.
    raise "RVM ruby lib is currently unavailable."
  end
end
    
ENV['BUNDLE_GEMFILE'] = File.expand_path('../Gemfile', File.dirname( __FILE__ ))
require 'bundler/setup'
```

For Rails 2 (without Bundler) config is:

```ruby
if ENV['MY_RUBY_HOME'] && ENV['MY_RUBY_HOME'].include?('rvm')
  begin
    rvm_path = File.dirname(File.dirname(ENV['MY_RUBY_HOME']))
    rvm_lib_path = File.join(rvm_path, 'lib')
    $LOAD_PATH.unshift rvm_lib_path
    require 'rvm'
    RVM.use_from_path! File.dirname(File.dirname( __FILE__ ))
  rescue LoadError
    # RVM is unavailable at this point.
    raise "RVM ruby lib is currently unavailable."
  end
end
```

Now your Rails 2 and Rails 3 applications can work together, isolated in different production environments.

For more info on the topic you can read [Advice on using Ruby, RVM, Passenger, Rails, Bundler](http://jeremy.wordpress.com/2010/08/19/ruby-rvm-passenger-rails-bundler-in-development/ "Advice on using Ruby, RVM, Passenger, Rails, Bundler") and [The Path to Better RVM & Passenger Integration](http://blog.ninjahideout.com/posts/the-path-to-better-rvm-and-passenger-integration "The Path to Better RVM & Passenger Integration") blog posts.
