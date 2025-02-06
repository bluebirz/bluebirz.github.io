---
title: Ripgrep searches everything in a blink
layout: post
author: bluebirz
description:
date: 00:00:00 +0200
categories: []
tags: []
image:
  path: https://images.unsplash.com/photo-1583521214690-73421a1829a9?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Wesley Tingey 
  caption: <a href="https://unsplash.com/photos/stack-of-books-on-table-snNHKZ-mGfE">Unsplash / Wesley Tingey</a>
---

Ripgrep is a command line tool with high capacity to work rapidly on file searching operations. There are claims that Ripgrep is faster than many grep tools.

Below is the github repo of the producer.

{% include bbz_custom/link_preview.html url='<https://github.com/BurntSushi/ripgrep>' %}

---

## How good it is?

As far as I used it, I am satisfied with it. It provides result with concise and readable colorful way.

like this.

![rg sample](../rg/01-sample.png){:style="max-width:75%;margin:auto;"}

By default, Ripgrep is searching for the regular expression we supplied. But we can add flags like exact matches, files only, and even hidden files (such as files listed in ".gitignore").

---

## How to use?

Assume that we have installed Ripgrep into our computer or projects, we can start searching something like this.

```sh
rg "<text>"     # current path
rg "<text>" .   # current path as . (dot)
```

This simple command uses Ripgrep to search that text as a regular expression in all files in the current directory and subdirectories.
