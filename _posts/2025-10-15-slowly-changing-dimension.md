---
title: "Slowly Changing Dimensions"
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

We capture data into our databases and data warehouses, and data can come and change over time.

Let's talk about the concept of capturing those changes.

---

## Slowly Changing Dimensions (SCD)

**Slowly Changing Dimensions** or **SCD** is one of core concepts in data warehousing. When we receive new data every day, how could we keep them into our data warehouses in an effective way in terms of cost, performance, and quality?

---

## Types of SCD

SCD can be divided into many types, and each type has its own way to maintain data change. In this blog I will share only 5 popular types:

|Type|Action|
|:-:|-|
|Type 0|No change|
|Type 1|Overwrite|
|Type 2|Insert rows|
|Type 3|Separate historical columns|
|Type 4|Separate historical tables|

There are type 5 which is type 1 + 4, type 6 which is type 1 + 2 + 3, and more but they are not much popular because they're too specific for general use cases and quite challenging to implement.

<br/>

### SCD type 0

Type 0 is a type of unchanging or constants e.g. postal codes.

![type0]({{ page.media_dir }}scd-type0-dark.png){: .dark style="max-width:66%;margin:auto;"}
![type0]({{ page.media_dir }}scd-type0-light.png){: .light style="max-width:66%;margin:auto;"}

### SCD type 1

Type 1 is an overwriting, no old data is kept. It's good in case we don't want to maintain the history or the data is not much important and we want just a current data.

![type1]({{ page.media_dir }}scd-type1-dark.png){: .dark style="max-width:66%;margin:auto;"}
![type1]({{ page.media_dir }}scd-type1-light.png){: .light style="max-width:66%;margin:auto;"}

### SCD type 2

Type 2 is a popular one when we need to track all history then we keep adding the updated rows into the tables but gain more table size in exchange.

To indicate which record is older or newer, we usually add date time columns like `created_at`, `updated_at`, `effective_date` or some flags such as `is_current` or similar for that purpose.

This type should have a new **surrogate key** as a primary key (`sid` in this figure) because original keys (natural keys) would be duplicated when we insert new records of the same key.

![type2]({{ page.media_dir }}scd-type2-dark.png){: .dark style="max-width:80%;margin:auto;"}
![type2]({{ page.media_dir }}scd-type2-light.png){: .light style="max-width:80%;margin:auto;"}

### SCD type 3

Type 3 is to separate the historical data into dedicated columns. We can choose that we are going to:

- track the first values (to see the first and the last), *or*
- track the previous values (to see the recent changes)

Surrogate keys are unnecessary for this type.

![type3]({{ page.media_dir }}scd-type3-dark.png){: .dark style="max-width:90%;margin:auto;"}
![type3]({{ page.media_dir }}scd-type3-light.png){: .light style="max-width:90%;margin:auto;"}

### SCD type 4

Type 4 means we maintain:

- a separated table to track the history (like type 3), *and*
- update the main table to keep latest data (like type 1).

It's useful when we need to trace back we can find in historical table, and find the main table in most cases to see the recent data. And surrogate keys are necessary for this type with the same reason as type 2.

![type4]({{ page.media_dir }}scd-type4-dark.png){: .dark style="max-width:95%;margin:auto;"}
![type4]({{ page.media_dir }}scd-type4-light.png){: .light style="max-width:95%;margin:auto;"}

---

## OLTP vs OLAP

Basically we can distinguish two types of database systems as:

**OLTP (Online Transaction Processing)**
:   - designed for transactional data
    - optimized for writing data, fast query processing, and maintaining data integrity
    - Example databases are MySQL and Oracle
    - Example use cases are customer relationship management (CRM), e-commerce platforms, and banking systems

**OLAP (Online Analytical Processing)**
:   - designed for analytics and complex queries
    - optimized for read-heavy operations and support decision-making processes
    - Example databases are Google BigQuery and Amazon RedShift
    - Example use cases are data warehouses and business intelligence systems

---

## SCD in my works

In my experience that mostly involves with OLAP such as Google BigQuery, Slowly Changing Dimensions (SCD) type 2 is the type I have used the most with **INSERT** statements for adding new records. On par with that, **MERGE** statements or **upsert** (insert + update) are also frequent ones to update the existing records and insert the new ones. So I can keep track every changes.

---

## References

- [Implementing Slowly Changing Dimensions (SCDs) in Data Warehouses](https://www.sqlshack.com/implementing-slowly-changing-dimensions-scds-in-data-warehouses/)
- [Slowly Changing Dimensions(SCD): Types with Examples](https://hevodata.com/learn/slowly-changing-dimensions/)
- [Slow Changing Dimension Type 2 and Type 4 Concept and Implementation \| by Amitava Nandi \| Medium](https://apu-nandi88.medium.com/slow-changing-dimension-type-2-and-type-4-concept-and-implementation-398c8dec7030)
- [Slowly changing dimension - Wikipedia](https://en.wikipedia.org/wiki/Slowly_changing_dimension#Type_3:_add_new_attribute)
- [SCD: Slowly Changing Dimension, an Ultimate Guide - RADACAD](https://radacad.com/scd-slowly-changing-dimension-an-ultimate-guide/)
- [Slowly Changing Dimension (SCD) Type 3 - Kontext](https://kontext.tech/project/u3410/diagram/slowly-changing-dimension-scd-type-3)
