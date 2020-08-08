---
layout: post
title: "Create Your Own Dotfiles"
date: 2014-07-13 12:55:00 +0200
categories: [tools]
summary: "Share your dotfiles and make them reusable after reinstalling operating systems."
permalink: /posts/46-create-your-own-dotfiles
---

A while ago I gave you an advice to create and maintain your own [vimfiles](/posts/29-control-your-vim-editor). Now, I would advice you to create and maintain your own dotfiles as well. It's your own environment and tools you use to do your job well.

You can find [my dotfiles on Github](https://github.com/dalibor/dotfiles "My dotfiles") and get inspiration from there if you like. I've mainly been inspired and stole things from [Gary Bernhardt's dotfiles](https://github.com/garybernhardt/dotfiles), but also from other places over the years.

I will share some command line tools I find useful with focus on ones I use to investigate code issues and stats (some of them depend on Git).

### 1. Cloc

You want to check the project stats and what languages it's coded in. [cloc](https://github.com/dalibor/dotfiles/blob/master/bin/cloc) tool will give you stats about the project, run the following from the project root:

```bash
cloc .
```

If you're in a rails project, you can use:

```bash
rake stats
```

### 2. Churn

You want to find some trends in the project and discover some hidden issues. Files that frequently change could mean that you have a bad design there that always results in more and more changes. This correlates to the [Open/closed principle](http://en.wikipedia.org/wiki/Open/closed_principle).

```bash
git churn | tail -10 # top 10 files with most changes
git churn app # changes in app folder
git churn --since='1 month ago' # changes in the last month
git churn --author=dalibor.nasevic@gmail.com # changes by author
```

### 3. Run command on git revisions

You find your build is failing and you want to find the exact commit where it got broken. Or, you have some performance downgrade that you want to find where it was introduced. With [run-command-on-git-revisions](https://github.com/dalibor/dotfiles/blob/master/bin/run-command-on-git-revisions) you can run a command on a range of revisions:

```bash
run-command-on-git-revisions master a0988a0 'rspec spec'
```

### 4. God objects

You want to refactor and improve your code, but don't know where to start? Start by finding the [God objects](http://en.wikipedia.org/wiki/God_object) and then go with splitting that code into smaller fine grained objects.

```bash
wc -l app/models/*.rb | sort -nr # in app/models
find . -name '*.rb' | xargs wc -l | sort -nr | head -10 # all ruby files
```

### 5. Divergence

You are doing work on the master branch (which btw you shouldn't, always use a feature branch). With [git-divergence](https://github.com/dalibor/dotfiles/blob/master/bin/git-divergence) you can check how you have divereged from the remote branch and decide if you want to rebase or checkout a feature branch in order to avoid merge commits and/or conflicts. You'll need `diffstat` tool installed for this to work.

```bash
# sudo apt-get install diffstat
git-divergence # diff between current local and remove
git-divergence master feature # diff between any branches
```

### 6. Goodness

You want to see a summary of how many lines you have changed (added or removed) on your **feature** branch compared to master. [git-goodness](https://github.com/dalibor/dotfiles/blob/master/bin/git-goodness) will give you a summary, which uses [gn](https://github.com/dalibor/dotfiles/blob/master/bin/gn) script.

```bash
git-goodness master..feature
```

Check out the other [bins](https://github.com/dalibor/dotfiles/blob/master/bin), [aliases](https://github.com/dalibor/dotfiles/blob/master/bash/aliases) and [functions](https://github.com/dalibor/dotfiles/blob/master/bash/functions) in my [dotfiles](https://github.com/dalibor/dotfiles "My dotfiles").

Any command line tools for code stats you want to share?
