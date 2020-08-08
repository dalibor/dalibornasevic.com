---
layout: post
title: "Vim for Rails Development"
date: 2010-02-28 20:48:00 +0100
categories: [vim, rails]
summary: "Setting up Vim editor for Ruby on Rails development."
permalink: /posts/11-vim-for-rails-development
---

**Update 2**: I've created my own [vimfiles](/posts/29-control-your-vim-editor), and you should too.
**Update 1**: There are new [updated vimfiles](http://www.akitaonrails.com/2010/04/25/updated-vimfiles "Akita on Rails Vim files") from Akita on Rails.

Few days ago I received a free copy of [Vim for Rails Development](http://www.codeulatescreencasts.com/products/vim-for-rails-developers%20screencast "Vim for Rails Development") from Ben Orenstein of [Codeulate Screencasts](http://www.codeulatescreencasts.com/ "Codeulate Screencasts") and we will be showing it at [MKRUG meetup](http://b10g.spodeli.org/2010/02/ruby-meetup-acer-23-rails-vim-rails.html "MKRUG meetup") this Thursday (04.03.2010). So, I thought it would be good to write a new blog post about where to start and how to learn Vim for Rails development by referencing some books/screencasts.

At the end I will also highlight some details of "Vim for Rails Development" screencast. But first, why use Vim!? In short: it's cross platform, open source and free text editor that lets you efficiently edit text. Other choices could be Textmate (only on Mac and paid), or Emacs (I won't go into details why I prefer Vim, but you can read more about this editor war at [wikipedia](http://en.wikipedia.org/wiki/Editor_war "Editor war")).

Learning process of any new tool starts with learning the basics, so I found [A Byte of Vim](http://www.swaroopch.com/notes/Vim "A Byte of Vim book") to be short, strict and well organized free book to learn the basics of vi/vim. One of the most important things that I learned from that book is how to properly position hands on the keyboard (ASDF/JKL:). It took me some time while I get comfortable, but it is very important step toward using the keyboard more effectively.

Then, for developing Ruby on Rails applications you have to setup your Vim installation with plugins that will make your life much easier. And, instead of doing that on your own, it's better choice to clone an already prepared installation which you can also customize if you want to. About a year ago Akita on Rails released a free Vim screencast [Rails on Vim](http://akitaonrails.com/2009/1/4/rails-on-vim-in-english "Akita on Rails on Vim") where he goes into details how to install Vim editor on Linux / Mac / Windows platforms with already installed plugins for Rails development. In that screencast he also talks about basics of using Vim and reviews some plugins like: NERDTree, FuzzyFinder and NERD snippets.

Here are instructions that I use for installing Vim with plugins for Rails development on Ubuntu:

```bash
sudo apt-get install vim-gnome
sudo apt-get install ctags
sudo apt-get install ncurses-term

git clone git://github.com/akitaonrails/vimfiles.git ~/.vim
cd ~/.vim
git submodule init
git submodule update
# add "source ~/.vim/vimrc" to ~/.vimrc file

# Command-T
cd ~/.vim/bundle/Command-T/ruby/command-t
ruby extconf.rb
make
```

Having your Vim environment for Rails development setup, it's time for some more advanced screencast.

"Vim for Rails Development" is a professional, well-recorded, 37 minutes long, $9 screencast which you can buy from [Codeulate Screencasts](http://www.codeulatescreencasts.com/products/vim-for-rails-developers "Buy Vim for Rails developers"). It's recorded from a person who uses Vim on daily basis for writing Rails code, so the content of the screencast is more advanced since he describes his daily workflow.

It starts by giving advice on how to type faster, produce code faster and that way you don't interrupt your thinking process. Then it goes into details about using the Rails.vim plugin from Tim Pope, for quick navigation in a Rails project, switching between files, working in parallel with vertical/horizontal splits, etc. He also reviews Snipmate plugin from Michael Sanders and demonstrates how to write your own snippets.

What I personally learned from this screencast was Exuberant Ctags for looking method definitions in Rails source code in much much quicker way than I was doing it previously using a file browser. Also, I learned about using Ack.vim plugin for better searching text through source code files than I was previously, using grep.

The screencast ends with few tips on fast text editing in situations that we frequently meet while editing code.

If you use Vim for Rails development and you just think about how much time you save by consuming all this digested material, instead of spending time digging into documentations, those kind of screencasts are worth buying.
