---
title: Formatting your script with Black
layout: post
author: bluebirz
description: Black is a package for formatting job to Python with the tagline "The Uncompromising Code Formatter"
date: 2023-04-06 00:00:00 +0200
categories: [programming, tools]
tags: [Python, Black, VSCode]
comment: true
image:
  path: https://images.unsplash.com/photo-1612646561843-f7641ae5a4ef?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Clark Van Der Beken
  caption: <a href="https://unsplash.com/photos/black-and-white-checkered-textile-R6pSdFliZy4">Unsplash / Clark Van Der Beken</a>
---


This blog is still Python-wise. When it comes to 10 developers developing a project, there will be 10 coding styles certainly. Today I have an interesting helper to make all Python scripts give a same experience, same format of the code.

This would be credited to my team now. They standardize this for the work as well.

---

## Black

Black is a package for formatting job to Python. With the tagline, "The Uncompromising Code Formatter", we have no need to configure or customize any format as the package itself barely allow us to do so.

Take a second to preview how Black can tidy up the mess code. We can write any and let Black handle when we save it. Like this.

![black gif](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/python-black/a-save.gif)

Feel free to visit the main page on PyPI [here](https://pypi.org/project/black/).

---

## Setup on VSCode

Assumed that we all are developing on VSCode. It would be easy-peasy to setup like 1-2-3.

### 1. Install Black

Run the command

```sh
pip install black
```

And let the package be installed completely.

![install black](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/python-black/b-install.png)

I also recommend to install Python plugin as well.

{% include bbz_custom/link_preview.html url='<https://marketplace.visualstudio.com/items?itemName=ms-python.python>' %}

### 2. Define Python formatting provider

Open palette by <kbd>cmd</kbd> + <kbd>shift</kbd> + <kbd>P</kbd>.

![palette](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/python-black/c-palette.png)

Then search for "Python > Formatting: Provider" and select "black".

![choose black](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/python-black/d-provider.png)

### 3. Enable Format on Save

Now search for "Editor: Format on Save" then check the checkbox.

![format on save](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/python-black/e-format-save.png)

And that's it.

---

Hope we review codey happily with this tip.
