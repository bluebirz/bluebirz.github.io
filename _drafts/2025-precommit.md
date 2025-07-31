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

## Setup

### installation

 Install pre-commit into your Git hooks:
    pre-commit install

- Run pre-commit hooks on all staged files:
    pre-commit run

- Run pre-commit hooks on all files, staged or unstaged:
    pre-commit run --all-files

- Clean pre-commit cache:
    pre-commit clean

- Update pre-commit configuration file to the latest repos' versions:
    pre-commit autoupdate

### Config

### Github Actions

---

## Git hooks

---

```sh
pre-commit -V
```

```sh
pre-commit install
pre-commit installed at .git/hooks/pre-commit

```

```sh
touch .pre-commit-config.yaml
pre-commit sample-config > .pre-commit-config.yaml
```

```yaml
# See https://pre-commit.com for more information
# See https://pre-commit.com/hooks.html for more hooks
repos:
-   repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v3.2.0
    hooks:
    -   id: trailing-whitespace
    -   id: end-of-file-fixer
    -   id: check-yaml
    -   id: check-added-large-files
```
