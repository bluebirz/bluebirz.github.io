---
title: Photo Hunt in BigQuery tables
layout: post
author: bluebirz
description: There are differences between two tables, but how to find them?
date: 2026-09-12
categories: [programming, SQL]
tags: [Google BigQuery]
comment: true
image:
  path: https://images.unsplash.com/photo-1708412431379-7780c2e07ba3?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1708412431379-7780c2e07ba3?q=10&w=490&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Bruce Hong
  caption: <a href="https://unsplash.com/photos/two-cats-with-blue-eyes-sitting-next-to-each-other-hk-Dn8Jg1b0">Unsplash / Bruce Hong</a>
media_dir: https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/sqlcmp/
---

Recently I have to run the data models in Google BigQuery and verify if there are any differences between before and after the changes. I came across this stackoverflow forum[^bq] and found it's pretty useful for my case so I would like to share it here as well.

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

Set operators[^setops] are syntax to perform interactions between two or more tables. Other than `JOIN` (which I have published in [How to befriend your queries \| 2. When do we JOIN?]({% post_url 2019-12-03-how-to-befriend-your-queries %}#2-when-do-we-join))

There are 4 useful operators we can consider to use when it's needed.

### `UNION ALL`

This includes everything from both left and right tables and preserve duplicate records.

There are data from both tables, including "Bria" and "Carleton" appear twice in the diagram below.

![union all light]({{ page.media_dir}}union-all-light.png){: .light style="max-width:65%;margin:auto;"}
![union all dark]({{ page.media_dir}}union-all-dark.png){: .dark style="max-width:65%;margin:auto;"}

### `UNION DISTINCT`

This includes everything from both tables but keeps only unique records.

"Bria" and "Carleton" now appear once along with the rest from both tables.

![union distinct light]({{ page.media_dir}}union-distinct-light.png){: .light style="max-width:65%;margin:auto;"}
![union distinct dark]({{ page.media_dir}}union-distinct-dark.png){: .dark style="max-width:65%;margin:auto;"}

### `INTERSECT DISTINCT`

This finds duplicate records from both tables, and concludes only unique ones from them.

Only "Bria" and "Carleton" appear here.

![intersect distinct light]({{ page.media_dir}}intersect-distinct-light.png){: .light style="max-width:65%;margin:auto;"}
![intersect distinct dark]({{ page.media_dir}}intersect-distinct-dark.png){: .dark style="max-width:65%;margin:auto;"}

### `EXCEPT DISTINCT`

This includes everything from both tables, excluding duplicate records.

Only data in left-side table except "Bria" and "Carleton" that also appear in another table.

![except distinct light]({{ page.media_dir}}except-distinct-light.png){: .light style="max-width:65%;margin:auto;"}
![except distinct dark]({{ page.media_dir}}except-distinct-dark.png){: .dark style="max-width:65%;margin:auto;"}

---

## Explanation

Now we go back to the first query above, it can be described as below:

- `a EXCEPT DISTINCT b` will return unique records in `a` that does not exist in `b`.  
  And vice versa, `b EXCEPT DISTINCT a` will return records in `b` that does not exist in `a`.
- On top of each subquery `EXECEPT DISTINCT`, we `SELECT "exist in A"` and `"exist in B"` to identify which table the different records come from.
- Finally, we `UNION ALL` to combine two results together to see different records in both tables.
- `UNION DISTINCT` returns the same result as `UNION ALL` but it additionally computes unique rows. Therefore, we use `UNION ALL` which is a bit faster.

![explain light]({{ page.media_dir}}explain-light.png){: .light style="max-width:100%;margin:auto;"}
![explain dark]({{ page.media_dir}}explain-dark.png){: .dark style="max-width:100%;margin:auto;"}

---

## Limitations

- Both tables must have same schemas. Number of columns and each data types need to be exactly the same.
- `array` and `struct` data types are not supported in `UNION DISTINCT`, `INTERSECT DISTINCT`, and `EXCEPT DISTINCT`. We need to `unnest` an array or `SELECT` in field level under the `struct` for examples, `SELECT struct.field1, struct.field2, ...`.
- In other database engines, `EXCEPT DISTINCT` may not work and we have to use other solutions such as `MINUS` in Oracle[^minus].

---

## My application

I find the set operators are useful for data stitching and data investigation as I did in the past.

My scenario was to find and expect no differences between before and after updating the models, so these are my steps:

1. I ran the model before making changes and stored in table A.
1. I made changes, ran again and stored in table B.
1. I queried using `EXCEPT DISTINCT` comparing both and stored in a temporary table, says `table_compare`.
1. I queried on `table_compare` and sort rows based on keys, timestamps, and the result column to see if it "exist in a" or "exist in b".
1. As the example below, I made it adjacently for before-and-after comparison and scan through them to spot differences in every columns.

    ```sql
    SELECT result, key, timestamp, col_a, col_b, col_c
    FROM table_compare
    ORDER BY key, timestamp, result  

    /*
    sample result:

    | result     | key | timestamp  | col_a | col_b | col_c |
    | ---------- | --- | ---------- | ----- | ----- | ----- |
    | exist in A | 001 | 2026-01-01 | A     | B     | C     |
    | exist in B | 001 | 2026-01-01 | A     | B     | K     |
    | exist in A | 002 | 2026-02-02 | Q     | W     | E     |
    | exist in B | 002 | 2026-02-03 | Q     | W     | R     |
    */
    ```

1. When found issued columns, I ran the queries again, scoping those columns for a couple of times to make sure if they're actually something.
1. Investigated into the model logics specially on those columns and fixed them.

Now the models were fixed successfully.

---

## References

[^bq]: [sql - efficient way to compare two tables in bigquery - Stack Overflow](https://stackoverflow.com/questions/51311774/efficient-way-to-compare-two-tables-in-bigquery)

[^minus]: [How to compare two tables to get the different rows with SQL](https://blogs.oracle.com/sql/post/how-to-compare-two-tables-to-get-the-different-rows-with-sql)

[^setops]: [Set operators \| Query syntax  \|  BigQuery  \|  Google Cloud Documentation](https://docs.cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax#set_operators)
