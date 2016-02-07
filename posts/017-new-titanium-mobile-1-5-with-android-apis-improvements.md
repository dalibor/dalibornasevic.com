---
id: 17
title: "New Titanium Mobile 1.5 with Android APIs improvements"
date: 2011-01-09 23:29:00 +0100
author: Dalibor Nasevic
tags: [titanium, android, ubuntu, mobile]
---

New version of Titanium Mobile 1.5 has been released recently including many improvements of the Android APIs in Titanium. [Android module](http://developer.appcelerator.com/apidoc/mobile/latest/Titanium.Android-module "Titanium Android module") now allows us to use native Activity, Intent, Service in Android mobile applications developed with Titanium.

For more information about the improvements you can check the [Developing Native Android Apps with Titanium](http://vimeo.com/18541179 "Developing Native Android Apps with Titanium") video presentation.

If you are having problems with installing Titanium Mobile on Ubuntu you can follow the instructions from my previous blog post [How to install Titanium and Android SDK on Ubuntu](http://dalibornasevic.com/posts/14-how-to-install-titanium-and-android-sdk-on-ubuntu "How to install Titanium and Android SDK on Ubuntu") by installing the latest versions of all packages. And, if you get the following error when trying to create new Android project in Titanium:

```bash
Couldn't find adb or android in your SDK's "tools" directory. You may need to install a newer version of the SDK tools.
```

You will need to link the adb binary because it has been moved from `tools` to `platform-tools` directory in the new Android SDK r08.

```bash
cd ~/applications/android-sdk-linux_86/tools
ln -s ../platform-tools/adb
```
