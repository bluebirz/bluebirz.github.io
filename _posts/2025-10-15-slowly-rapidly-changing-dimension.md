---
title: "Slowly & Rapidly Changing Dimensions"
layout: post
author: bluebirz
description: Let's talk about the concept of capturing data changes.
date: 2025-10-15
categories: [data, data engineering]
tags: [slowly changing dimension, rapidly changing dimension, data warehouse]
comment: true
image:
  path: https://images.unsplash.com/photo-1538465502635-af5fa404b9db?q=80&w=1071&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1538465502635-af5fa404b9db?q=10&w=490&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Grant Durr
  caption: <a href="https://unsplash.com/photos/four-brown-turtles-on-brown-soil-o6yVQhM_-fg">Unsplash / Grant Durr</a>
media_dir: https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/scd/
---

Data warehouses capture data, and data can change over time, slowly or rapidly.

Let's talk about the concept of capturing their changes.

---

## Slowly Changing Dimensions (SCD)

**Slowly Changing Dimensions** or **SCD** is one of core concepts in data warehousing. Because we receive new data every day or even every minute, then the question is how could we improve our data warehouses to be effective in cost, performance, and quality.

---

## Types of SCD

SCDs are divided into many types, and each type has its own way of handling data change. But this blog I will share only 5 popular types:

|Type|Action|
|:-:|-|
|Type 0|No change|
|Type 1|Overwrite|
|Type 2|Insert rows|
|Type 3|Separate historical columns|
|Type 4|Separate historical tables|

There are type 5 which is type 1 + 4, type 6 which is type 1 + 2 + 3, and more but they are not much popular because they're too specific for general use cases and quite challenging to implement.

### SCD type 0

Type 0 is a type of unchanging or constants e.g. postal codes.

![type0]({{ page.media_dir }}scd-type0-dark.png){: .dark style="max-width:66%;margin:auto;"}
![type0]({{ page.media_dir }}scd-type0-light.png){: .light style="max-width:66%;margin:auto;"}

### SCD type 1

Type 1 is an overwriting, no old data is kept. It's good in case we don't want to maintain the history or the data is not much important and we want just a current data.

![type1]({{ page.media_dir }}scd-type1-dark.png){: .dark style="max-width:66%;margin:auto;"}
![type1]({{ page.media_dir }}scd-type1-light.png){: .light style="max-width:66%;margin:auto;"}

### SCD type 2

Type 2 is a popular one as we need to track all history then we keep adding the updated rows into the tables but gain more table size in exchange.

To indicate which record is older or newer, we usually add date time columns like `created_at`, `updated_at`, `effective_date` or some flags such as `is_current` or similar for that purpose.

![type2]({{ page.media_dir }}scd-type2-dark.png){: .dark style="max-width:70%;margin:auto;"}
![type2]({{ page.media_dir }}scd-type2-light.png){: .light style="max-width:70%;margin:auto;"}

### SCD type 3

Type 3 is to separate the historical data into dedicated columns. We can choose that we are going to:

- track the original values (to see the first and the last), *or*
- the previous values before change (to see the recent changes)

![type3]({{ page.media_dir }}scd-type3-dark.png){: .dark style="max-width:75%;margin:auto;"}
![type3]({{ page.media_dir }}scd-type3-light.png){: .light style="max-width:75%;margin:auto;"}

### SCD type 4

Type 4 means we maintain:

- a separated table to track the history (like type 3), *and*
- update the main table to keep latest data (like type 1).

It's useful when we need to trace back we can find in historical table, and find the main table in most cases to see the recent data.

![type4]({{ page.media_dir }}scd-type4-dark.png){: .dark style="max-width:75%;margin:auto;"}
![type4]({{ page.media_dir }}scd-type4-light.png){: .light style="max-width:75%;margin:auto;"}

---

## Rapidly Changing Dimensions (RCD)

While Slowly Changing Dimensions (SCD) is how we handle data changes periodically, **Rapidly Changing Dimensions (RCD)** is how we handle data changes in real-time or near real-time.

For example, we load data of a customer changing profile information every day. If a customer changes their profile two, three or more time within a day, we may lose those changes. Therefore, the solution of capturing those changes could be:

- log tables such as Google Cloud Audit Logs and export to Google BigQuery, *or*
- integrate with message queue services such as Google Cloud Pub/Sub and push to Google BigQuery, or just streaming inserts to Google BigQuery.

---

## Changing Dimensions in my works

In my experience, Slowly Changing Dimensions (SCD) type 2 is the type I have used the most as **INSERT** statements for adding new records. On par with that, **MERGE** statements or **upsert** (insert + update) are frequent ones of mine to update the existing records and insert the new ones. So I can keep track every changes.

When it comes to Rapidly Changing Dimensions (RCD), I use streaming pipelines such as Google Cloud Pub/Sub then push to Google Dataflow and/or Google BigQuery which supports streaming buffer before inserting into the tables.

---

## References

- [Implementing Slowly Changing Dimensions (SCDs) in Data Warehouses](https://www.sqlshack.com/implementing-slowly-changing-dimensions-scds-in-data-warehouses/)
- [Slowly Changing Dimensions(SCD): Types with Examples](https://hevodata.com/learn/slowly-changing-dimensions/)
- [Slow Changing Dimension Type 2 and Type 4 Concept and Implementation \| by Amitava Nandi \| Medium](https://apu-nandi88.medium.com/slow-changing-dimension-type-2-and-type-4-concept-and-implementation-398c8dec7030)
- [Slowly changing dimension - Wikipedia](https://en.wikipedia.org/wiki/Slowly_changing_dimension#Type_3:_add_new_attribute)
- [SCD: Slowly Changing Dimension, an Ultimate Guide - RADACAD](https://radacad.com/scd-slowly-changing-dimension-an-ultimate-guide/)
- [why no one talks about fast changing dimension ? : r/dataengineering](https://www.reddit.com/r/dataengineering/comments/1d2ntp0/why_no_one_talks_about_fast_changing_dimension/)
