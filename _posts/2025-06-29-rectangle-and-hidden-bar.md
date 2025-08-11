---
title: "Window management apps for Mac"
layout: post
author: bluebirz
description: Rectangle and Hidden Bar can help you manage your window and menu bar on Mac.
date: 2025-06-29
categories: [apps]
tags: [Rectangle, Hidden Bar]
comment: true
image:
  path: https://images.unsplash.com/photo-1532615470080-39f17172bc1e?q=80&w=2096&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip:  https://images.unsplash.com/photo-1532615470080-39f17172bc1e?q=10&w=2096&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Kaleidico
  caption: <a href="https://unsplash.com/photos/person-holding-white-apple-magic-mouse-beside-imac-and-keyboard-6YwkNenlDkI">Unsplash / Kaleidico</a>
---

{% include bbz_custom/styling-columns.html %}

As a Mac user, I would like to introduce these 2 free apps that improve productivity by better managing your window and menu bar. Your screen will be under your control with just a few fingers.

---

## Rectangle

This Rectangle app is a free app that allows us to control the window size just by keyboard shortcuts. It's very convenient for developers and others who are familiar with keyboards and it's super fast to move the window around in and across desktops. Moreover, we can customize the shortcuts as we want.

### Alternatives

- [Amethyst](https://ianyh.com/amethyst/)
- [Magnet](https://magnet.crowdcafe.com/)

### Shortcuts

<div class="row">
  <div class="col-2">
    <img src="https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/rectangle-hidden-bar/rectangle.png" alt="rectangle" style="max-width:75%;margin:auto;" />
  </div>
  <div class="col-2" style="text-align:left;margin-top:1em;">
    <p>There are many shortcuts but here are my list of keys I use frequently.</p>
    <ul>
      <li><kbd>ctrl</kbd>+<kbd>opt</kbd>+<kbd>&larr;</kbd> to left-half side</li>
      <li><kbd>ctrl</kbd>+<kbd>opt</kbd>+<kbd>&rarr;</kbd> to right-half side</li>
      <li><kbd>ctrl</kbd>+<kbd>opt</kbd>+<kbd>Enter</kbd> to maximize to full screen</li>
      <li><kbd>ctrl</kbd>+<kbd>opt</kbd>+<kbd>Backspace</kbd> to restore back to original size</li>
      <li><kbd>ctrl</kbd>+<kbd>opt</kbd>+<kbd>c</kbd> to align the window into the center of screen</li>
      <li><kbd>ctrl</kbd>+<kbd>opt</kbd>+<kbd>cmd</kbd>+<kbd>&larr;</kbd> to send current window to previous desktop</li>
      <li><kbd>ctrl</kbd>+<kbd>opt</kbd>+<kbd>cmd</kbd>+<kbd>&rarr;</kbd> to send current window to next desktop</li>
    </ul>
  </div>
</div>

Here is the official website of Rectangle.

{% include bbz_custom/link_preview.html url="<https://rectangleapp.com/>" %}

---

## Hidden Bar

This free app can hide your app icons in the system tray to show just essentials and you can toggle to see them all. The app allows settings such as auto hide and the toggle shortcut.
![hiddenbar-dark](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/rectangle-hidden-bar/hiddenbar-dark.drawio.png){:style="max-width:75%;margin:auto;margin-top:2em;margin-bottom:2em;" .dark}
![hiddenbar-light](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/rectangle-hidden-bar/hiddenbar-light.drawio.png){:style="max-width:75%;margin:auto;margin-top:2em;margin-bottom:2em;" .light}

### Alternatives

- [Bartender](https://www.macbartender.com/)

### Settings

There are several options in this app's settings here.

![hiddenbar-settings](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/rectangle-hidden-bar/hiddenbar-settings.png){:style="max-width:90%;margin:auto;"}

Here is the repo of Hidden Bar.

{% include bbz_custom/link_preview.html url="<https://github.com/dwarvesf/hidden>" %}

However, there are some reports that installing the app from Homebrew may experience Apple's warning like this.

![hiddenbar-alert](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/rectangle-hidden-bar/hiddenbar-alert.png){:style="max-width:50%;margin:auto;"}

According to the reported issue[^1] in the repo, I found that this command running in Terminal can fix this issues.

```sh
xattr -dr com.apple.quarantine /Applications/Hidden\ Bar.app
```

This command will recursively (`-r`) delete (`-d`) extended attributes (`xattr`) of `com.apple.quarantine` from the app "Hidden Bar" in "Applications" folder. As the result this app can be opened then.

---

## References

[^1]: [Installing from brew won't run due to "Hidden Bar.app" can't be opened...](https://github.com/dwarvesf/hidden/issues/290)
