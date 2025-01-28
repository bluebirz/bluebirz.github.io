---
title: Move to Github Pages
layout: post
description: Now I migrate my blog from GhostCMS to Github Pages
date: 2025-01-28 00:00:00 +0200
categories: [writing]
tags: [blogging, GhostCMS, Github Pages, Jekyll]
image:
  path: https://images.unsplash.com/photo-1618401471353-b98afee0b2eb?q=80&w=2088&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Roman Synkevych
  caption: <a href="https://unsplash.com/photos/black-and-white-penguin-toy-wX2L8L-fGeA">Unsplash / Roman Synkevych</a>
---

I have migrated this blog from Ghost to Github pages.

It's been a little over 3 years since I moved to Ghost after Wordpress.

---

## Why I move to Github Pages

I would say I'm happy with Ghost all over 3 years here.

{% include bbz_custom/link_preview.html post='2021-12-26-move-to-ghost' %}

but from time to time I felt I have paid more money more than I need. There are 3 big reasons here:

1. I hosted my Ghost blog in Amazon Lightsail and ended up paying around 5 bucks a month and increased to 7 bucks recently.
1. There is no CI/CD thing.
1. Due to Lightsail instance, I have to update Ghost package (in NodeJS) and I found it's not easy for me to upgrade version.

And there are advantages of Github Pages I like:

1. CI/CD  
  Because I hosted this blog in Github so I can make version control and CI/CD so good.
1. No cost  
  Yes, because of Github again.
1. Customization  
  I can add and reuse modules, scripts, templates, etc. as I want.

However I dealt with time of migrating posts and data to this place and learning curve of new programming language, **Jekyll**.

{% include bbz_custom/link_preview.html url='<https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll>' %}

---

## How I do migrating

1. First of all, when I decided to move to Github Pages, I've **checked options and framework** and I chose Jekyll.
1. Then I **chose themes**. I tried some themes and chose [Chirpy](https://chirpy.cotes.page). This is my like.
1. I **copied posts** from Ghost into markdown files. Fortunately, I stored my media files in AWS S3 buckets from when I moved to Ghost so that I can embed them in no time.
1. I **improve styling** in CSS files.
1. I **updated DNS** in CloudFlare in order to route Github Pages domain (`DOMAIN.github.io`) to my domain (`bluebirz.net`). I followed [this article](https://blog.cloudflare.com/secure-and-fast-github-pages-with-cloudflare/).
1. Test and deploy through github actions provided by the theme developer that already included in the theme.

---

## The Bottom line

I still recommend to use Wordpress, Ghost, or other ready-to-use blogging CMS if you are very new and want to just focus on writing. They are UI-based and many VMs supporting those framework from scratch, like few clicks and done.

But if you have some programming knowledge, using Github, and want to make it zero cost, you can try Github Pages. Pick a theme you'd like and start the project.
