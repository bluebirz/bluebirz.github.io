---
title: "Let's try: dbt part 6 - snapshots and analyses"
layout: post
author: bluebirz
description: Now we can create snapshots to track history and analyses to observe data
date: 2025-11-25
categories: [data, data engineering]
tags: [let's try, Python, dbt, SQL, Jinja, Google Cloud Platform, Google BigQuery]
comment: true
series:
  key: dbt
  index: 6
image:
  path: assets/img/features/external/dbt.png
  lqip: ../assets/img/features/lqip/external/dbt.webp
  alt: dbt-labs/dbt-core
  caption: <a href="https://github.com/dbt-labs/dbt-core">dbt-labs/dbt-core</a>
media_dir: https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-dbt/dbt6/
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

{% include bbz_custom/tabs.html %}

---

## Snapshots

**Snapshots** are like we "freeze" data at a specific time. They are useful to clearly display how the data was at a point of time or how they are changed over time or just backup.

There are several methods and tools to do so. For example, BigQuery allows us to:

- query data at a point of time with `SYSTEM_TIME`[^systimeasof] like this:

    ```sql
    SELECT *
    FROM `project.dataset.table`
    FOR SYSTEM_TIME AS OF "2025-01-01"
    ```

- create **BigQuery table snapshots**[^bqsnapshots] to be a new table holding the target data table back to the specific `SYSTEM_TIME`.
- or even restore the deleted BigQuery tables using **time travel**[^timetravel] like this:

    ```sh
    epoch=$(date -d '2025-01-01 00:00:00' +%s000)
    bq --project_id=my_project cp dataset.table@$epoch dataset.restored_table
    ```

And now we are using dbt snapshots to create a new table with **SCD type 2**[^scd2].

### Prepare data source

Let's say that we have this source definition of salary data:

{: file='sources.yml'}

```yml
version: 2

sources:
  - name: salary
    schema: raw
    tables:
      - name: salary
        columns:
          - name: id
          - name: name
          - name: salary
          - name: updated_at
```

And the data at the initial and after change are as below:

{% tabs dbt6-source %}

{% tab dbt6-source Initial data %}

![src dark]({{ page.media_dir }}src-dark.png){: .dark style="max-width:100%;margin:auto;" .apply-border}
![src light]({{ page.media_dir }}src-light.png){: .light style="max-width:100%;margin:auto;" .apply-border}

We have 15 rows of people's salary.

{% endtab %}

{% tab dbt6-source Changed data %}

![src dark]({{ page.media_dir }}src-upd-dark.png){: .dark style="max-width:100%;margin:auto;" .apply-border}
![src light]({{ page.media_dir }}src-upd-light.png){: .light style="max-width:100%;margin:auto;" .apply-border}

We have updated salary at row #13-#15 on the same `updated_at` date.

{% endtab %}

{% endtabs %}

### Configurations

To create snapshots[^dbtsnapshot] with dbt, we can define **strategy** by 2 choices.

1. `strategy='timestamp'`  
  This strategy is great and recommended for tables **having an updated timestamp column or similar** to compare and determine which rows have been updated based on the updated timestamp.

1. `strategy='check'`  
  This strategy will check the specific columns (or all columns) to find which rows are changed. This one is useful in case of **no updated timestamp field** with a trade-off to compute multiple columns to find differences.

Then we can start writing configurations:

- dbt version 1.8 or earlier, refer to legacy[^snapshotlegacy] configurations in Jinja blocks (not cover in this blog).
- dbt version 1.9 or later, we are writing YAML files in this structure.

```yml
snapshots:
  - name: <snapshot_name>
    relation: <source() or ref()>
    description: <description>
    config:
      strategy: <timestamp|check>
      unique_key: <unique_key_field>
      check_cols: <'all'|[column_names] when strategy='check'>
      updated_at: <updated timestamp field when strategy='timestamp'>
```

### Execution

We run the command below to build snapshots.

```sh
dbt snapshot
```

### Execute strategy: timestamp

First we can try building snapshots with `timestamp` strategy.

{% tabs dbt6-ts %}

{% tab dbt6-ts snapshots-salary.yml %}

{: file='snapshots/snapshots-salary.yml'}

```yml
snapshots:
  - name: snapshot-salary-timestamp
    relation: source('salary', 'salary')
    config:
      target_schema: snapshots
      alias: salary_ts
      strategy: timestamp
      unique_key: id
      updated_at: updated_at
```

We are using `timestamp` strategy on the source `salary` which has `id` as a unique_key and `updated_at` as an updated timestamp field.

{% endtab %}

{% tab dbt6-ts Initial run %}

![timestamp initial dark]({{ page.media_dir }}ts-dark.png){: .dark style="max-width:100%;margin:auto;" .apply-border}
![timestamp initial light]({{ page.media_dir }}ts-light.png){: .light style="max-width:100%;margin:auto;" .apply-border}

At the first time running `dbt snapshot`, we can see a new table looks like the source with additional fields:

- `dbt_scd_id` is a dbt internal unique key.
- `dbt_updated_at` derives from original `updated_at` field and will be used internally by dbt.
- `dbt_valid_from` derives from `updated_at` as well and is implied that "this row has been valid since this time".
- `dbt_valid_to` is `null` implying that "this row's still valid then it's `null`".

{% endtab %}

{% tab dbt6-ts Run after source changed %}

![timestamp src changed dark]({{ page.media_dir }}ts-upd-dark.png){: .dark style="max-width:100%;margin:auto;" .apply-border}
![timestamp src changed light]({{ page.media_dir }}ts-upd-light.png){: .light style="max-width:100%;margin:auto;" .apply-border}

We can see that the last 3 rows having values in `dbt_valid_to`. This means those rows are no longer valid then look at the first 3 rows which:

- have same `id` whose salary are changed.
- have `dbt_valid_from` reflecting the value of `dbt_updated_at` and `updated_at`.
- have `dbt_valid_to` as `null` to state themselves as valid.

{% endtab %}

{% endtabs %}

### Execute strategy: check

Now try `check` strategy for snapshots.

{% tabs dbt6-chk  %}

{% tab dbt6-chk snapshots-salary.yml %}

{: file='snapshots/snapshots-salary.yml'}

```yml
snapshots:
  - name: snapshot-salary-check
    relation: source('salary', 'salary')
    config:
      target_schema: snapshots
      alias: salary_chk
      strategy: check
      unique_key: id
      check_cols: all
```

Implementing `check` strategy requires `unique_key` like `timestamp` strategy but with `check_cols` to be either `all` to check all columns or a list of columns in case we don't need to check every columns.

{% endtab %}

{% tab dbt6-chk Initial run %}

![check initial dark]({{ page.media_dir }}chk-dark.png){: .dark style="max-width:100%;margin:auto;" .apply-border}
![check initial light]({{ page.media_dir }}chk-light.png){: .light style="max-width:100%;margin:auto;" .apply-border}

At the first time running this snapshot, we can see additional fields similar to `timestamp` strategy except...

- `dbt_updated_at` is the execution time because dbt treats there is no updated timestamp when we use `check` strategy.
- `dbt_valid_from` also is the execution time.

{% endtab %}

{% tab dbt6-chk Run after source changed %}

![check src changed dark]({{ page.media_dir }}chk-upd-dark.png){: .dark style="max-width:100%;margin:auto;" .apply-border}
![check src changed light]({{ page.media_dir }}chk-upd-light.png){: .light style="max-width:100%;margin:auto;" .apply-border}

In the same behavior as `timestamp` strategy except `dbt_updated_at`, `dbt_valid_from` and `dbt_valid_to` are execution time.

{% endtab %}

{% endtabs %}

---

## Analyses

**Analyses**[^analyses] are ad-hoc query scripts, for instance we want to find data as of a specific date time or observe some insights. We don't want to make them the models because we just want to check something then we can create analyses.

Developing analyses is just creating a statement file inside `analyses`{: .filepath} directory like this.

{% raw %}

{: file='analyses/verify-data.sql'}

```sql
select * 
from {{ source("salary", "salary") }} s 
where s.salary >= 5000

```

{% endraw %}

And `dbt compile` to see what we get.

```
Compiled node 'verify-data' is:
select * 
from `bluebirz-playground`.`raw`.`salary` s 
where s.salary >= 5000
```

After that, we can copy-paste the compiled statement to run in databases.

In BigQuery we can execute `bq query` directly from the compiled file located in `target/compiled/`{: .filepath} as below.

```sh
$ bq query --use_legacy_sql=false \
  "$(cat target/compiled/<dbt_project>/analyses/verify-data.sql)"
+-----+---------+--------+---------------------+
| id  |  name   | salary |     updated_at      |
+-----+---------+--------+---------------------+
| 210 | Louis   |   5796 | 2025-01-03 05:05:31 |
| 214 | Kristen |   5850 | 2025-01-14 13:29:28 |
| 212 | Angela  |   5063 | 2025-01-18 16:50:52 |
| 209 | Tucker  |   5946 | 2025-01-25 23:04:29 |
| 205 | Hillary |   5959 | 2025-01-31 12:35:46 |
| 211 | Wallace |   6090 | 2025-02-01 09:00:00 |
+-----+---------+--------+---------------------+

```

---

## Wrap up

- Snapshots
  - use to track change history.
  - define snapshots in YAML files if dbt version is 1.9 or newer, otherwise write Jinja blocks.
  - recommend `timestamp` strategy for checking only `updated_at` field, or `check` strategy if no `updated_at` field in the table.
  - supply target table in `relation` and its `unique_key` to build snapshot on.
  - `dbt snapshot` to build snapshot tables.
- Analyses
  - use to run ad-hoc queries such as data observation or one-time analytics.
  - create SQL file in `analyses`{: .filepath} directory
  - `dbt compile` and find compiled statements in `target/compiled/<dbt_project>/analyses/` to run in databases.

---

## References

[^systimeasof]: [Access historical data  \|  BigQuery  \|  Google Cloud Documentation](https://docs.cloud.google.com/bigquery/docs/access-historical-data)
[^bqsnapshots]: [Introduction to table snapshots  \|  BigQuery  \|  Google Cloud Documentation](https://docs.cloud.google.com/bigquery/docs/table-snapshots-intro)
[^scd2]: [SCD type 2 \| Slowly Changing Dimensions]({% post_url 2025-10-15-slowly-changing-dimension %}#scd-type-2)
[^timetravel]: [Data retention with time travel and fail-safe  \|  BigQuery  \|  Google Cloud Documentation](https://docs.cloud.google.com/bigquery/docs/time-travel)
[^analyses]: [Analyses \| dbt Developer Hub](https://docs.getdbt.com/docs/build/analyses)
[^snapshotlegacy]: [Legacy snapshot configurations \| dbt Developer Hub](https://docs.getdbt.com/reference/resource-configs/snapshots-jinja-legacy)
[^dbtsnapshot]: [Snapshot properties \| dbt Developer Hub](https://docs.getdbt.com/reference/snapshot-properties)
