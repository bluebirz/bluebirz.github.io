---
title:
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
  path: https://images.unsplash.com/photo-1654009834418-56fec7458b93?q=80&w=1486&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1654009834418-56fec7458b93?q=10&w=490&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Lana Svet
  caption: <a href="https://unsplash.com/photos/a-couple-of-cats-sitting-next-to-each-other-Uww91YzLakU">Unsplash / Lana Svet</a>
---

<https://stackoverflow.com/questions/51311774/efficient-way-to-compare-two-tables-in-bigquery>

```sql
SELECT "exist in A" as result, *
FROM (
  SELECT * FROM table_a
  EXCEPT DISTINCT 
  SELECT * FROM table_b
)
UNION ALL
SELECT "exist in B" as result, *
FROM (
  SELECT * FROM table_b
  EXCEPT DISTINCT
  SELECT * FROM table_a
)
```

not struct
