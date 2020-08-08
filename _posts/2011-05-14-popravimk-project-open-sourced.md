---
layout: post
title: "PopraviMK project open-sourced"
date: 2011-05-14 22:52:00 +0200
categories: [popravimk, opensource, rails, titanium]
summary: "Open-sourcing PopraviMK Titanium mobile and web applications."
permalink: /posts/26-popravimk-project-open-sourced
---

I have open-sourced [PopraviMK](http://popravi.mk/ "PopraviMK official site") project (both web and mobile applications) on my [Github](https://github.com/dalibor "Dalibor Nasevic's Github profile") profile. The Android mobile application won the Grant Prix on the [Android Challenge](/posts/15-grand-prix-on-vip-android-challenge-with-popravimk "PopraviMK Android Grand Prix") in Macedonia (2010).

PopraviMK applications allow people to submit urban issues they have found on public area. The reported issues are then sent to the institutions (usually municipalities) and they can respond to the requests and solve the issues.

Here are some more technical details about the applications:

[popravi.mk](https://github.com/dalibor/popravi.mk "popravi.mk source code at Github") is a web application built with Ruby on Rails 3 web framework. It has good test coverage using tools like: cucumber, rspec, shoulda, factory\_girl, pickle, email\_spec. If you are looking for some good examples on using these tools, I would suggest reading the source code of this application. Google maps integration is also there, and JSON API service used by the mobile application.

[PopraviMK](https://github.com/dalibor/PopraviMK "PopraviMK source code at Github") is an Android mobile application built with Titanium mobile platform. It has both online and offline mode for submitting issues, local database for syncronization, Google maps integration, Twitter news, Login/Logout, Comments and other integrations with the API service.

Web application has both Macedonian and English localizations, and the Android application has only Macedonian localization. But, you can ignore the strings while reading the source code. ;)
