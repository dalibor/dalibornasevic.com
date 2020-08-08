---
layout: post
title: "Using Amazon S3 in Rails Applications"
date: 2010-04-03 18:15:00 +0200
categories: [aws, rails, review]
summary: "Using Amazon S3 for uploads in Ruby on Rails applications."
permalink: /posts/12-using-amazon-s3-in-rails-applications
---

After reviewing [Vim for Rails Development](http://www.codeulatescreencasts.com/products/vim-for-rails-developers "Vim for Rails Development Screencast") screencast some time ago, I received another one, the second screencast of [Codeulate Screencasts](http://www.codeulatescreencasts.com/ "Codeulate Screencasts") which is titled: [Using Amazon S3 in Rails Applications](http://www.codeulatescreencasts.com/products/build-an-app-with-rails-and-s3 "Using Amazon S3 in Rails Applications"). This screencast presents how to build a file upload application with Rails and Amazon S3 including some tips and gems you may find useful while building that functionality.

Here I will review the screencast, which you may want to [buy](http://www.codeulatescreencasts.com/products/build-an-app-with-rails-and-s3 "Buy screencast") for $9.

Before watching the screencast I would say that I haven't got any experience using [Amazon S3](http://aws.amazon.com/s3/ "Amazon S3") previously. So, I guessed that if I need to build a Rails application using Amazon S3, I would have to spend some time researching the tools that I need, then read documentations on how stuff works, then maybe google for some approaches and finally implement the requested functionality. And, all the way along fight with all those little details that can really consume some time while figuring them out.

But, it's all here, well packed in 37 minutes long screencast. After wathing it, I learned all details to start coding an application right now and upload data on Amazon S3.

Another thing I like about the screencast is that, it feels that the knowledge in the screencast is extracted from building a real world application using Rails and Amazon S3. There are tips on having good design all the way along while building the application, including gotchas using Amazon S3 and other details.

Screencast begins with an overview of Amazon S3 (Simple Storage Service), where you can actually CRUD (Create Read Update and Delete) unlimited number of files from 1 byte to 5 gigabytes of data each. Amazon S3 has it's own terminology of buckets and objects for something like folders and files in the file system terminology. And, it gives you appropriate urls from where you can access the uploaded files.

Then screencast goes into details on how to use [AWS::S3](http://amazon.rubyforge.org/ "AWS::S3 gem") gem written by Marcel Molina which abstracts all API details using REST architecture of Amazon S3, and gives back ruby objects which are easy to work with in ruby code. It presents how to create new buckets and add new objects to those buckets using script/console.

Main part of the screencast is building the actual file upload application in TDD (Test Driven Development) style using fakeweb and mocha gems in the testing environment. After implementing the file upload to Rails application and then to Amazon S3, the author presents how to improve the usability of the application by using Tobias Lütke's gem [delayed\_job](http://github.com/tobi/delayed_job "delayed\_job gem"). This gem uploads the files in background process not leaving the user to wait while file uploads finishes (wait two times, once to the Rails application and another time to Amazon S3).

The screencast finishes with additional useful tips including:

- using BitTorrent sharing protocol to download files and save bandwidth if you happen to host some big files on Amazon S3 
- how to configure DNS by adding CNAME record in the DNS control panel so that downloads appear to be coming from your own domain
- using the [paperclip](http://github.com/thoughtbot/paperclip "paperclip gem") gem as an easy way to get your files on Amazon S3

Summary: must have screencast for building an Amazon S3 application in Rails, including lots of tips on the side you will surely find useful.
