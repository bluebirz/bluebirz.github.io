---
title: "Let's try: dbt part 4 - model materialization"
layout: post
author: bluebirz
description: build data products with various transformation models to tackle business problems
date: 2025-11-01
categories: [data, data engineering]
tags: [let's try, Python, dbt, SQL, Jinja, materialization]
mermaid: true
comment: true
series:
  key: dbt
  index: 4
image:
  path: assets/img/features/external/dbt.png
  lqip: ../assets/img/features/lqip/external/dbt.webp
  alt: dbt-labs/dbt-core
  caption: <a href="https://github.com/dbt-labs/dbt-core">dbt-labs/dbt-core</a>
media_dir: https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-dbt/dbt4/
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

{% include bbz_custom/tabs.html %}

From the previous part, now we have data sources so we can build our data products with various transformation models to tackle business problems.

---

## dbt models

Models are data products to answer some real-world questions or give an insight to decision makers.

dbt provides model building tools in order to manage our data sets and data products. We need to understand when and how we establish which model to gain best performance and bring great experience to our data customers.

Right now we can build 5 materialization types[^materialization] in dbt:

1. View
1. Table
1. Incremental
1. Ephemeral
1. Materialized view

---

## Configure materialization

We can configure materialization in 3 solutions:

1. configure in `dbt_project.yml`{: .filepath}
1. configure in a macro in model SQL files
1. configure in model YAML files, such as `property.yml`

{% tabs dbt4-material %}

{% tab dbt4-material file tree %}

```
dbt_proj01
├── dbt_project.yml
└── models
    └─── climate
        ├── property.yml
        ├── sources.yml
        └── weekly-delhi-climate.sql
```

{% endtab %}

{% tab dbt4-material dbt_project.yml %}

```yml
models:
  dbt_proj01:
    # Config indicated by + and applies to all files under models/example/
    example:
      +materialized: <materialization type>
    climate:
      +materialized: <materialization type>
```

{% endtab %}

{% tab dbt4-material model SQL files %}

{% raw %}

```sql
{{-
  config(
    materialized='<materialization type>',
  )
-}}
SELECT
  ...
```

{% endraw %}

{% endtab %}

{% tab dbt4-material property.yml %}

```yml
version: 2

models:
  - name: <model name>
    config:
      materialized: <materialization type>
```

{% endtab %}

{% endtabs %}

Now we're gonna see how can we utilize and build a model in each type of materialization.

---

## Try building models

Let's say we have climate data of Delhi city from [Kaggle](https://www.kaggle.com/datasets/sumanthvrao/daily-climate-time-series-data/data) like this.

![source light]({{ page.media_dir}}src-light.png){: .light style="max-width:100%;margin:auto;" .apply-border}
![source dark]({{ page.media_dir}}src-dark.png){: .dark style="max-width:100%;margin:auto;" .apply-border}

And we have `source.yml`{: .filepath} as follows:

{: file='source.yml'}

```yml
version: 2

sources:
  - name: delhi_climate
    schema: raw
    tables:
      - name: daily_delhi_climate
        columns:
          - name: date
            description: Date of format YYYY-MM-DD
          - name: meantemp
            description: Mean temperature averaged out from multiple 3 hour intervals in a day.
          - name: humidity
            description: Humidity value for the day (units are grams of water vapor per cubic meter volume of air).
          - name: wind_speed
            description: Wind speed measured in kmph.
          - name: meanpressure
            description: Pressure reading of weather (measure in atm)
```

So we would like to **compute average value of those 4 metrics in weekly basis** starting from Sunday.

The calendar of that period is here.

{: file='calendar' icon='fa-solid fa-calendar-days'}

```
                            2016
      October               November              December        
Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  
                   1         1  2  3  4  5               1  2  3  
 2  3  4  5  6  7  8   6  7  8  9 10 11 12   4  5  6  7  8  9 10  
 9 10 11 12 13 14 15  13 14 15 16 17 18 19  11 12 13 14 15 16 17  
16 17 18 19 20 21 22  20 21 22 23 24 25 26  18 19 20 21 22 23 24  
23 24 25 26 27 28 29  27 28 29 30           25 26 27 28 29 30 31  
30 31
```

For example, a week can be Sunday 30 October - Saturday 5 November, the week after is from Sunday 6 November - Saturday 12 November and so on.

Come to make all 5 models together.

---

## Materialization: View

View is the default materialization of dbt models.

We consider a view when we want to control data with small transformation such as `select` some fields and make it lowercase and `union` with other tables. Managing authorization to allow or not allow users to query is a big one of the advantages of views.

We create a view by providing `materialized='view'` in `config()` or not providing it to let dbt create a view by default.

{% tabs dbt4-view %}

{% tab dbt4-view model %}

{% raw %}

```sql
{{- config(schema="transform", alias="weekly_climate_stats", materialized="view") -}}
select
    date_trunc(date, week(sunday)) as week_start_sunday,
    avg(meantemp) as avg_temp,
    avg(humidity) as avg_humidity,
    avg(wind_speed) as avg_wind_speed,
    avg(meanpressure) as avg_pressure
from {{ source("delhi_climate", "daily_delhi_climate") }}
group by all
```

- `{{ config(materialized='view') }}` to make this model a view.
- `date_trunc(date, week(sunday))` returns an earliest Sunday of that `date`.
- `{{ source() }}` to refer to the defined source in `source.yml`{: .filepath}.

{% endraw %}

{% endtab %}

{% tab dbt4-view result %}

![view light]({{ page.media_dir}}view-light.png){: .light style="max-width:100%;margin:auto;" .apply-border}
![view dark]({{ page.media_dir}}view-dark.png){: .dark style="max-width:100%;margin:auto;" .apply-border}

{% endtab %}

{% endtabs %}

---

## Materialization: Table

Another basic materialization, table.

We consider a table when we want to make a persist data model for the users or dashboards, especially when the model needs to refresh its data but take so big time that a view wouldn't the good solution for users to wait.

{% tabs dbt4-table %}

{% tab dbt4-table model %}

Just put `materialized='table'` and this model becomes a table.

{% raw %}

```sql
{{- config(schema="transform", alias="weekly_climate_stats", materialized="table") -}}
select
    date_trunc(date, week(sunday)) as week_start_sunday,
    avg(meantemp) as avg_temp,
    avg(humidity) as avg_humidity,
    avg(wind_speed) as avg_wind_speed,
    avg(meanpressure) as avg_pressure
from {{ source("delhi_climate", "daily_delhi_climate") }}
group by all
```

{% endraw %}

{% endtab %}

{% tab dbt4-table result %}

![table light]({{ page.media_dir}}table-light.png){: .light style="max-width:100%;margin:auto;" .apply-border}
![table dark]({{ page.media_dir}}table-dark.png){: .dark style="max-width:100%;margin:auto;" .apply-border}

{% endtab %}

{% endtabs %}

---

## Materialization: Incremental

When table is too big yet no point to refresh data every time, incremental model would be suited.

We consider incremental model if the table is big and we don't want to refresh the result every time. Waste of time, waste of money to do so. Incremental models allow us pick the new data (delta) from the source and transform then put to the target table. Yes it's SCD type 2 ([old blog: Slowly Changing Dimensions]({% post_url 2025-10-15-slowly-changing-dimension %})).

In order to utilize this incremental model, we need to understand incremental strategies[^strat] like `append` or `merge` where they're depend on adapters.

### Model

{% raw %}

```sql
{{-
    config(
        schema="transform",
        alias="weekly_climate_stats",
        materialized="incremental",
        incremental_strategy="merge",
        unique_key="week_start_sunday",
    )
-}}
select
    date_trunc(date, week(sunday)) as week_start_sunday,
    avg(meantemp) as avg_temp,
    avg(humidity) as avg_humidity,
    avg(wind_speed) as avg_wind_speed,
    avg(meanpressure) as avg_pressure,
    current_timestamp() as inserted_at
from {{ source("delhi_climate", "daily_delhi_climate") }}
{% if is_incremental() -%}
    where
        date_trunc(date, week(sunday)) > (select max(week_start_sunday) from {{ this }})
{%- endif %}
group by all
```

- `materialized="incremental"` to define this model to be incremental model.
- `incremental_strategy="merge"` to use merge operation.
- `unique_key=["<field1>", "<field2>", ...]` to assign unique fields for comparing value for the merge.
- `is_incremental()` returns `true` only if:
  - There is the model table existed.
  - This model is incremental.
  - Execute without the flag `--full-refresh`  
- When `is_incremental()` is `false`, the model will be materialized as a table instead.
- `{% if is_incremental() %}...{% endif %}` adds the query inside this block when `is_incremental()` is `true`.  
  The model above will have `where` clause active to pick new records.
- `where date_trunc(...) > (select max(week_start_sunday) from ...)` means new records would be picked when its earliest Sunday is newer than the latest (max) `week_start_sunday` of the current table.
- `{{ this }}` to refer to this model as a self-reference.

{% endraw %}

### First run

{% tabs dbt4-incremental-first-run %}

{% tab dbt4-incremental-first-run source %}

There is no table of this incremental model yet, `transform.weekly_climate_stats`. And the source has 30 records as of November 2016.

![source light]({{ page.media_dir}}src-light.png){: .light style="max-width:100%;margin:auto;" .apply-border}
![source dark]({{ page.media_dir}}src-dark.png){: .dark style="max-width:100%;margin:auto;" .apply-border}

{% endtab %}

{% tab dbt4-incremental-first-run result %}

We got the table `transform.weekly_climate_stats` having 5 records.

![first incremental light]({{ page.media_dir}}incre-light.png){: .light style="max-width:100%;margin:auto;" .apply-border}
![first incremental dark]({{ page.media_dir}}incre-dark.png){: .dark style="max-width:100%;margin:auto;" .apply-border}

{% endtab %}

{% tab dbt4-incremental-first-run final query %}

The model runs as new from the command `create or replace table ...`.

```sh
$ cat target/run/dbt_proj01/models/climate/weekly-delhi-climate.sql

    create or replace table `bluebirz-playground`.`transform`.`weekly_climate_stats`
      
    
    

    
    OPTIONS()
    as (
      select
    date_trunc(date, week(sunday)) as week_start_sunday,
    avg(meantemp) as avg_temp,
    avg(humidity) as avg_humidity,
    avg(wind_speed) as avg_wind_speed,
    avg(meanpressure) as avg_pressure,
    current_timestamp() as inserted_at
from `bluebirz-playground`.`raw`.`daily_delhi_climate`

group by all
    );
```

{% endtab %}

{% endtabs %}

### Next run

{% tabs dbt4-incremental-next-run %}

{% tab dbt4-incremental-next-run source %}

Now we have the incremental model and more than that, we also have additional 31 records in source table. It's the December 2016 data.

![source update light]({{ page.media_dir}}src-update-light.png){: .light style="max-width:100%;margin:auto;" .apply-border}
![source update dark]({{ page.media_dir}}src-update-dark.png){: .dark style="max-width:100%;margin:auto;" .apply-border}

{% endtab %}

{% tab dbt4-incremental-next-run result %}

We got more rows to be 9 in total. Those new rows whose `week_start_sunday` are as of December 2016 have different `inserted_at`.

![next incremental light]({{ page.media_dir}}incre-update-light.png){: .light style="max-width:100%;margin:auto;" .apply-border}
![next incremental dark]({{ page.media_dir}}incre-update-dark.png){: .dark style="max-width:100%;margin:auto;" .apply-border}

{% endtab %}

{% tab dbt4-incremental-next-run final query %}

This run, the model uses `merge` operation and has `where` clause to pick new records (line #12-13). When match it updates, and when not matched it inserts.

```sh
$ cat target/run/dbt_proj01/models/climate/weekly-delhi-climate.sql

    merge into `bluebirz-playground`.`transform`.`weekly_climate_stats` as DBT_INTERNAL_DEST
        using (select
    date_trunc(date, week(sunday)) as week_start_sunday,
    avg(meantemp) as avg_temp,
    avg(humidity) as avg_humidity,
    avg(wind_speed) as avg_wind_speed,
    avg(meanpressure) as avg_pressure,
    current_timestamp() as inserted_at
from `bluebirz-playground`.`raw`.`daily_delhi_climate`
where
        date_trunc(date, week(sunday)) > (select max(week_start_sunday) from `bluebirz-playground`.`transform`.`weekly_climate_stats`)
group by all
        ) as DBT_INTERNAL_SOURCE
        on ((DBT_INTERNAL_SOURCE.week_start_sunday = DBT_INTERNAL_DEST.week_start_sunday))

    
    when matched then update set
        `week_start_sunday` = DBT_INTERNAL_SOURCE.`week_start_sunday`,`avg_temp` = DBT_INTERNAL_SOURCE.`avg_temp`,`avg_humidity` = DBT_INTERNAL_SOURCE.`avg_
humidity`,`avg_wind_speed` = DBT_INTERNAL_SOURCE.`avg_wind_speed`,`avg_pressure` = DBT_INTERNAL_SOURCE.`avg_pressure`,`inserted_at` = DBT_INTERNAL_SOURCE.`i
nserted_at`
    

    when not matched then insert
        (`week_start_sunday`, `avg_temp`, `avg_humidity`, `avg_wind_speed`, `avg_pressure`, `inserted_at`)
    values
        (`week_start_sunday`, `avg_temp`, `avg_humidity`, `avg_wind_speed`, `avg_pressure`, `inserted_at`)

```

{% endtab %}

{% endtabs %}

### Full refresh

In case we want to run the model entirely new, we can execute `dbt run --full-refresh`.

{% tabs dbt4-incremental-full-refresh %}

{% tab dbt4-incremental-full-refresh source %}

We are using the updated source which have data as of both November and December 2016.

![source update light]({{ page.media_dir}}src-update-light.png){: .light style="max-width:100%;margin:auto;" .apply-border}
![source update dark]({{ page.media_dir}}src-update-dark.png){: .dark style="max-width:100%;margin:auto;" .apply-border}

{% endtab %}

{% tab dbt4-incremental-full-refresh result %}

After `dbt run --full-refresh`, we have a new table looks like the last run but this one has same `inserted_at` because we refreshed it.

![full refresh light]({{ page.media_dir}}incre-refresh-light.png){: .light style="max-width:100%;margin:auto;" .apply-border}
![full refresh dark]({{ page.media_dir}}incre-refresh-dark.png){: .dark style="max-width:100%;margin:auto;" .apply-border}

{% endtab %}

{% tab dbt4-incremental-full-refresh final result %}

```sh
$ cat target/run/dbt_proj01/models/climate/weekly-delhi-climate.sql

    create or replace table `bluebirz-playground`.`transform`.`weekly_climate_stats`
      
    
    

    
    OPTIONS()
    as (
      select
    date_trunc(date, week(sunday)) as week_start_sunday,
    avg(meantemp) as avg_temp,
    avg(humidity) as avg_humidity,
    avg(wind_speed) as avg_wind_speed,
    avg(meanpressure) as avg_pressure,
    current_timestamp() as inserted_at
from `bluebirz-playground`.`raw`.`daily_delhi_climate`

group by all
    );
```

{% endtab %}

{% endtabs %}

---

## Materialization: Ephemeral

When we want a virtual model to do some tasks and also is reuseable.

We consider ephemeral models to act as reuseable functions. dbt will build this type of model to be CTE (Common Table Expression) so we can't see the final product of this but also call this type with `ref()`.

{% tabs dbt4-ephemeral %}

{% tab dbt4-ephemeral ephemeral model %}

Adding `materialized='ephemeral'` and the model is ready.

{% raw %}

{: file='weekly_climate_compute_cte.sql'}

```sql
{{-
    config(
        materialized="ephemeral",
    )
-}}
select
    date_trunc(date, week(sunday)) as week_start_sunday,
    avg(meantemp) as avg_temp,
    avg(humidity) as avg_humidity,
    avg(wind_speed) as avg_wind_speed,
    avg(meanpressure) as avg_pressure,
from {{ source("delhi_climate", "daily_delhi_climate") }}
group by all
```

{% endraw %}

{% endtab %}

{% tab dbt4-ephemeral caller model %}

Use the ephemeral model with `ref('<ephemeral_filename>')`

{% raw %}

{: file='weekly-delhi-stats.sql'}

```sql
{{-
    config(
        schema="transform",
        alias="weekly_climate_stats",
        materialized="table",
    )
-}}
select *
from {{ ref("weekly_climate_compute_cte") }}
```

{% endraw %}

{% endtab %}

{% tab dbt4-ephemeral compiled result %}

The ephemeral model becomes a CTE with prefix `__dbt__cte__`.

```sh
$ cat target/compiled/dbt_proj01/models/climate/weekly-delhi-stats.sql

with __dbt__cte__weekly_climate_compute_cte as (
select
    date_trunc(date, week(sunday)) as week_start_sunday,
    avg(meantemp) as avg_temp,
    avg(humidity) as avg_humidity,
    avg(wind_speed) as avg_wind_speed,
    avg(meanpressure) as avg_pressure,
from `bluebirz-playground`.`raw`.`daily_delhi_climate`
group by all
) select *
from __dbt__cte__weekly_climate_compute_cte
```

{% endtab %}

{% endtabs %}

---

## Materialization: Materialized View

Materialized view is an advance view that it computes and stores the query results beforehand. However the materialized views do support limited SQL features such as `AVG`, `SUM`, `COUNT`, etc. but not with window functions, user-defined functions and others.

We consider materialized views when we want precomputed data but also in views, having some aggregations, joins and filters so there are flexibility to update the query without storing in physical tables.

According to BigQuery, materialized views can be configurable[^matviewconfig] by:

- `enable_refresh` to allow BigQuery refresh this materialized view automatically when the source tables change.
  - within 30 minutes maximum after the source tables changed by default[^autorefresh].
  - every 30 minutes minimum to refresh by default[^freqcap].
- `refresh_interval_minutes` is the time period in minutes this materialized view will be refreshed from source tables.
- `max_staleness`[^maxstale][^maxstaleforum] is the time period this materialized view will query source tables if the last refresh was outside this period, otherwise this view will use cached data.

![matview diagram light]({{ page.media_dir}}dbt-materialized_view_light.drawio.png){: .light style="max-width:100%;margin:auto;" .apply-border}
![matview diagram dark]({{ page.media_dir}}dbt-materialized_view_dark.drawio.png){: .dark style="max-width:100%;margin:auto;" .apply-border}

{% tabs dbt4-matview %}

{% tab dbt4-matview model %}

We define materialized view with `materialized='materialized_view'` and other configurations as above.

{% raw %}

```sql
{{-
    config(
        schema="transform",
        alias="weekly_climate_stats",
        materialized="materialized_view",
        on_configuration_change="apply",
        enable_refresh=True,
        refresh_interval_minutes=180,
        max_staleness="INTERVAL '4:0:0' HOUR TO SECOND",
    )
-}}
select
    date_trunc(date, week(sunday)) as week_start_sunday,
    avg(meantemp) as avg_temp,
    avg(humidity) as avg_humidity,
    avg(wind_speed) as avg_wind_speed,
    avg(meanpressure) as avg_pressure,
from {{ source("delhi_climate", "daily_delhi_climate") }}
group by all
```

{% endraw %}

{% endtab %}

{% tab dbt4-matview result %}

After `dbt run`, we should see the new materialized view.

![materialized view light]({{ page.media_dir}}matview-light.png){: .light style="max-width:100%;margin:auto;" .apply-border}
![materialized view dark]({{ page.media_dir}}matview-dark.png){: .dark style="max-width:100%;margin:auto;" .apply-border}

{% endtab %}

{% endtabs %}

> **Tips**
>
> 1. consider partitioned tables as source tables to reduce refresh cost and time.
> 1. set `refresh_interval_minutes` to be aligned with the updates on source tables.  
  For example, if the source tables have new data every 2 hours, we can set `refresh_interval_minutes` as 180 minutes from 2 hours + extra 1 hour as buffer = 3 × 60 = 180 minutes.
> 1. set `max_staleness` based on our usages.  
  For example, if we have dashboards running between 9 AM - 10 AM in the morning and we have set the materialized views to be refreshed at 7 AM, we can set `max_staleness` as 4 hours to ensure the dashboards will use the cache.
{: .prompt-tip}

---

## Wrap up

{% raw%}

- Configure materialization types in:
  - `dbt_project.yml`{: .filepath}
  - model files using `{{ config(materialized='<materialized type>') }}`
  - model YAML files.
- view:
  - `{{ config(materialized='view') }}` to make a view.
- table:
  - `{{ config(materialized='table') }}` to make a table in full load.
- incremental:
  - `{{ config(materialized='incremental) }}` to make an incremental model.
  - `{{ config(incremental_strategy='<strategy>') }}` to define how to handle incremental data.
  - `{{ config(unique_key=["<field1>", "<field2>", ...]) }}` to assign unique fields for incremental data.
  - `is_incremental()` to manage extra logic for selecting incremental data and it returns `true` when running this incremental model on an existing table without the flag `--full-refresh`.
  - `dbt run --full-refresh` to run all incremental models entirely new.
  - `{{ this }}` refer to the model itself.
- ephemeral:
  - `{{ config(materialized='ephemeral') }}` to create an ephemeral model.
  - refer to an ephemeral model by `{{ ref('<ephemeral_filename>') }}`.
- materialized view:
  - `{{ config(materialized='materialized_view') }}` to make a materialized view.
  - `{{ config(enable_refresh=True) }}` to enable auto refresh.
  - `{{ config(refresh_interval_minutes=<number>) }}` to set time interval for auto refresh.
  - `{{ config(max_staleness="<interval time>"` to set max staleness time.

{% endraw %}

---

## References

[^materialization]: [Materializations \| dbt Developer Hub](https://docs.getdbt.com/docs/build/materializations)
[^strat]: [About incremental strategy \| dbt Developer Hub](https://docs.getdbt.com/docs/build/incremental-strategy)
[^autorefresh]: [Automatic refresh \| Manage materialized views  \|  BigQuery  \|  Google Cloud](https://cloud.google.com/bigquery/docs/materialized-views-manage#automatic-refresh)
[^freqcap]: [Set the frequency cap \| Manage materialized views  \|  BigQuery  \|  Google Cloud](https://cloud.google.com/bigquery/docs/materialized-views-manage#frequency_cap)

[^maxstale]: [Use materialized views with max_staleness option \| Create materialized views  \|  BigQuery  \|  Google Cloud](https://cloud.google.com/bigquery/docs/materialized-views-create#max_staleness)
[^maxstaleforum]: [Max_Staleness parameters - Google Cloud / Database - Google Developer forums](https://discuss.google.dev/t/max-staleness-parameters/140711/4)
[^matviewconfig]: [Optimizing Materialized Views with dbt \| dbt Developer Blog](https://docs.getdbt.com/blog/announcing-materialized-views)
