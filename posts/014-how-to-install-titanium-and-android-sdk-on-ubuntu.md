---
id: 14
title: "How to install Titanium and Android SDK on Ubuntu"
date: 2010-10-13 03:32:00 +0200
author: Dalibor Nasevic
tags: [android, titanium, ubuntu, mobile]
summary: "Installing Titanium Mobile and Android SDK on Ubuntu."
---

Installing Titanium Developer on GNU/Linux based systems has few gotchas and the whole process is not very well documented on the internet with a simple step by step installation instructions that will just work. Here I will describe how I installed Titanium Developer 1.4 on Ubuntu 10.04 and point out some errors that I was getting during the installation.

First thing to note is that for developing mobile applications for Android platform with Titanium Developer you will need to install: Sun Java6 JDK and Android SDK 1.6. Here is how to do that:

### 1. Install Sun Java6 JDK on Ubuntu:

```bash
# Add new repository
sudo add-apt-repository "deb http://archive.canonical.com/ lucid partner"

# Update list
sudo apt-get update

# Install sun-java6-jdk
sudo apt-get install sun-java6-jdk
```

### 2. Install Android SDK:

Go to the [Download Android](http://developer.android.com/sdk/index.html) page and download the package for Linux. Then extract it to your local directory of choice (I use the `~/applications` directory in these instructions) and run the `android` executable from terminal or Nautilus that will start the Android SDK and AVD Manager.

```bash
# create directory and extract Android SDK installer
mkdir ~/applications
cd ~/applications
tar xzvf android-sdk_r07-linux_x86.tgz

# Run the android executable from terminal
~/applications/android-sdk-linux_x86/tools/android
```

In Android SDK and AVD Manager, install the following Available Packages:

  - SDK Platform Android 1.6, API 4, revision 3
  - Google APIs by Google Inc., Android API 4, revision 2

Google APIs is optional and you will need it only if you use Google maps in your applications. After the download finishes, you can create and start virtual devices from the same GUI interface and test if that works OK.

### 3. Install Titanium Developer

Download Titanium Developer for Linux (32 Bit) from [Titanium download page](http://www.appcelerator.com/products/download/ "Titanium download page"), unzip the archive to `~/applications` directory and run the `Titanium Developer` executable from terminal or Nautilus:

```bash
# Run the Titanium Developer executable from terminal
~/applications/Titanium\ Developer-1.2.1/Titanium\ Developer
```

Once Titanium Developer is installed, if you run it again from the terminal with the same command you will get this error:

```bash
./Titanium Developer: symbol lookup error: /usr/lib/libgtk-x11-2.0.so.0: undefined symbol: g_malloc_n
```

To fix this you will have to delete the following files (note that I had to delete only the first 2, i.e. run only the first 2 lines):

```bash
rm ~/.titanium/runtime/linux/1.0.0/libgobject-2.0.*
rm ~/.titanium/runtime/linux/1.0.0/libglib-2.0.*
rm ~/.titanium/runtime/linux/1.0.0/libgio-2.0.*
rm ~/.titanium/runtime/linux/1.0.0/libgthread-2.0.*
```

Finally, you can now start the Titanium Developer and login with your Titanium credentials. If you don't have one, you can signup for an account on their site.

### 4. Update Titanium version (1.2.1 -> 1.4.0)

In the top-right corner you will notice available update for 1.4.0 version which you need to install by following the instructions.

### 5. Setup Android SDK location

When you try to create new mobile project in the Titanium Developer you will be asked for the Android SDK location and you can point to the directory where you have installed it (mine is: `~/applications/android-sdk-linux\_x86`).

### 6. Export Android tools path

Titanium needs Android tools on the path, so you will have to export it in your `~/.bashrc` file. This is very important because if you don't export Android tools path, Titanium Developer will show blank screen on `Run Emulator` tab.

```bash
# Export Android tools path
PATH=$PATH:~/applications/android-sdk-linux_x86/tools
export PATH
```

You can now create new mobile project in Titanium Developer and run it on a virtual device.
