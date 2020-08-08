---
layout: post
title: "Playing Planning Poker with Firepoker"
date: 2016-11-20 08:30:00 +0100
categories: [agile, planning-poker]
summary: "How to customize and host Firepoker tool for estimating work on projects."
permalink: /posts/75-playing-planning-poker-with-firepoker
---

[Planning Poker](https://en.wikipedia.org/wiki/Planning_poker) is an excelent technique for estimating work on projects.  It is very valuable for Agile teams because it engages create consensus-based estimates and helps avoid [anchoring](https://en.wikipedia.org/wiki/Anchoring) by revealing the cards only once everyone played. It is also useful when doing other kinds of estimates like Agile Dojo self-assessments or any other rankings that involve more than one team member.

### Discovering Firepoker

There are few free and paid online tools for playing Planning Poker with distributed teams, the most popular being [planningpoker.com](https://www.planningpoker.com/). I needed a tool that is free to use and has option for custom cards set to use for our Agile Dojo self-assessments and that's how I came to [Firepoker](http://firepoker.io/). In this blog post I will show how easy it is to add a custom cards set to Firepoker and how to host it.

<p style="text-align: center">
  <img style="width: 100%" src="/images/planning_poker.png" alt="Playing planning poker with Firepoker" title="Playing planning poker with Firepoker">
</p>

As we can see from the screenshot above, Firepoker has a very clean and simple UI. It does not require participants to login. Stories for estimation can be created on the fly. Some very good UX decisions have been made there. It is also build with Firebase and AngularJS which makes it easy to deploy anywhere because it's front-end only.

### Creating Firebase account

To deploy Firepoker, we'll need to create a free [Firebase](https://firebase.google.com/) account and switch to use our URL in [main.js](https://github.com/Wizehive/Firepoker/blob/64676b957cb1682961266062659a8583c6956c62/app/scripts/controllers/main.js#L16). Firebase database rules can be configured using this [example](https://github.com/Wizehive/Firepoker/blob/64676b957cb1682961266062659a8583c6956c62/app/config/firebase.security_rules.json) to allow for read and write permissions.

### Deploying to Heroku

It's been a while since I last deployed something to Heroku, but not much has changed in meanwhile which is a good thing. Create a free account, push a branch and the app is live.

In order to make Firepoker deployable to Heroku, we will use Sinatra to help us serve the static files.

Create a `Gemfile` with the following content:

```ruby
source 'https://rubygems.org'

ruby "2.2.2"

gem 'sinatra'
```

Create `config.ru` file:


```ruby
require 'sinatra'

public_dir = 'app'

set :public_folder, Proc.new { File.join(root, 'app') }

get "/" do
  File.read(File.join(public_dir, 'index.html'))
end

run Sinatra::Application
```

Because Firepoker has all assets in `app` directory, we need to tell Sinatra to use that as public dir.

To test run it locally, first `bundle install` and then use `rackup` tool to start the app:


```ruby
bundle exec rackup
```

Because Heroku shows a warning when `Procfile` is missing, it's nice to add one:

```ruby
web: bundle exec rackup config.ru -p $PORT
```

Once that's all ready, we need to create a Heroku app

```ruby
heroku create
```

And, push to heroku remote that was automatically added by the previous command:

```ruby
git push heroku
```

Important note about this deploy process is that the official Firepoker repo has `app/components` dir gitignored, and it needs to be added to git so that it is pushed to Heroku for the app to function.

### Creating a custom cards set

Adding a custom cards set to Firepoker is as easy as this:

In [app/scripts/controllers/main.js](https://github.com/Wizehive/Firepoker/blob/64676b957cb1682961266062659a8583c6956c62/app/scripts/controllers/main.js#L269):

```diff
-[0, 0.5, 1, 2, 3, 5, 8, 13, 20, 40, 100, '?']
+[0, 0.5, 1, 2, 3, 5, 8, 13, 20, 40, 100, '?'],
+[1, 2, 3, 4, '?']
```

And, in [app/views/games/new.html](https://github.com/Wizehive/Firepoker/blob/64676b957cb1682961266062659a8583c6956c62/app/views/games/new.html#L29):

```diff
 <select class="form-control" id="deck" ng-model="newGame.deck" required>
   <option value="0">0, 1, 2, 4, 8, 16, 32, 64, 128, and ?</option>
   <option value="1">0, ½, 1, 2, 3, 5, 8, 13, 20, 40, 100, and ?</option>
+  <option value="2">1, 2, 3, 4, and ?</option>
 </select>
```

It will show as an option in the menu when creating a new game and will work as with other card sets.

What's your planning poker tool of choice?
