---
title: "Pre-commit before you commit"
layout: post
author: bluebirz
description:
# date: 
categories: []
tags: []
mermaid: false
comment: true
image:
  path: https://images.unsplash.com/photo-1580795478762-1f6b61f2fae7?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1580795478762-1f6b61f2fae7?q=10&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / CDC
  caption: <a href="https://unsplash.com/photos/woman-in-black-crew-neck-t-shirt-standing-beside-woman-in-white-t-shirt-CMhVRKI6vSY">Unsplash / CDC</a>
media_subpath: 
---

Git is a must for developers. It is easy to store our source code, track, and review, but have you been ensure that you pushed only source code and necessity without any confidential in your repo?

---

## Introduce "pre-commit"

`pre-commit` is a tool to automatically run **hooks** and the hooks will **trigger** particular scripts to **lint**, **check**, **validate** our source code in an **isolated environment**. Once setup it works so well with **Git** and let us know before committing unclean code. That's why it called `pre-commit`.

{% include bbz_custom/link_preview.html url='<https://pre-commit.com/>' %}

![image]({{ page.media-path  }}IMG_6642-are.jpg){:style="max-width:75%;margin:auto;"}

---

### h3

---

#### h4
