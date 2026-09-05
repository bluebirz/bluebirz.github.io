---
title: Spot the diffs in BigQuery
layout: post
author: bluebirz
description:
# date:
categories: [programming, SQL]
tags: [Googl BigQuery]
pin: true
mermaid: true
comment: true
image:
  path: https://images.unsplash.com/photo-1708412431379-7780c2e07ba3?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1708412431379-7780c2e07ba3?q=10&w=490&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Bruce Hong
  caption: <a href="https://unsplash.com/photos/two-cats-with-blue-eyes-sitting-next-to-each-other-hk-Dn8Jg1b0">Unsplash / Bruce Hong</a>
---

Recently I have to run the data models in Google BigQuery and verify if there are any differences between before and after the changes. I came across this stackoverflow forum[^bq] and found pretty useful for my case so I would like to jot and share it here.

---

## Quick answer

Let's say we have two tables in Google BigQuery and want to compare and find any differences in all columns. We can use this query.

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

Before we go to talk how the query returns data row differences, we shall understand set operators first.

---

## Set operators

Set operators[^setops] are syntax to perform interactions between two or more tables. Other than `JOIN` (which I have published in [How to befriend your queries \| 2. When do we JOIN?]({% post_url 2019-12-03-how-to-befriend-your-queries %}#2-when-do-we-join)), there are 4 useful operators we consider when needed.

### `UNION ALL`

`UNION DISTINCT`
`INTERSECT DISTINCT`
`EXCEPT DISTINCT`

---

## Explanation

This query can be described as below:

- `a EXCEPT DISTINCT b` will return non-duplicate records in `a` that does not exist in `b`.  
  And vice versa, `b EXCEPT DISTINCT a` will return records in `b` that does not exist in `a`.
- On top of each subquery `EXECEPT DISTINCT`, we `SELECT "exist in A"` and `"exist in B"` to identify which table the different records come from.
- Finally, we `UNION ALL` to combine both together to see different records in both tables.

<!-- TODO: diagram.net -->

---

## Examples

---

## Limitations

- `struct` data type is not supported in `EXCEPT DISTINCT`. We need to `SELECT` in field level under the `struct` for examples, `SELECT struct.field1, struct.field2, ...`.
- In other database engines, `EXCEPT DISTINCT` may not work and we have to use other solutions such as `MINUS` in Oracle[^minus].

---

## References

[^bq]: [sql - efficient way to compare two tables in bigquery - Stack Overflow](https://stackoverflow.com/questions/51311774/efficient-way-to-compare-two-tables-in-bigquery)
[^minus]: [How to compare two tables to get the different rows with SQL](https://blogs.oracle.com/sql/post/how-to-compare-two-tables-to-get-the-different-rows-with-sql)
[^setops]: [Set operators \| Query syntax  \|  BigQuery  \|  Google Cloud Documentation](https://docs.cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax#set_operators)
