---
layout: post
title: "Deploying with Gitploy"
date: 2012-12-27 23:04:00 +0100
categories: [ruby, rails, deploy, tools]
summary: "Simple application deploys via Git using the Gitploy tool."
permalink: /posts/37-deploying-with-gitploy
---

Often times I'm impressed by simple tools that do a great job. [Gitploy](https://github.com/brentd/gitploy "Dead-simple (no, really) deployment DSL created with git in mind.") is one such tool, a very small deployment DSL created with git in mind that is dead-simple to use. It is only about 125 lines of [ruby code](https://github.com/brentd/gitploy/blob/master/lib/gitploy.rb "Gitploy script code") that you can read and understand in few minutes.

If you need a more complex deployment tool that supports different SCMs and has various predefined tasks for managing deploys go check out [Capistrano](https://github.com/capistrano/capistrano "Remote multi-server automation tool"). Or if you need something in between you can check out [git-deploy](https://github.com/mislav/git-deploy "git deployment made easy") which uses git hooks.

### How do you deploy with Gitploy?

This is my Gitploy script for deploying [popravi.mk](http://popravi.mk/ "PopraviMK") to staging and production stages:

```ruby
require 'gitploy/script'

configure do |c|
  stage :staging do
    c.path = '/home/deployer/www/staging.popravi.mk'
    c.host = 'staging.popravi.mk'
    c.user = 'deployer'
    c.local_branch = 'staging' # default is current branch
    c.remote_branch = 'master' # default is master
  end

  stage :production do
    c.path = '/home/deployer/www/popravi.mk'
    c.host = 'popravi.mk'
    c.user = 'deployer'
  end
end

setup do
  remote do
    run "mkdir -p #{config.path}"
    run "cd #{config.path} && git init"
    run "git config --bool receive.denyNonFastForwards false"
    run "git config receive.denyCurrentBranch ignore"
  end
end

deploy do
  push!
  remote do
    run "cd #{config.path}"
    run "git reset --hard"
    run "ruby -v"
    run "bundle install"
    run "bundle exec rake db:migrate RAILS_ENV=production"
    run "bundle exec rake assets:precompile"
    run "touch tmp/restart.txt"
  end
end
```

In the script, we define a **path** , **user** and **host** for the different stages that we want to deploy to: **staging** and **production**. We can specify **local\_branch** and **remote\_branch** for each stage. And we define **setup** step that will create target folder and initialize git repo and **deploy** step that will do the deploy. Both define which actions will be run on production and staging servers using SSH connection.

To install the gem run:

```bash
gem install gitploy
```

To setup the target folder and init repo for production stage run:

```bash
gitploy production setup
```

To deploy the app to production run:

```bash
gitploy production
```

For staging stage you'll need to do the same. And, there is also a manual step in between to configure the database.yml and other config files that is only done once.

How do you automate your deploys and what tools do you use?
