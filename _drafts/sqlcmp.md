---
title: Photo hunt in SQL
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
  path: https://images.unsplash.com/photo-1708412431379-7780c2e07ba3?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1708412431379-7780c2e07ba3?q=10&w=490&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Bruce Hong
  caption: <a href="https://unsplash.com/photos/two-cats-with-blue-eyes-sitting-next-to-each-other-hk-Dn8Jg1b0">Unsplash / Bruce Hong</a>
---

Recently I have to run the data models and verify if there are any differences between before and after the changes. I came across [this stackoverflow forum](<https://stackoverflow.com/questions/51311774/efficient-way-to-compare-two-tables-in-bigquery>) and found pretty useful for my case so I would like to jot and share it here.

---

## tl;dr

**tl;dr (too long; don't read)**: Let's say we have two tables and want to compare and find any differences in all columns. We can use this query.

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

This query can be described as below:

- `a EXCEPT DISTINCT b` will return records in `a` that not exist in `b`.  
  And vice versa, `b EXCEPT DISTINCT a` will return records in `b` that not exist in `a`.
- On top of each subquery `EXECEPT DISTINCT`, we `SELECT "exist in A"` and `"exist in B"` to identify which table the different records come from.
- Finally, we `UNION ALL` to combine both together to see different records in both tables.

---

## Examples

<!-- TODO: diagram.net -->

---

## limitations

- `struct` data type is not supported in `EXCEPT DISTINCT`. We need to `SELECT` in field level under the `struct`.
