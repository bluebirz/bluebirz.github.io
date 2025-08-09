---
title: Screen mirroring from iPad to Mac
layout: post
author: bluebirz
description: How can we connect iPad to mac for some benefits like sharing screen in the meetings? 
date: 2020-11-27
categories: [tips & tricks]
tags: [screen mirroring, iPad, Mac, QuickTime Player]
comment: true
image:
  path: https://images.unsplash.com/photo-1581646064576-6bc5a216f02c?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1581646064576-6bc5a216f02c?q=10&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Harris Vo
  caption: <a href="https://unsplash.com/photos/black-laptop-computer-on-brown-wooden-table-rNWzd_8rRI4">Unsplash / Harris Vo</a>
---

{% include bbz_custom/styling-columns.html %}

I just bought a new iPad with Apple Pencil. My needs are related to writing and planning. I already have company's macbook pro and got some good ideas.

How can we connect iPad to mac for some benefits like sharing screen in the meetings? Here are my search result sites.

- [Use AirPlay to stream video or mirror the screen of your iPhone or iPad](https://support.apple.com/en-us/HT204289)
- [Feasible Ways to Share iPad Screen on Mac](https://letsview.com/share-ipad-screen-on-mac.html)

Know there are 3 ways to do so.

---

## 1. AirPlay

![airplay](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/ipad-to-mac/IMG_9C43B222C91B-1.jpeg){: style="max-width:60%;margin:auto;" .apply-border}

It requires Apple TV for doing "mirror screen" and I don't have one.

Pass.

---

## 2. Third party apps

Problem solved by credit cards to purchase some apps in the App Store but I don't want to.

Pass.

---

## 3. QuickTime Player

It worked for me because it requires more 2 things that I already have.

1. QuickTime Player which is installed in every mac (I think) and
1. Wires

How we start is first connect the wire between iPad and mac. Then we can find iPad name in Finder.

![finder](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/ipad-to-mac/Screen-Shot-2020-11-22-at-19.52.18.png)

Next, open QuickTime and start "New Movie Recording". This process have to turn on the camera and we have to allow this by going to <kbd>System Preference</kbd> ≫ <kbd>Security & Privacy</kbd> ≫ <kbd>Privacy</kbd> ≫ <kbd>Camera</kbd>.

![quicktime](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/ipad-to-mac/Screen-Shot-2020-11-22-at-19.53.24.png){: style="max-width:60%;margin:auto;" .apply-border}

Now we can see the red button of record. Click the dropdown icon and change "Camera" to the iPad name.

<div class="row">
    <div class="col-2">
        <img src="https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/ipad-to-mac/Screen-Shot-2020-11-22-at-19.58.45.png" alt="quicktime ui" loading="lazy">
        <em>click the arrow right to the red dot</em>
    </div>
 <div class="col-2">
        <img src="https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/ipad-to-mac/Screen-Shot-2020-11-22-at-19.58.50.png" alt="select input/output" loading="lazy">
        <em>select a camera as an iPad</em>
    </div>
</div>

Right now we can mirror iPad screen successfully.

![test mirror](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/ipad-to-mac/record01.gif)

However, I experienced some errors.

1. Connected the wire but iPad connection is looped connected and disconnected.  
  Most reasons are the wire with condition. Try a new wire.
1. Already selected iPad as camera but got the message "The operation could not be completed" with black screen in QuickTime.  
  Mine backed to normal by restart iPad once. By the way there are many discussions about this in the forum [here](https://discussions.apple.com/thread/250135238).
