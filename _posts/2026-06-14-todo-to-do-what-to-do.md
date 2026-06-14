---
title: TODO to do what to do
layout: post
author: bluebirz
description: We can put what to do directly in codebase with TODO comments
date: 2026-06-14
categories: [programming, tools]
tags: [TODO comments, VSCode, Neovim]
comment: true
image:
  path: https://images.unsplash.com/photo-1644329843491-99edfc83de04?q=80&w=1171&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1644329843491-99edfc83de04?q=10&w=490&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Annie Spratt
  caption: <a href="https://unsplash.com/photos/a-piece-of-paper-with-the-words-to-do-list-on-it-Ki0-ea-Hgx4">Unsplash / Annie Spratt</a>
media_dir: https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/todo-comments/
---

There are tons of works and we have to update our codebase here and there. How to communicate with team members what and where shall we have to do?

No more list in paper nor tickets. We can put what to do directly in codebase with **TODO comments**.

---

## TODO comments

TODO comments are literally comments with a keyword to marking TODO items. Just creating a comment and starting with `TODO` keyword to make a TODO comment. They aren't limited to what TODO but also TOFIX and much more. However, the common keyword are `TODO`, `BUG`, and `FIXME`.

Most modern IDEs have integrated or have plugins in their extension market for TODO comments.

---

## Examples

I usually work on VSCode and Neovim so we can see how to write TODO comments in them. Other IDEs should have the same way.

### VSCode

For example, Visual Studio Code has "todo-tree" plugin.

{% include bbz_custom/link_preview.html url='<https://marketplace.visualstudio.com/items?itemName=Gruntfuggly.todo-tree>' %}

When the plugin installed completely, we can see the tree-like icon in the menu bar and click it to see the "tree" of all scannable TODO comments. Like this.

![todo comments plugin vscode]({{ page.media_dir }}vscode.png){:style="max-width:100%;margin:auto;"}

And when we click on any TODO, it will open the file and jump to that lin immediately.

### Neovim

There is a plugin for TODO comments in NEovim that I usually use it and it is shipped with [Lazyvim](https://www.lazyvim.org/).

{% include bbz_custom/link_preview.html url='<https://github.com/folke/todo-comments.nvim>' %}

We can type by default <kbd>space</kbd>+<kbd>s</kbd>+<kbd>t</kbd> to open Grep window showing TODO comments as the figure below.

![todo comments plugin nvim]({{ page.media_dir }}nvim.png){:style="max-width:90%;margin:auto;"}
