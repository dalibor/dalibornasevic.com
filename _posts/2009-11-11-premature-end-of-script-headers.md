---
layout: post
title: "Premature end of script headers"
date: 2009-11-11 02:17:00 +0100
categories: [apache, passenger]
summary: Fixing premature end of script headers in Apache with Phussion Passenger
permalink: /posts/7-premature-end-of-script-headers
---

**Update**: As Hongli Lai notes in the comments, this is actually the case when app/apache is running as a root user, and user switching is turned on (the default).

If you are experiencing the following problems:

- your application works great in development environment, but once you deploy it to production server using Phusion Passenger on Apache you get the "Error 500 - Internal server error" error
- and, when you check the Apache error log /var/log/apache2/error.log you find the actual error which says: "Premature end of script headers"

Maybe this short post will solve your problem for you, because I found that Google results are little bit misleading on this one.

"Premature end of script headers" error basically means that the script stopped for any reason before returning any output to the web server. And, the problem in my case was that Apache user did not have read/write access to the directory where Rails application is located. So, when it tries to write to the log file (for example: paperclip gem logs image resizes or restrul\_authentication gem logs wrong logins), the application fails on those requests.

All you have to do is change the privilegies of Apache user (www-data on Debian/Ubuntu) and Apache group (www-data) to the folder where rails app is located:

```bash
chown -R www-data:www-data /var/rails
```
