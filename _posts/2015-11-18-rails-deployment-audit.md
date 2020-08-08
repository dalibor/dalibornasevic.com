---
layout: post
title: "Rails deployment audit"
date: 2015-11-18 08:41:00 +0100
categories: [devops, deploy]
summary: "Things to consider when deploying Ruby on Rails applications."
permalink: /posts/62-rails-deployment-audit
---

**Note**: This is a republish of an article I wrote back in July 2012 on [Siyelo blog](http://blog.siyelo.com/rails-deployment-audit/).

We shared our Rails Deployment experience with Red Comet Labs, and in this article we'll discuss a checklist of some [devops](http://www.jedi.be/blog/2010/02/12/what-is-this-devops-thing-anyway/) practices and tools we are familiar with.

### Extract sensitive data

All sensitive data like passwords, API keys & tokens that are in the application are extracted as environment variables outside of the source code repository. We are using [rbevn](https://github.com/sstephenson/rbenv) for managing rubies, there is a nice plugin for setting up environment variables[rbenv-vars](https://github.com/sstephenson/rbenv-vars).

### Continuous Integration & Deployment

There are many great open source and commercial tools out there for [Continuous Integration](https://www.ruby-toolbox.com/categories/continuous_integration). We are using [Jenkins CI](http://jenkins-ci.org/) to run our test suite and handle Continuous Deployment (if the tests are green) for our staging branch. For production releases, we suggest doing releases manually at a scheduled time with the whole team ready and available.

### Deployment tools

If you need more advanced tool for doing the deploy, [Capistrano](https://github.com/capistrano/capistrano) is the definitely the tool to go with. However, if you want something more light-weight you can try [gitploy](https://github.com/brentd/gitploy) (bare minimum, git-based tool for deployment). Alternatively, check out another tool from this [list](https://www.ruby-toolbox.com/categories/deployment_automation).

### Deployment Documentation

Document server setup and everything about the deployment process. It may seem tedious now but in the long-run it will help because setups are easily forgetten and the person who initially setup the server is not always on hand to assist. By using an automation tool like [Chef](https://www.chef.io/) or [Puppet](http://puppetlabs.com/) you are kind of documenting things on the fly.

### Server security

Don't use your root user when you access your server - it's the simplest way to prevent accidentally breaking things. Create another user that can execute superuser commands using sudo. Use this non-root user all the time. You should use SSH key authentication to protect your server against brute-force password cracking attacks. Furthermore, you should disable SSH password authentication and the ability to login as root. Read more on this in Linode's guide on how to [secure your server](https://www.linode.com/docs/security/securing-your-server/).

### Start clean on boot

All the services that are being used by the application need to start cleanly when the server boots up - there should be no need for manual intervention. If you are deploying to Ubuntu, [update-rc.d](http://manpages.ubuntu.com/manpages/precise/man8/update-rc.d.8.html) can be used for init.d processes. And, for the application Procfile-based processes you can use the [foreman gem](https://github.com/ddollar/foreman) and there is an easy [export to upstart](https://ddollar.github.io/foreman/#UPSTART-EXPORT) for monitoring and boot start up setup.

### Log files

Prevent log files from growing to the point where you don't have any space left on disc device by using [logrotate](https://gorails.com/guides/rotating-rails-production-logs-with-logrotate). Analyze request log of your Rails application to produce a performance report with [request-log-analyzer](https://github.com/wvanbergen/request-log-analyzer).

### Cron jobs

Whether it's a backup script or background task that needs to be run as a job, it's a good idea to have documentation on it within the application. Cron's scheduling format is often difficult to read so we suggest using the [whenever gem](https://github.com/javan/whenever/) to make it more readable.

### Backups

For both database & uploaded content (like images and documents) we need to have regular backups distributed in different physical or cloud locations, [backup gem](https://github.com/backup/backup) is very handy tool for that.

### Failover

If server crashes, can you fail over to another server? How much time do you need for that operation and have you tested the procedure before it actually happens? Hosting services offer daily/weekly/monthly [node backups](http://www.linode.com/backups/) but the procedure need to be tested before there is a need for doing that.

### External monitoring tools

Service like [New Relic](http://newrelic.com/), [Pingdom](http://www.pingdom.com/) or [Alerta](http://www.alertra.com/) are interesting for monitoring server uptime and performance and they can send email, text and alerts when the server is not working.

### Notifications for Exceptions

Setup exception notifications to receive email notifications when application crashes. You can use [exception_notification gem](https://github.com/smartinez87/exception_notification) or some paid service like [Airbrake](http://airbrake.io/), [Exceptional](http://www.exceptional.io/).

### Process monitoring tools

Monitor your DB server, web server & background processes and restart them if they consume too much memory. Tools like [Upstart](http://upstart.ubuntu.com/), [Bluepill](https://github.com/arya/bluepill), [God](http://pathfindersoftware.com/2010/09/monitoring-rails-processes-apache-passenger-delayed_job-using-god-and-capistrano/) and [Monit](http://viktorpetersson.com/2010/07/09/setting-up-monit-to-monitor-apache-and-postgresql-on-ubuntu/) are useful.

### Server performance

Monitor server performance with [vmstat](https://www.linode.com/docs/uptime/monitoring/use-vmstat-to-monitor-system-performance/) or some 3rd party tool like [scoutapp](https://scoutapp.com/).

### Application performance

Monitor your application performance, uptime, slow DB queries, background tasks with [New Relic](http://newrelic.com/). They also have [Availability monitoring](http://newrelic.com/features/availability-monitoring) if you don't want to use other service for checking that your server is up and running.

The list is long, but it takes lots of patience in understanding the software business and delivering great software.
