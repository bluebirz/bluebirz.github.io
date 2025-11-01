---
title: "Medallion architecture - 3 layers of data pipelines"
layout: post
author: bluebirz
description:
# date:
categories: []
tags: []
pin: true
mermaid: true
comment: true
image:
  path: https://images.unsplash.com/photo-1665110161951-6abc48bea1ef?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1469
  lqip: https://images.unsplash.com/photo-1665110161951-6abc48bea1ef?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=10&w=490
  alt: Unsplash / tommao wang
  caption: <a href="https://unsplash.com/photos/a-gold-and-silver-trophy-y7Hc1t3bH4Q">Unsplash / tommao wang</a>
---


{% include bbz_custom/tabs.html %}

We always talk about the common ETL process that is the Medallion Architecture — and its benefits. But have you ever thought about its negatives?

In almost every modern data engineering discussion, especially with tools like Databricks, Synapse, or Snowflake, the Bronze → Silver → Gold model (the so-called Medallion Architecture) gets glorified.

And for good reason — it promotes:

✅ Decoupled data layers (raw → cleansed → curated)

✅ Better data quality checks at each stage

✅ Reusability across multiple downstream use cases

✅ Easier rollback & auditing

 But like everything in engineering, it’s not a free lunch.

Here are some practical CONS of the Medallion Architecture that we often gloss over 👇

 1. Increased data duplication & storage costs

Every stage stores another copy: Bronze, Silver, Gold.

If your data volumes are huge, this quickly adds up to TBs or PBs in cloud storage — and your finance team might not be thrilled.

⏳ 2. Latency & freshness trade-offs

Data needs to traverse multiple hops.

A change in the source system (say a critical correction) might take hours to show up in Gold.

Not ideal for near real-time analytics.

3. Higher pipeline complexity & maintenance overhead

Now you have multiple tables for the same data at different stages.

Need to track schema evolution carefully across Bronze, Silver, Gold.

More DAG edges = more chances of broken dependencies after schema or business logic changes.

4. Risk of business teams bypassing your process

They may run ad-hoc analytics on Bronze for “speed” — but compromise on data quality.

Or worse, use Silver for something it wasn’t curated for, because they can directly access it.

5. Operational overhead for audits & governance

Need strict policies to ensure PII is masked early (ideally at Silver) to avoid leaking sensitive data into curated Gold layers.

Lineage becomes more complicated — especially when regulatory or GDPR audits happen.

So what’s the takeaway?
Medallion is still powerful — but not a silver bullet.

Like every architecture, you have to balance:

✅ Data quality vs data freshness

✅ Storage cost vs operational flexibility

✅ Simplicity vs analytical power

And most importantly, continuously communicate with stakeholders so they understand which layer to use for what.

---

This is true..but bronze silver gold..all will not have same Data..gold is mostly consumer layer..silver does contains transformed data and bronze bronze is anyways raw data..to do time travel on data atleast two layers should be there

---

## References

- [Post of Riya KhandelwalRiya Khandelwal \| LinkedIn](https://www.linkedin.com/posts/riyakhandelwal_dataengineering-databricks-medallionarchitecture-activity-7352340032986234881-tNCj)
