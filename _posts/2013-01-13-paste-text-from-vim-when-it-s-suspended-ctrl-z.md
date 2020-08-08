---
layout: post
title: "Paste text from Vim when it's suspended (ctrl+z)"
date: 2013-01-13 14:06:00 +0100
categories: [vim, ubuntu]
summary: "Pasting text from Vim after suspending it (hiding it in terminal by pressing ctrl+z)."
permalink: /posts/38-paste-text-from-vim-when-it-s-suspended-ctrl-z
---

I'm using Ubuntu and terminal vim and I have this workflow that I would yank something in Vim, suspend it (ctrl+z) and then paste the yanked text on command line usually to do a search with [ack](http://betterthangrep.com/ "ack is a tool like grep, optimized for programmers"). For some reason when I suspend Vim, X Window clipboard gets empty and it will paste nothing. Here is a small vim function that will fix that by using [xsel](http://www.vergenet.net/~conrad/software/xsel/ "Command-line program for getting and setting the contents of the X selection").

```vim
" work-around to copy selected text to system clipboard
" and prevent it from clearing clipboard when using ctrl+z (depends on xsel)
function! CopyText()
  normal gv"+y
  :call system('xsel -ib', getreg('+'))
endfunction
vmap <leader>y :call CopyText()
```

I have mapped **<leader>y**  to call the CopyText function. If you read the function, **gv**  is used to highlight whatever you had previously selected and it will then be yanked into **+** register with **"+y**. This function depends on xsel that you can install with:

```bash
sudo apt-get install xsel
```

Also, don't forget to set clipboard in Vim to **unnamedplus** (works only in version 7.3.74 and higher). With this setting Vim will use X11 clipboard for yank and paste (easy to copy/paste from/to Vim).

```vim
" use X11 clipboard for yank and paste
set clipboard=unnamedplus
```

Other solution to this problem would be to just use a clipboard manager (if you want to depend on a GUI tool). I've tried [clipit](http://clipit.rspwn.com/ "Clipit clipboard manager") and it works. You can install it with:

```bash
sudo apt-get install clipit
```

If you are interested into more Vim stuff, checkout [my vimfiles](https://github.com/dalibor/vimfiles "My vimfiles") on Github.
