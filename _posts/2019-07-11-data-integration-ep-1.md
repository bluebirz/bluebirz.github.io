---
title: Data Integration (EP 1) – Give me your data
layout: post
author: bluebirz
description: There are jargons that is ETL (Extract-Transform-Load) and ELT (Extract-Load-Transform)
date: 2019-07-11 22:52:00 +0200
categories: [data, data engineering]
tags: [ETL, ELT, Talend]
image: 
  path: https://images.unsplash.com/photo-1585413912691-77d3a4469e40?q=80&w=1073&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Fabio Sasso
  caption: <a href="https://unsplash.com/photos/green-and-white-metal-pipe-lw11Pfusquw">Unsplash / Fabio Sasso</a>
---
[expand-series]

  1. Data Integration (EP 1) – Give me your data
  1. [Data Integration (EP 2) - Take it out]({% post_url 2019-08-10-data-integration-ep-2 %})
  1. [Data Integration (EP 3 end) - clock-work]({% post_url 2019-08-17-data-integration-ep-3 %})

[/expand-series]

Greeting all guys and myself … again!!

This is my new series about data management. Let's go!

---

I would inform you all that my main role, data engineer, is to maintain the data. I mean all of the data that our organisation is taking care of, no matter where they are and what form they are. The core idea is how to manage them all in the place and format that our customers can access to with ease to use.

Normally, here are the main topics we must know before the actions:

1. Where is the source  
  e.g. CSV files, Excel files, APIs provided by some websites, or database systems
1. Where is the destination  
  for example, data from Excel files will be in our database system
1. How to transform the data  
  such as we need gender field by applying a condition on a form of address
1. When and how often
1. How is after process  
  For example, move the source files to backup folders

There is a jargon that is:  

**ETL (Extract-Transform-Load)**

It is to extract data (from source), transform or bending data, then load or store into the destination. However, I usually perform this below:

**ELT (Extract-Load-Transform)**

The difference is ELT is for loading the raw data without transformation. This can prevent data loss for some cases but trade-off with more space of our system.

---

## Suggested tools

![talend logo](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/Talend_logo.svg){:loading="lazy"}
*source: <https://commons.wikimedia.org/wiki/File:Talend_logo.svg>*

Talend is a company working on data managements. One of their products is Talend Open Studio and can be download via the link below:

{% include bbz_custom/link_preview.html url='<https://www.talend.com/products/data-integration/data-integration-open-studio/>' %}

**Pros**: It is a freeware as a community version. We can access the forum in case of any problems.

**Cons**: RAM thirst, due to this is based on JAVA. I recommend 8 GB of RAM as the minimum requirement

---

## Begin the lesson

Let's say we already downloaded the program. Once we open it, it ask us the project. the project is like a folder of our works.

![talend start](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/Screen-Shot-2562-07-24-at-23.07.29.png){:loading="lazy"}

For example, we selected the "Local_Project". Click <kbd>Finish</kbd>.

![talend welcome page](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/Screen-Shot-2562-07-24-at-23.10.49.png){:loading="lazy"}

After project, we go create a new job.

![talend new job](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/Screen-Shot-2562-07-24-at-23.14.14.png){:loading="lazy"}

For example, we name it "sample_job01". A window of package installation will be appeared. Those packages are the component-related external libraries. We skip it for this time and we can install them later.

![talend workspace](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/Screen-Shot-2562-07-24-at-23.19.44.png){:loading="lazy"}

Yeah, we finally reach the main window of this program and can start work on it.

Next episode, we will see how to start a sample job.

See you next time 👋🏼
