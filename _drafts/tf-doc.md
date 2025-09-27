---
title:
layout: post
author: bluebirz
description:
# date:
categories: []
tags: []
pin: true
math: true 
mermaid: true
comment: true
series:
  key: terraform
  index: 10
image:
  # path: assets/img/features/
  path: https://images.unsplash.com/photo-1695313129813-6a10cdcbb2f4?q=80&w=1631&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1695313129813-6a10cdcbb2f4?q=10&w=490&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Natalia Gasiorowska
  caption: <a href="https://unsplash.com/photos/a-pencil-drawing-of-a-ball-and-a-pencil-rOVY9FD4G_Q">Unsplash / Natalia Gasiorowska</a>
media-folder: ../assets/img/tmp/tfdocs/
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

---

{% include bbz_custom/link_preview.html url="<https://terraform-docs.io/>" %}

brew install terraform-docs

```sh
$ terraform-docs markdown table .
## Requirements

...

## Providers

...

## Modules

...

## Resources

...

## Inputs

...

## Outputs

...
```

This is an example output of the `markdown table` format.

![example dark]({{ page.media-folder }}example-dark.png){: .dark style="max-width:85%;margin:auto;" .apply-border}
![example light]({{ page.media-folder }}example-light.png){: .light style="max-width:85%;margin:auto;" .apply-border}

---

## Insert to README file

---

## Apply into pre-commit
