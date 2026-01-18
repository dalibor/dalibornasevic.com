---
layout: post
title: "Refactoring Rails configs for deploy to Kubernetes"
date: 2018-02-27 08:30:00 +0100
categories: [kubernetes, devops, rails]
summary: "Config strategy for running Rails app in different environments and deploy targets."
permalink: /posts/81-refactoring-rails-configs-for-deploy-to-kubernetes
---

Recently, I worked on a project to containerize one of our Rails apps. The goal was to add per pull request verification deploys to Kubernetes as part of the CICD pipeline. During that work I faced a need to re-design how we manage the configs in the application and I will share some thoughts about the approach. But before we jump into that, let's explain the concept of per pull request verification deploys.

### Per Pull Request verification deploys

We use Jenkins for Continuous Integration and Continuous Delivery (CICD). Whenever we merge a pull request to the master branch (CI), the pipeline will deploy the changes to the target environments (CD). It starts by deploying to staging environments and finishes with a deploy to production environment.

We introduced another verification step to this pipeline. On each successful pull request build, it deploys the changes to a short-lived location. This temporary deploy is used for QA, manual testing and verification against more realistic data and environment before deploying to production. Once verified, the pull request can get merged in master that triggers the automated production deploy.

We deploy the app using Capistrano to OpenStack and bare metal servers. For the short-lived verification deploys we decided to explore and deploy to Kubernetes cluster. So, my main goal for the configs refactor was to have a solution that works well for both deploy scenarios.

### Config refactor design goals

1. Configs that work in different scenarios:
  - local app
  - local app using docker containers
  - local app using docker-compose
  - Capistrano deploy to OpenStack and bare metal servers
  - Kubernetes deploy to minikube and real clusters

2. Flexibility in how configs are defined

  Some configs like `database.yml` and `redis.yml` are in YAML format and other are using environment variables. I wanted to keep the flexibility of using YAML configs for the more complex configurations instead of forcing environment variables for everything.

3. Keep everything but the secrets config in source control

  Managing many config files, especially when deploying and running the app in different ways, increases maintenance complexity. The config files that are not stored in source control needs to become visible to the app during deploy. The goal here is to have at most a single file that's not in source control. For Capistrano deploys it's a single shared file with secrets to link during deploy. And, for Kubernetes deploys it's a single Secret resource that's updated on change.

  By keeping as much of the configs in source control, we'll do regular reviews on any config changes before merging to master. This is especially important for much more complex configs like the one we have for [Octoshark](http://localhost:3000/posts/69-managing-activerecord-connections-with-octoshark) where we connect to around 50 MySQL instances.

### Using environment variables with dotenv

One of the tenets of [Twelve-Factor app](https://12factor.net/) methodology is storing [configs in the environment](https://12factor.net/config). Docker, docker-compose and Kubernetes have a built-in ways for passing environment variables to the containers.

The [dotenv](https://github.com/bkeepers/dotenv) gem can help us replicate that by loading environment variables from config files. Once we include `dotenv` in the Gemfile, all we need to add is the following line to `config/application.rb`:

```ruby
Dotenv.overload(".env", ".env.#{Rails.env}", ".env.#{Rails.env}.secrets")
```

Here we use the overload feature of `Dotenv`. For production environment for example, it will first load the `.env` file, then `.env.production` and finally the `.env.production.secrets` file.

```ruby
.env                   # keeps the shared variables across all environments
.env.production        # keeps the environment specific variables
.env.production.secret # keeps the environment specific secrets
```
 The `.env.production.secrets` file is the one that's ignored in source control and it is used to keep the secrets as well as other configuration values that change between environments.

In the context of containers, we have the flexibility to override any of these environment variables which makes this config strategy work in both scenarios.

### Using YAML configs with environment variables

We can use YAML configs like `database.yml` with environment variables. We just change it to read the secrets and values that change between environments from environment variables. Where it makes sense we can also use a fallback, i.e. default values. Here's an example `database.yml` config:

```yaml
development:
  adapter: mysql2
  encoding: utf8
  reconnect: false
  pool: 5
  database: <%= ENV['MYAPP_DATABASE'] || 'myapp_development' %>
  username: <%= ENV['MYAPP_USERNAME'] %>
  password: <%= ENV['MYAPP_PASSWORD'] %>
  host:     <%= ENV['MYAPP_HOST'] || 'localhost' %>
  port:     <%= ENV['MYAPP_PORT'] || 3306 %>
```

Rails parses ERB tags by default when interpreting `database.yml` config. But for the custom configs we might have in the app, like the Redis one below for example, we need to replicate that behaviour.

Here is a very simple `ConfigParser` class that does that:

```ruby
require 'yaml'
require 'erb'

class ConfigParser
  def self.parse(file, environment)
    YAML.load(ERB.new(IO.read(file)).result)[environment]
  end
end
```

Then for a Redis config:

```yaml
:development:
  :host: <%= ENV['REDIS_HOST'] || 'localhost' %>
  :port: <%= ENV['REDIS_PORT'] || 6379 %>
  :password: <%= ENV['REDIS_PASSWORD'] %>
  :db: <%= ENV['REDIS_DB'] || 10 %>
  :reconnect_attempts: 3
  :timeout: 2
```

We can use the `ConfigParser` like:

```ruby
redis_config = ConfigParser.parse('config/redis.yml', Rails.env.to_sym)
redis_conn = Redis.new(redis_conf)
```

### Rails 5.2 Encrypted Credentials

With Rails 5.2 being just around the corner, and specifically the [Encrypted Credentials](https://www.engineyard.com/blog/rails-encrypted-credentials-on-rails-5.2) feature, we have the option to keep all the secrets encrypted in source control.

We can put all the secrets from the different environments `.env.development.secrets`, `.env.test.secrets` and `.env.production.secrets` in `config/credentials.yml.enc` and then the only value that the deploy target will need as a dependency is the `config/master.key` encryption key.

This approach of storing production secrets in codebase, although encrypted, might be sensible to some organizations.

### Final thoughts

I've considered using different Rails environments as an alternative approach. That increases complexity and does not meet some of the configs design goals. There are also Rails env checks in the codebase that behave as feature flags. So, the overloading approach with environment variables and the flexibility of using YAML for more complex configs works pretty well in all these scenarios.
