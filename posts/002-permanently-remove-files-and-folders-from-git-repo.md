---
id: 2
title: "Permanently remove files and folders from Git repo"
date: 2009-07-07 07:10:00 +0200
author: Dalibor Nasevic
tags: [git]
summary: "Overriding Git history and permanently removing files and folders from Git repository."
---

> Note: In this blog post the operations that are presented will override git history. Be careful what you're doing and backup your repo if you're not sure what you're doing.

Few weeks ago I froze gems on [my blog](https://github.com/dalibor/dalibornasevic.com "My blog") and ended up with a very big repository. So, I wanted to clean up the mess and remove permanently gems folder from the repository. `git rm` wasn't doing the job well, it only removes the folder from the working tree and the repository still contains the objects of this folder. After a quick search, I found that [git-filter-branch](http://www.kernel.org/pub/software/scm/git/docs/git-filter-branch.html "Git Filter Branch documentation") was the command I was looking for.

So, you can permanently remove a folder from a git repository with:

```bash
git filter-branch --tree-filter 'rm -rf vendor/gems' HEAD
```

Which will go through the whole commits history in the repository, one by one change the commit objects and rewrite the entire tree.

We use -r (recursive) parameter for recursive remove, and -f (force) to ignore nonexistent files (since folder/files may not be introduced to the repository within the commits range on which we do branch filter).

You can also specify range between commits, where you like to filter:

```bash
git filter-branch --tree-filter 'rm -rf vendor/gems' 7b3072c..HEAD
```

First commit is not being filtered.

If you subsequently try to do branch filters, you should provide -f option to filter-branch to overwrite the backup in refs/original/ where git stores the original refs from the previous branch filter.

```bash
git filter-branch -f --tree-filter 'rm -rf vendor/gems' HEAD
```

You can also remove original refs by hand, or do some backup to other location.

```bash
rm -rf .git/refs/original/
```

Permanently removing files from repository is same as folders:

```bash
git filter-branch --tree-filter 'rm filename' HEAD
```

There are few branch filter types (you can check the [documentation](http://www.kernel.org/pub/software/scm/git/docs/git-filter-branch.html "Git filter branch documentation")), but the one we use here --tree-filter is for rewriting the tree and its contents. You can also use --index-filter which is similar to --tree-filter but does not check the tree, and it goes much faster.

```bash
git filter-branch --index-filter 'git rm --cached --ignore-unmatch filename' HEAD
```

`--ignore-unmatch` parameter is used to ignore nonexistent files.

To remove the file from all branches that might have it in their history tree:

```bash
git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch filename' --prune-empty --tag-name-filter cat -- --all
```

`--prune-empty` parameter is used to remove empty commits.


At the end, don't forget to push the changes to the repository with --force, since this is not a fast forward commit, and the whole history within the commits range we filtered will be rewritten.

```bash
git push origin master --force
```

**Update**: While `filter-branch` rewrites the history for you, the objects remain in your local repository until they get dereferenced and garbage collected. 

To check what's pointing to nuked objects with use the following command. If you have tags and branches in the repo pointing to those objects, you'll most likely see them.

```bash
git for-each-ref --format='delete %(refname)' refs/original
```

To dereference, expire reflog (which by default is 90 days) and force garbage collect, you can do:

```bash
git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
git reflog expire --expire=now --all
git gc --prune=now
```

You'll need to make sure all branches and tags are pushed to remote (unless you're pushing to a new repo).

```bash
git push origin --force --all
git push origin --force --tags
```
