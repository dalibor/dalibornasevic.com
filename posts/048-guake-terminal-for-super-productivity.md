---
id: 48
title: "Guake terminal for super productivity"
date: 2014-09-01 21:28:00 +0200
author: Dalibor Nasevic
tags: [guake, productivity, ubuntu]
---

[Guake](https://github.com/Guake/guake) is one of my favorite software running on Linux. It's a simple, but perfect multi terminal application for GNOME Desktop. When SSHing to servers I often use [screen](http://www.gnu.org/software/screen/) or [tmux](http://tmux.sourceforge.net/), but on my host OS I prefer to use Guake.

I will share how I use Guake and some keyboard shortcuts configuration that fits well with my workflow. How you find this information useful.

Note: At the moment the last official version for Guake available via package manager is [0.4.4](http://packages.ubuntu.com/trusty/guake). I've compiled and installed version 0.5.0 which brings few improvements to make this tool perfect. I had [an issue](https://github.com/Guake/guake/issues/301) with keyboard shortcuts not working on Ubuntu 12.04 and 12.10, but I can confirm that everything is working well on Ubuntu 14.04.

### Installation

You can install latest Guake by following the [official instructions](https://github.com/Guake/guake#ubuntu):

```bash
sudo apt-get build-dep guake
sudo apt-get install build-essential python autoconf
sudo apt-get install gnome-common gtk-doc-tools libglib2.0-dev libgtk2.0-dev libgconf2-dev
sudo apt-get install python-gtk2 python-gtk2-dev python-vte glade python-glade2 python-appindicator
sudo apt-get install python-vte
# uncomment for Python 3
# sudo apt-get install python3-dev
# uncomment for glade Gtk-2 editor
# sudo apt-get install glade-gtk2

git clone https://github.com/Guake/guake.git
cd guake
./autogen.sh && ./configure && make
sudo make install
```

Then add the binary to your startup applications, so that it starts when OS starts.


### Special visibility toggle shortcut

The first thing that I like about Guake is the general keyboard shortcut for toggling its visibility. It's easy to open/close Guake from anywhere... in browser, Thunderbird, different workspace, anywhere. I've configured `Alt+D` and it will make Guake pop at the top of the screen. Compare this to searching for an app via Alt+Tab loop... keyboard shortcuts save lots of time.

`Alt+D` is my preconfigured keyboard shortcut for toggling Guake. I have all keyboard shortcuts prefixed with `Alt`, I always keep my left thumb on the left `Alt` key and that makes triggering all these shortcuts easy. To configure Guake keyboard shortcuts yourself, you'll need to go to `Preferences > Keyboard shortcuts`.

I rarely use full screen option with Guake, but I have that mapped to `Alt+F`.


### Tab management

- `Alt+T` for new table.
- `Alt+W` for closing a tab.
- `Alt+R` for renaming a tab.

All of these are easy to remember.


### Navigation shortcuts

I use [vim text editor](http://dalibornasevic.com/posts/43-12-vim-tips) and that's influencing my mappings for:

- go to previous tab: `Alt+H`, and 
- go to next tab: `Alt+L`

I also have mapped keys from `Alt+1` to `Alt+0` for switching between first and up to the tenth tab.


### Clipboard

- `Alt+C` for copying text to clipboard
- `Alt+V` for pasting text from clipboard

There are few other key mappings to configure but I don't find them very important.


### Other important configurations are:

In `Scrolling` tab, I have set Scrollback lines to 10000 with Show scrollbar and scroll On Key Stroke.

In `Appearance` I've set Transparency to 0, Text color white, Background color to blank.

On the `General` tab few settings are important to be checked:

- Open new tab in current directory
- Show tray icon
- Hide on lose focus

My Guake window size is maxed between top and bottom panel. I use Ubuntu classic Desktop.


### New features in version 0.5.0

Version 0.5.0 brings some improvements that I was missing in the previous versions:

- Move tab position with mouse; Usually I have multiple tabs open and it's important for me to know the tabs order in my fingers and mindset. So, when I close a tab by mistake (typing `exit`), I can easily open a new one and move it to the correct position without messing with my flow.
- Display placement; This was a problem when having multiple displays (usually laptop + second screen for a projector when doing presentations), but now that's been fixed. Hurray!
- Many more configuration shortcuts.

Guake team has done a great job here.


### Scripting Guake

Another great thing about Guake is that it is scriptable. I work on projects where I need 10 or more tabs to start everything up. That is just a click / command away with a simple Guake script. Here's an example that I'm using for a project:


```bash
#!/bin/sh

# open project notes
guake -e "cd ~/Dropbox/projects/project1" -r notes;
guake -e "vim"

# start project 1 (rails app, sidekiq, deferrer, vim, rails console)
guake -n ~/projects/project1 -r "project1" -e "foreman start";
guake -n ~/projects/project1 -r "vim" -e "vim";
guake -n ~/projects/project1 -r "terminal";

# start project 2 (client library)
guake -n ~/projects/project2 -r "client" -e "vim";
guake -n ~/projects/project2 -r "terminal";

# start project 3 (API testing tool)
guake -n ~/projects/project3 -r "api" -e "vim";
guake -n ~/projects/project3 -r "terminal";

# start project 4 (billing app)
guake -n ~/projects/project4 -r "billing" -e "passenger start -p 8080";

# start project 5 (main web app, resque, vim, rails console)
guake -n ~/projects/project5 -r "resque" -e "bundle exec rake resque:work QUEUE='*'";
guake -n ~/projects/project5 "main" -e "passenger start -p 3000";
guake -n ~/projects/project5 -r "vim" -e "vim";
guake -n ~/projects/project5 -r "terminal";

# start mailcatcher and open few pages in browser
guake -n ~/projects/project5 -r "terminal"
guake -e "mailcatcher"
guake -e "/usr/bin/google-chrome http://127.0.0.1:1080 http://localhost:3005/sidekiq http://localhost:3005 http://localhost:3000 &"
guake -e "exit"
```


Hope you like this post. Let me know what is your favourite terminal application and what features you like the most?
