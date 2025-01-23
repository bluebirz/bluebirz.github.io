---
title: Move to Ghost
layout: post
description: This has been written after I completely and officially migrated this blog from Wordpress to Ghost.
date: 2021-12-26 00:00:00 +0200
categories: [writing]
tags: [blogging, Wordpress, GhostCMS]
image:
  path: ../assets/img/features/tandem-x-visuals-FZOOxR2auVI-unsplash.jpg
  alt: Unsplash / Tandem X Visuals
  caption: <a href="https://unsplash.com/photos/woman-in-white-coat-standing-on-brown-grass-field-during-daytime-FZOOxR2auVI">Unsplash / Tandem X Visuals</a>
---

Hi guys.

This has been written after I completely and officially migrated this blog from Wordpress to [Ghost](https://ghost.org/).

For more than 3 years I started blogging with Wordpress, now I feel Wordpress is too much for me. Doubtedly my own endless desire to decorate it or kinda. I have installed many plugins for improving writing and reading experience. I tweaked it by adding features and later found they're unnecessary. All above made me think to renovate — hmm, nope, revise.

---

## Why I move to Ghost

I knew Ghost a long time back that I decided to start a blog. I have experimented many CMSs to find the best and yeah, I had chosen Wordpress thanks to its ease of deployment and use. Until I felt it's over featured then I did experiment again and found the way to live with Ghost.

Ghost approaches my requirements here:

- It's ready out-of-the-box. Just install and create an account for login then it's done.
- Multilingual without any plugins. Need tiny [configs](https://ghost.org/docs/tutorials/multi-language-content/) to enable this function.
- Integrated Twitter sharing.
- Dark theme for both admin site and reader site.
- New language. Ghost uses `.hbs` files based on NodeJS so it is more readable yet understandable to modify by myself. I'm not familiar with PHP.
- Support markdown. This is the strength of Ghost. Markdown is familiar to developers as it's used for documenting in Git repositories.

---

## Compare between Wordpress and Ghost

Personally, there are huge differences between them from their root concepts. Wordpress has been developed for general purposes and can be freely optimized for professional purposes while Ghost is originally built for blogging fashion.

With Ghost, I can write and focus on only writing. Some formatting can be solved by simple html tags and tiny javascript codes. On the other hand, blogging with Wordpress, I have to find out much more plugins to style the articles because I'm not familiar with PHP. It consumes much time for me.

Can't help but to say I was bored in Wordpress so that's why I decided to move to Ghost here. A big trade-off is a [learning curve](https://ghost.org/docs/) at very first time. Ghost might not be a good fit for non-coders because some features can be unlocked with codes not plugins.

For some reasons, I feel Ghost is faster.

---

## What to do for migration

There are lots to do due to technologies. Because of my messy decorations in Wordpress, I have to clean and rearrange assets.

---

## Blog contents

One of my personal goal is multilingual posts. In Wordpress, It is [WPGlobus plugin](https://wordpress.org/plugins/wpglobus/). Of course, it isn't in Ghost. I finally chose the separated posts for each language and let Ghost manages it. However, using that plugin causes a problem on exporting blog posts from Wordpress. It can export only English. I have to copy Thai posts by myself. Too bad here.

---

## Media

Some posts have massive VDOs and images, especially travel-related ones. I put them all in Wordpress media library. I means all of them stored in its local machine.

Unfortunately, there is no such thing in Ghost (at least now). In the end, I decided to keep them in Amazon S3 and link them to the post. Time-consumed works but it's good to go from the beginning, I guess.

---

## The Bottom line

Some difficulties were found here in Ghost blogging since migrating, but I think I'm right to go this way. Clean code, clean UI, fast web page rendering, and more have impressed me.

I would recommend you readers to try play with things in which you interested and give them enough time until you are certain whether you continue on them.

If you are finding some things for your own life, I wish you shall have them very soon.
