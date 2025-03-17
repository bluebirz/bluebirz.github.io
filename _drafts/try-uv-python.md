---
title: "Let' try: UV for faster Python installing"
layout: post
author: bluebirz
description:
# date: 
categories: []
tags: [let's try, Python, UV]
mermaid: false
comment: true
image:
  path: ../assets/img/features/
  alt: Unsplash / 
  caption: <a href="">Unsplash / </a>
media-path: ../assets/img/features/bluebirz/
---

Recently, I have been using `UV` for some time and here I would like to share about this.

---

## What is UV

`UV` is an alternative to `pip` for Python with the tag line saying that `UV` is super fast than `pip`

1. install uv
1. using devbox
1. get start uv

## h2

![image]({{ page.media-path  }}IMG_6642-are.jpg){:style="max-width:75%;margin:auto;"}

{% include bbz_custom/link_preview.html url='<https://github.com/astral-sh/uv>' %}

---

### h3

```sh
devbox init
devbox add uv
devbox generate direnv --force

uv python install 3.12
uv venv
source .venv/bin/activate

devbox update
```

---

#### h4
