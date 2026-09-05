---
title: Data needs Quality Checks
layout: post
author: bluebirz
description: We always have to ensure that data quality meets standards before using.
date: 2026-09-05
categories: [data, data engineering]
tags: [data quality, SQL, Google BigQuery, Google Cloud Platform, Google Cloud Knowledge Catalog, dbt, Elementary]
comment: true
image:
  path: https://images.unsplash.com/photo-1566699270403-3f7e3f340664?q=80&w=1473&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1566699270403-3f7e3f340664?q=10&w=490&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Wonderlane
  caption: <a href="https://unsplash.com/photos/office-table-with-pile-of-papers-6jA6eVsRJ6Q">Unsplash / Wonderlane</a>
---

We have to refine, assure, and verify whether the data in our hands is sufficiently qualified.

Here we are talking about data quality.

---

## Why data quality?

When we integrate data into our system, who can guarantee the data is ready to consume? We always have to ensure that data quality meets standards before using.

Once the qualification is done, we the data engineer should be able to see the result. In case of failures, notifications should be raised to us to investigate and fix early.

Data qualification we're gonna discuss here is the dimensions of data quality. These are several dimensions that we can test to see if there are some misqualified data or not.

---

## Data quality dimensions

### Uniqueness

Uniqueness measures whether the data is distinct with no duplicates.

**Use when:** The column is expected to be unique such as ID.

**Example:** This query is to find out duplicate values.

```sql
SELECT column_name
FROM table_name
GROUP BY column_name
HAVING COUNT(column_name) > 1
```

### Freshness

Freshness measures when the data was last updated. This indicates how late the data currently is and help us consider to rerun or contact data sources or else.

**Use when:** The data needs to be delivered on time and it often is real-time or near real-time data.

**Example:** This query is to find out if latest `updated_at` is over 3 hours ago from now.

```sql
SELECT TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), MAX(updated_at), HOUR) > 3 AS is_freshness_over_3h
FROM table_name
```

### Volume

Volume measures whether all of the expected data is present. We consider this to find **peak** and **trough** to see anomalies in the data.

**Use when:** The data needs to be as much as expected. When the data come too much or too little, this may be alerted for abnormality.

**Example:** This query is to find any day that has number of records over 25% compared to the previous day.

```sql
WITH
  daily_count AS (
    -- compute daily count of records
    SELECT timestamp_trunc(transaction_datetime, day) AS dt, COUNT(*) AS cnt
    FROM table_name
    GROUP BY 1
  ),
  add_prev_day AS (
    -- add previous day
    SELECT *, LAG(cnt) OVER (ORDER BY dt) AS prev_dt 
    FROM daily_count
  ),
  calc_diff AS (
    -- calculate difference percentage between current day and previous day (0% - 100%)
    SELECT *, SAFE_DIVIDE(ABS(cnt - prev_dt) * 100.0, prev_dt) AS diff_percent
    FROM add_prev_day
  )
SELECT *
FROM calc_diff
WHERE diff_percent >= 25
```

### Completeness

Completeness assesses whether the data contains all of the information that's required for its intended purpose. Simply put that this is `null` check.

**Use when:** The data should not be `null` or missing.

**Example:** This query is to find number of `null` in a column.

```sql
SELECT COUNT(column_name)
FROM table_name
WHERE column_name IS NULL
```

### Validity

Validity evaluates whether the data conforms to predefined standards. They could be by format, acceptable ranges, or other criteria.

**Use when:** The data is needed to be in certain formats, ranges, or a list of values. For example, a valid date needs to have the format `YYYY/mm/dd`. A valid sales price for an item is between $10 and $20.

**Example:** This query is to find any rows having invalid format or price out of range.

```sql
SELECT id
FROM table_name
WHERE SAFE.PARSE_DATE("%Y/%m/%d", transaction_date) IS NULL
  OR price NOT BETWEEN 10 AND 20
```

> `SAFE.<func_name>` prefix in BigQuery returns `NULL` instead of error when the function caught an error
{: .prompt-tip }

### Consistency

Consistency means same reference values across multiple instances, such as tables and columns.

Inconsistency causes broken data references and may lead to major problems, for example, every items in sale orders must be registered in goods table, otherwise there must be human errors somewhere.

**Use when:** The data is linked (reference keys or composite keys) between tables and they should exist and exactly matched, otherwise they're non-reference and have no meanings from unreal values.

**Example:** This query is to find out values `reference_to_b` in `table_a` where they're not found (`NOT EXISTS`) in `id` of `table_b`.

```sql
SELECT reference_to_b
FROM table_a
WHERE
  NOT EXISTS (
    SELECT id
    FROM table_b
    WHERE table_a.reference_to_b = table_b.id
  )
```

### Accuracy

Accuracy reflects the correctness of the data. Accuracy is different from Validity. Valid data may not be accurate.

**Use when:** The data needs to be feasible and correct in order to verify and utilize in other activities.

**Examples:** Accuracy can be in various terms such as model accuracy.

```sql
SELECT accuracy > 0.95
FROM model_metrics
WHERE model_name = 'model_a'
```

Or accuracy in terms of real-world aspect such as unverified users should not exist in the table.

```sql
SELECT user_id
FROM user_portfolio
WHERE verified_status IS FALSE
```

### Integrity

Data Integrity refers to overall data accuracy, completeness, and consistency throughout the whole life cycle. Let's say we have a file of 1,000 rows in a bucket, and we load it into a table, we must have those 1,000 rows in the table.

**Use when:** The data needs to be proven it's maintained correctly and consistently from end to end of the workflows. There is no missing or mismatched data during the process.

**Example:** This query is to cross check between job logs table and raw data table to find out if there are any day the record counts are mismatched or missing data in either side.

```sql
SELECT l.date, l.record_count, r.updated_at, r.cnt
FROM job_logs l
FULL OUTER JOIN (
  SELECT updated_at, COUNT(*) AS cnt 
  FROM table_raw
) r ON (DATE(l.date) = DATE(r.updated_at))
WHERE l.record_count != r.cnt 
  OR l.record_count IS NULL
  OR r.cnt IS NULL

```

---

## Tools

- **Google Cloud Knowledge Catalog** (formerly Dataplex) provides [Auto Data Quality](https://docs.cloud.google.com/dataplex/docs/auto-data-quality-overview) service to qualify and monitor our data in BigQuery.
- **dbt test** (posted at [Let's try: dbt part 7 - tests]({% post_url 2025-12-14-try-dbt-part-7 %})). This is one of dbt features to verify data quality in dbt.
- **[Elementary](https://www.elementary-data.com/)**. A tool integrated with dbt to monitor incidents, data quality, and more.

---

Right now we know the way we can check how much quality our data is.

---

## References

- [SAFE. prefix \| Function calls  \|  BigQuery  \|  Google Cloud Documentation](https://docs.cloud.google.com/bigquery/docs/reference/standard-sql/functions-reference#safe_prefix)
- [Auto data quality overview  \|  Dataplex Universal Catalog  \|  Google Cloud](https://cloud.google.com/dataplex/docs/auto-data-quality-overview)
- [Data Consistency vs Data Integrity: Similarities and Differences \| IBM](https://www.ibm.com/think/topics/data-consistency-vs-data-integrity)
- [The 6 Data Quality Dimensions with Examples \| Collibra \| Collibra](https://www.collibra.com/blog/the-6-dimensions-of-data-quality)
