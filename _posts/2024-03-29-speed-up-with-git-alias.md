---
title: Speed up with Git alias
layout: post
author: bluebirz
description: I will share some useful git commands that you can press save and call when needed.
date: 2024-03-29
categories: [devops, integration]
tags: [git]
comment: true
image:
  path: https://images.unsplash.com/photo-1526920929362-5b26677c148c?q=80&w=2076&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Juan Gomez 
  caption: <a href="https://unsplash.com/photos/white-orange-green-and-purple-computer-keyboard-kt-wA0GDFq8">Unsplash / Juan Gomez</a>
---

Git is a must-have tool for all developers. There are tons of commands to perform actions, and that also comes with tons of options a.k.a. flags for each commands. It would be a great time of us ending up writing a crazy long command until we satisfy.

Now this blog I will share some useful git commands that you can press save and call when needed and I hope they're helpful for you.

---

## What's Git alias

You may have a time doing somethings with a repo but there were so many things to specify such as fetching a new change then cleanup unused branches before.

---

## How to update Git alias

[Official document](https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases) says the way to add or update Git alias is:

```sh
git config --global alias.<alias_name> '<full commands>'
```

The alias name can be any words you like.

For me, I prefer editing the git configuration file directly as it is placed at "~/.gitconfig". The aliases will be arranged under section `[alias]` and I usually define alias name by just 3 letters to make it quick to type.

```sh
[user]
        name = abc
        email = abc@users.noreply.github.com
[alias]
        alias_name = full_commands
```

---

## How to use Git alias

Basically we declare Git alias since the action verbs e.g. `checkout` or `commit` . When we want to use the alias, we would just start with `git` and follow by the alias.

For example, we define an alias as `ci = commit`, then we can replace `git commit -m "test"` with `git ci -m "test"`.

---

## Example Git alias

Now it's time to me showing my often-use aliases.

### pull and clean

This alias will fetch and pull all  then clear (prune) deleted branches.

```sh
al1 = "!f() { git fetch --all && git pull --all && git remote prune origin; }; f"

# usage
git al1
```

### add, commit, and push

Instead of typing 3 commands, why not combine them together in one line?

```sh
al2 = "!f() { git add -A && git commit -m \"$@\" && git push; }; f"

# usage
git al2 "commit message"
```

### create a new branch and checkout

When we create a new branch, we will have to set upstream always then. So this alias can facilitate your time.

```sh
al3 = "!f() { git checkout -b $@ && git push --set-upstream origin $@; }; f"

# usage
git al3
```

### show commit graph

Just `git log` can produce a git commit graph like this.

![git log](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/git-alias/git-log.png){:style="max-width:80%;margin:auto;"}

git has provided flags for this log to be much more prettier.

```sh
al4 = log --all --graph --abbrev-commit --decorate --date=format-local:'%Y-%m-%d %H:%M:%S' --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%ad%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'

# usage
git al4
```

![git al4](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/git-alias/git-lob.png){:style="max-width:80%;margin:auto;"}

It also shows the lines of branching and merging if there are.

---

### References

- [2.7 Git Basics - Git Aliases](https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases)
- [git add, commit and push commands in one?](https://stackoverflow.com/questions/19595067/git-add-commit-and-push-commands-in-one/35049625#35049625)
- [Pretty Git branch graphs](https://stackoverflow.com/questions/1057564/pretty-git-branch-graphs/9074343#9074343)
