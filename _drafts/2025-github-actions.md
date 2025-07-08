---
title: "Let's try: Github actions in action"
layout: post
author: bluebirz
description:
# date: 
categories: []
tags: []
mermaid: false
comment: true
image:
  path: assets/img/features/bluebirz/ghact.drawio.png
  lqip: ../assets/img/features/lqip/bluebirz/ghact.drawio.webp
  alt: Github actions icon 
  caption: 
media_subpath:
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

- Workload Identity Federation
- sample yaml file
- github workflow with gcp checkout

## h2

![image]({{ page.media-path  }}IMG_6642-are.jpg){:style="max-width:75%;margin:auto;"}

---

## What is "Github Actions"?

---

## Start a first action

### Simple echo

### Variables

---

## Work with Google Cloud

### Authentication

Workload Identity Federation allows you to authenticate to Google Cloud without needing to store long-lived credentials in your GitHub repository. Instead, you can use short-lived tokens that are automatically generated.

### Checkout step

### Simple gcloud commands

---

## References

- [google-github-actions/auth: A GitHub Action for authenticating to Google Cloud.](https://github.com/google-github-actions/auth)
- [Workload Identity Federation  \|  IAM Documentation  \|  Google Cloud](https://cloud.google.com/iam/docs/workload-identity-federation)
- [Quickstart for GitHub Actions - GitHub Docs](https://docs.github.com/en/actions/get-started/quickstart)
- <https://github.com/actions/runner?tab=readme-ov-file>
