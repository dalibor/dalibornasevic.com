---
id: 29
title: "Control Your Vim Editor"
date: 2011-10-30 22:45:00 +0100
author: Dalibor Nasevic
tags: [vim, vimfiles]
---

I have created my own [vimfiles](https://github.com/dalibor/vimfiles "Dalibor Nasevic's vimfiles") and you should too. By doing so:

- you will control your editor 
- you will learn to better config it
- you will select mappings that works best for you
- you will select only the plugins you use

I started using Vim about 2-3 years ago, using this [vimfiles](https://github.com/akitaonrails/vimfiles "Akita on Rails vimfiles") package. For most of the time I didn't changed anything, but over the time I come into following issues with it:

1. it has lots of plugins that I never used (and my vim editor was slow)
2. it has mappings that I wanted to change (which is easy, except when some plugin steals key)
3. I wanted to further customize it / have my own config

Here is how I have organized my vimfiles (which is same as the ones I used):

First, create `~/.vim` folder where your vimfiles will be stored (eventually it will be the future git repo if you want to share it). In `~/.vim/vimrc` file you will enter all your vim configuration, and source it from `~/.vimrc` file.

```bash
mkdir ~/.vim
cd ~/.vim
touch vimrc
echo "source ~/.vim/vimrc" > ~/.vimrc
```

For installing vim plugins, it's easiest to install the [pathogen](https://github.com/tpope/vim-pathogen "Pathogen vim plugin") plugin (instructions on github) which will simplify the process of installing (and updating) other vim plugins.In my case all plugins are on Github and I have installed them as submodules, which allows me to easily update them at any point. Here is how to add plugins as submodules:

```bash
git submodule add git://github.com/tpope/vim-rails.git bundle/vim-rails
git submodule add git://github.com/tpope/vim-vividchalk.git bundle/vim-vividchalk
git submodule add git://github.com/wincent/Command-T.git bundle/Command-T
git submodule add git://github.com/vim-ruby/vim-ruby.git bundle/vim-ruby
...
```

I stole lots of configuration stuff from [here](https://github.com/akitaonrails/vimfiles "Akita On Rails's vimfiles"), [here](https://github.com/garybernhardt/dotfiles "Gary Bernhardt's dotfiles") and [here](https://github.com/krisleech/vimfiles "Krisleech's vimfiles") and placed it into the ~/.vim/vimrc file.

At the end, I wanted to share some interesting mappings that I find extremely useful. I was very happy to dig them out very recently in the above configurations files:

```vim
" Switch between buffers
noremap <tab> :bn<CR>
noremap <S-tab> :bp<CR>

" Close buffer
nmap <leader>d :bprevious<CR>:bdelete #<CR>

" Close all buffers
nmap <leader>D :bufdo bd<CR>

" Switch between last two buffers
nnoremap <leader><leader> <C-^>

" Map ESC
imap jj <ESC>

" Clear the search buffer when hitting return
:nnoremap <CR> :nohlsearch<CR>
```

What's the very last Vim tip that you have learned?
