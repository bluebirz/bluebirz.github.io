---
title: Homebrew - One place for all
layout: post
author: bluebirz
description: Most of necessary, popular, or essential packages (and programs) can be found here.
date: 2023-06-20 00:00:00 +0200
categories: [programming, tools]
tags: [homebrew]
comment: true
image: 
  path: https://images.unsplash.com/photo-1595177924939-4a0573ab3814?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / K8
  caption: <a href="https://unsplash.com/photos/white-ceramic-mug-with-brown-liquid-cN3pjD5laqU">Unsplash / K8</a>
---

As a developer, I have to install many programs for my own works. However, I don't have to spend time on searching how to install, update, and remove those because I have one place to handle them all. Homebrew is my cup of brewed coffee now.

---

## What is homebrew

Homebrew is a package manager for MacOS and Linux. Most of necessary, popular, or essential packages (and programs) can be found here. This is the homepage of Homebrew.

{% include bbz_custom/link_preview.html url='<https://brew.sh/>' %}

Homebrew is easy to use. Once we install Homebrew by running the command on the Homebrew homepage, it's ready now.

There are 2 types of package we can install with Homebrew:

1. **Formulae**. Formulae is a package that is built from source itself.
1. **Cask**. Cask is a native app.

---

## Popular packages

We can find out many packages in Homebrew. For example:

- [Python 3.11](https://formulae.brew.sh/formula/python@3.11)
- [htop](https://formulae.brew.sh/formula/htop)
- [terraform](https://formulae.brew.sh/formula/terraform)
- [node](https://formulae.brew.sh/formula/node)
- [google-cloud-sdk](https://formulae.brew.sh/cask/google-cloud-sdk)
- [awscli](https://formulae.brew.sh/formula/awscli)

and much more...

---

## Homebrew commands

- `brew install` to install a formulae or a cask.
- `brew uninstall` to uninstall.
- `brew list` to list all installed packages.
- `brew update` to update Homebrew.
- `brew upgrade` to update all installed packages.
- `brew outdated` to list all installed packages that are outdated.

---

## My installed packages

From my side, here are some of my packages.

- [awscli](https://formulae.brew.sh/formula/awscli): Official Amazon AWS command-line interface
- [gcc](https://formulae.brew.sh/formula/gcc): GNU compiler collection
- [gh](https://formulae.brew.sh/formula/gh): GitHub command-line tool
- [htop](https://formulae.brew.sh/formula/htop): Improved top (interactive process viewer)
- [jq](https://formulae.brew.sh/formula/jq): Lightweight and flexible command-line JSON processor
- [Python 3.11](https://formulae.brew.sh/formula/python@3.11): Python version 3.11
- [r](https://formulae.brew.sh/formula/r): R lang
- [terraform](https://formulae.brew.sh/formula/terraform): Tool to build, change, and version infrastructure. Read [my Terraform blogs here]({{ site.url }}/tags/terraform).
- [tree](https://formulae.brew.sh/formula/tree): Display directories as trees (with optional color/HTML output)
- [google-cloud-sdk](https://formulae.brew.sh/cask/google-cloud-sdk): Set of tools to manage resources and applications hosted on Google Cloud
- [numi](https://formulae.brew.sh/cask/numi): Calculator and converter application
- [orbstack](https://formulae.brew.sh/cask/orbstack): Replacement for Docker Desktop
- [rectangle](https://formulae.brew.sh/cask/rectangle): Move and resize windows using keyboard shortcuts or snap areas

![homebrew](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/homebrew/homebrew.png)

---

Hope this comforts you up in many levels for installing packages for your works.
