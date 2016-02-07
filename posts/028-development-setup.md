---
id: 28
title: "Development Setup"
date: 2011-10-23 15:00:00 +0200
author: Dalibor Nasevic
tags: [ubuntu, development, setup, software, hardware]
---

A week ago I upgraded to Ubuntu 11.10 (Oneiric Ocelot) and have spend some time experimenting with different windows managers / shells to find out what works best for me. As a Web Developer I have been doing software / hardware decisions all the time, and here is my current set of tools.

I have been using Ubuntu since version 8.04 and it serves me well to get the job done. Besides that, it also gives me more freedom when selecting/using software packages compared to other proprietary software.

Ubuntu 11.10 comes with Unity shell by default. I tried Unity, GNOME 3, Awesome Windows Manager and GNOME 3 Classic. Unity was very slow, GNOME 3 was well optimized, and both focus their UI on touch screen optimizations that I don't need. On the other side, Awesome WM was really fast, but it does not have intuitive keyboard bindings and offers complex windows layouts which need additional configuration to adapt to my needs. And then I come back to using GNOME 3 Classic. It's simple, clean and fast - that's what I need from my tools.

My hardware setup is a Dell Studio 15 (1555) laptop with following performances:

- Intel Core 2 Duo processor P8600 (2.4GHz, 3MB L2 Cache, 1066MHz FSB)
- 15.6" High Definition (1920x1080) High Brightness LED Display with TrueLife and Camera
- 3GB DDR2 SDRAM 800MHz System Memory
- ATI Mobility Radeon HD 4570 graphics (256MB)
- 250GB 7200RPM SATA Hard Drive

I want to use vanilla laptop without any additional hardware like: additional monitor(s), keyboard and mouse. I try to use only the keyboard, and when I need a mouse there is the touch pad next to the keyboard which helps getting things done faster.

Here is the software I use most of the time grouped in different sections:

### Audio, Video & Graphics

- Clementine (Music Player) - This one works best for me (simple, does not forces you to use collection, can browse files)
- Totem Movie Player - Watch screencasts (if encounter encoding problems I try VLC)
- gThumb Image Viewer - Perfect tool for croping, resizing and other simple image modifications
- Agave - Colorscheme designer for GNOME Desktop

### Accessories

- GNOME Do - Fast way to open any program (way faster than using GNOME 3 / Unity shell)
- Shutter - Capture, edit and share screenshots
- Project Hamster - Personal Time Tracking

### General Usage Software

- Skype, xChat, Empathy - Communication
- Thunderbird - Great email client, finally default in Ubuntu 11.10
- Chromium Browser - Open web applications (Campfire, Pivotal Tracker, Harvest Time Tracker) in other than default development browser
- Libre Office - Document production and data processing
- Dropbox - Sharing files between computers

### Development Setup

- Firefox Browser - With 2 extensions: Firebug and Web Developer, disabled menu
- Guake terminal - With tabs for: Rails server, Rails console, Git, Vim, RSpec, Cucumber, Spork RSpec, Spork Cucumber and/or Guard, SSH, etc
- Vim - Text editor (running in Guake terminal)
- Mysql Administrator / Query Browser - Browsing queries on MySQL database
- pgAdmin III - Browsing queries on PostgreSQL database

What's really good about Guake Terminal is that it's "independent" from other open windows and while I use Alt + Tab to switch between other windows, I have mapped Alt + d to open/close Guake. When Guake is opened I have mappings for switching between tabs with Alt + h to left and Alt + l to right. Because Guake is not like the other windows (Alt + Tab to find it), but it has it's own mappings, finding the right terminal works really fast. Here is a screenshot of Guake:

<p style="text-align: center">
  <a href="/images/guake.png" title="Guake Terminal Screenshot">
    <img src="/images/guake.png" alt="Guake Screenshot" title="Guake Screenshot" style="width: 100%;">
  </a>
</p>

Here is my Guake script for starting a project in Guake terminal:

```bash
#!/bin/sh

guake -e "cd ~/projects/github/blog/" -r server;
guake -e "rails server";
guake -n ~/projects/github/blog/ -r "console" -e "rails console";
guake -n ~/projects/github/blog/ -r "git" -e "git log";
guake -n ~/projects/github/blog/ -r "vim" -e vim;
guake -n ~/projects/github/blog/ -r "spork rspec" -e "spork rspec";
guake -n ~/projects/github/blog/ -r "rspec";
guake -n ~/projects/github/blog/ -r "spork cucumber" -e "spork cucumber";
guake -n ~/projects/github/blog/ -r "cucumber";
guake -s 3; # select vim tab
```

I will write additional blog post about my Vim setup. I used these [vimfiles](https://github.com/akitaonrails/vimfiles/ "Vim Files"), but found that there are lot of plugins that I don't need and which just slow up my Vim. I have cleaned it up, added some new key mappings and will publish them in a new blog post.

Untill then, would you share your development setup? Any other tools that help you getting the job done faster?
