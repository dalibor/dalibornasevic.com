---
id: 49
title: "ScreenCloud basic screenshot editing support"
date: 2014-09-02 19:29:00 +0200
author: Dalibor Nasevic
tags: [ubuntu, screenshot, screencloud]
---

Screenshot sharing tool [ScreenCloud](https://github.com/olav-st/screencloud) is coming with basic [editing capabilities](https://github.com/olav-st/screencloud/issues/5) that will be released in the upcoming version. Here's an [example screenshot](http://screencloud.net/v/luEB) of what it can do. If you can't wait for the official release, here is how to compile and install the latest version from source.

You can follow the [official instructions](https://github.com/olav-st/screencloud/wiki#compiling) for your prefered OS. I've used the Ubuntu instuctions.

Note: Because this is not an official release, you'll need to get your OAuth credentials from the [ScreenCloud site](https://screencloud.net/oauth/register) and use them in the `cmake` command below.

```bash
# Install required dependencies
sudo apt-get install git build-essential cmake libqxt-dev libquazip0-dev qtmobility-dev python2.7-dev

# Get ScreenCloud source code 
git clone https://github.com/olav-st/screencloud.git 
cd screencloud

# Configure and make
mkdir build 
cd build
cmake ../screencloud -DQT_QMAKE_EXECUTABLE=/usr/bin/qmake-qt4 -DCONSUMER_KEY_SCREENCLOUD=your_key -DCONSUMER_SECRET_SCREENCLOUD=your_secret
make
```

Then, add the `screencloud` binary to your startup applications, so that it starts when OS starts.

If you had an existing screencloud installation, make sure you disable it before enabling the new one.

If you get the following error:

```bash
[WARN] "The consumer_key token combination does not exist or is not enabled."
```

Make sure you logout and login in ScreenCloud so that new OAuth credentials [take effect](https://github.com/olav-st/screencloud/issues/5#issuecomment-53180284).
