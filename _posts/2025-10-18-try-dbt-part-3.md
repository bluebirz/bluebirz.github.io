---
title: "Let's try: dbt part 3 - seed and source"
layout: post
author: bluebirz
description: Before we transform data, we must have a data source first.
date: 2025-10-18
categories: [data, data engineering]
tags: [let's try, Python, dbt, SQL, Jinja]
mermaid: true
comment: true
series:
  key: dbt
  index: 3
image:
  path: assets/img/features/external/dbt.png
  lqip: ../assets/img/features/lqip/external/dbt.webp
  alt: dbt-labs/dbt-core
  caption: <a href="https://github.com/dbt-labs/dbt-core">dbt-labs/dbt-core</a>
media_dir: https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-dbt/
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

{% include bbz_custom/tabs.html %}

Before we transform data, we must have a data source first.

dbt allows to configure **sources** in YAML files. It also features data loading that called **seeds**

---

## Seeds

**Seeds** are the CSV files that we want to load to the tables to the data warehouses. Even though dbt is not a good tool for data integration comparing to those specific tools like Apache Airflow, but we can sometimes load it with this capability.

The best use case of it would be that we want to load some small static data sets for lookup, comparison, testing, or likewise before the transformation in next steps.

### Prepare seeds

Let's say I have `person.csv`{: .filepath} and want to load it up there. We have to prepare a configuration file[^seed-config] like this.

{% tabs dbt3-seed %}

{% tab dbt3-seed file tree %}

We should place the target files in `seeds/`{: .filepath} directory. Then create a YAML file for seed configuration. The filename of the configuration can be anything but we may consider naming convention for better organization. Here I put `seed.yml`{: .filepath}.

```
dbt_proj01/seeds
├── person.csv
└── seed.yml
```

{% endtab %}

{% tab dbt3-seed person.csv %}

I prepared small data set as below.

{: file='person.csv' icon='fas fa-file-csv'}

```
id,first_name,last_name,gender,occupation
1,Kenneth,Farrell,M,Product manager
2,Kimberly,Hood,F,Social worker
4,Robert,Haley,M,"Designer, jewellery"
5,Christine,Valentine,F,Barrister
7,Elizabeth,Espinoza,F,Solicitor
```

{% endtab %}

{% tab dbt3-seed seed.yml %}

Now we can configure seed to be loaded as below.

- I `enabled` this seed.
- I want to load it to `raw` schema (that is dataset in BigQuery).
- I want to rename the table to `person_occupation`.
- This file contains quotes.
- This file has the following columns.

{: file='seed.yml'}

```yaml
version: 2

seeds:
  - name: person
    config:
      enabled: true
      schema: raw
      alias: person_occupation
      quote_columns: true
      column_types:
        id: int64
        first_name: string
        last_name: string
        gender: string
        occupation: string
```

{% endtab %}

{% endtabs %}

### Run load seeds

Use this command:

```sh
dbt seed
```

We should see the log if seeds are loaded successfully.

```
20:47:41  Running with dbt=1.10.13
20:47:42  Registered adapter: bigquery=1.10.2
20:47:43  Unable to do partial parsing because change detected to override macro. Starting full parse.
20:47:43  Found 2 models, 1 seed, 4 data tests, 509 macros
20:47:43  
20:47:43  Concurrency: 1 threads (target='dev')
20:47:43  
20:47:48  1 of 1 START seed file dbt_test_dataset_raw.person_occupation .................. [RUN]
20:47:53  1 of 1 OK loaded seed file dbt_test_dataset_raw.person_occupation .............. [INSERT 5 in 5.19s]
20:47:53  
20:47:53  Finished running 1 seed in 0 hours 0 minutes and 9.94 seconds (9.94s).
20:47:53  
20:47:53  Completed successfully
20:47:53  
20:47:53  Done. PASS=1 WARN=0 ERROR=0 SKIP=0 NO-OP=0 TOTAL=1
```

And check for seed tables.

![seed dark]({{ page.media_dir }}dbt3-seed-dark.png){: .dark style="max-width:100%;margin:auto;" .apply-border}
![seed light]({{ page.media_dir }}dbt3-seed-light.png){: .light style="max-width:100%;margin:auto;" .apply-border}

> Aww! we want the schema (dataset) to be `raw` but it is `dbt_test_dataset_raw` instead.  
> We need to "override" this.
{: .prompt-warning}

### Override schema name

According to the dbt docs[^override-macro], if we supply value for `schema`, the value will **not replace but append** to the default schema name in `profile.yml`{: .filepath}.

What we have to do is to create a macro to override this behaviour.

{% tabs dbt3-override-schema %}

{% tab dbt3-override-schema file tree %}

We create a new file named `generate_schema_name.sql`{: .filepath} to self-describe this action in `macros/`{: .filepath} directory.

```
dbt_proj01/macros
└── generate_schema_name.sql
```

{% endtab %}

{% tab dbt3-override-schema macro %}

Write the content as below. This Jinja means that:

- if we don't input `schema`, it will use the default schema.
- if we input `schema`, use the input with no changes.

{% raw %}

{: file='generate_schema_name.sql'}

```sql
{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}

        {{ default_schema }}

    {%- else -%}

        {{ custom_schema_name | trim }}

    {%- endif -%}

{%- endmacro %}
```

{% endraw %}

{% endtab %}

{% endtabs %}

Run `dbt seed` again.

```sh
$ dbt seed

20:52:19  Running with dbt=1.10.13
20:52:21  Registered adapter: bigquery=1.10.2
20:52:21  Unable to do partial parsing because change detected to override macro. Starting full parse.
20:52:21  Found 2 models, 1 seed, 4 data tests, 509 macros
20:52:21  
20:52:21  Concurrency: 1 threads (target='dev')
20:52:21  
20:52:26  1 of 1 START seed file raw.person_occupation ................................... [RUN]
20:52:33  1 of 1 OK loaded seed file raw.person_occupation ............................... [INSERT 5 in 6.71s]
20:52:33  
20:52:33  Finished running 1 seed in 0 hours 0 minutes and 11.17 seconds (11.17s).
20:52:33  
20:52:33  Completed successfully
20:52:33  
20:52:33  Done. PASS=1 WARN=0 ERROR=0 SKIP=0 NO-OP=0 TOTAL=1
```

Come to check and now we have the dataset `raw` as expected.

![schema override dark]({{ page.media_dir }}dbt3-schema-override-dark.png){: .dark style="max-width:60%;margin:auto;" .apply-border}
![schema override light]({{ page.media_dir }}dbt3-schema-override-light.png){: .light style="max-width:60%;margin:auto;" .apply-border}

### Use seeds in models

We have loaded our seeds so it's time to use them in our models.

Let's say I want a model to find all female persons, we can write this.

{: file='woman_jobs.sql'}

{% raw %}

```sql
SELECT *
FROM {{ ref('person') }}
WHERE gender = 'F'
```

{% endraw %}

We use {% raw %}`{{ ref('seed_name') }}`{% endraw %} to refer to the seed tables.

### Compile models

Let's see the compiled result:

```sh
$ dbt compile

15:21:22  Running with dbt=1.10.13
15:21:23  Registered adapter: bigquery=1.10.2
15:21:24  Found 1 seed, 3 models, 4 data tests, 509 macros
15:21:24  
15:21:24  Concurrency: 1 threads (target='dev')
15:21:24  
Compiled node 'woman_jobs' is:
SELECT *
FROM `bluebirz-playground`.`raw`.`person_occupation`
WHERE gender = 'F'
```

As above, dbt substitutes the correct table of the seed into our model (line #11).

---

## Sources

**Sources** are the real tables/views in the data warehouses that we want to run queries on. As they are already existed, dbt just needs configurations to tell where they are right now.

Let's say I already have this table `books` in the dataset `raw` in BigQuery.

![book dark]({{ page.media_dir }}dbt3-books-dark.png){: .dark style="max-width:100%;margin:auto;" .apply-border}
![book light]({{ page.media_dir }}dbt3-books-light.png){: .light style="max-width:100%;margin:auto;" .apply-border}

And the schema of table `books` is as below.

```json
[
  {"name": "id", "type": "STRING", "mode": "NULLABLE"}, 
  {"name": "isbn", "type": "STRING", "mode": "NULLABLE"}, 
  {"name": "title", "type": "STRING", "mode": "NULLABLE"}, 
  {"name": "author", "type": "STRING", "mode": "NULLABLE"}, 
  {"name": "published_year", "type": "INTEGER", "mode": "NULLABLE"}
]
```

After that, we want a new table from `books` to be a series of number of books by decades where those books were published before year 2000.

### Prepare sources and models

We have to create configuration files[^source-config] and query files as below.

{% tabs dbt3-source %}

{% tab dbt3-source file tree %}

We would create a configuration file and a query file in `books/`{: .filepath} directory.

```
models/books
├── old-books-by-decade.sql
└── source-books.yml
```

{% endtab %}

{% tab dbt3-source configs %}

Here is the configuration file for source. I name this source `raw_data` linking to the schema (dataset) `raw` and specify the table `books`.

{: file='source-books.yml'}

```yaml
version: 2

sources:
  - name: raw_data
    schema: raw
    tables:
      - name: books
        description: all books in my library
```

{% endtab %}

{% tab dbt3-source model %}

This query will compute the decade of each book which was published before 2000 and count them from source `raw_data.books`.

{: file='old-books-by-decade.sql'}

{% raw %}

```sql
{{-
  config(
    materialized='table',
    schema='transform'
  )
-}}

SELECT
    SAFE_CAST(FLOOR(published_year / 10) * 10 AS INT64) AS decade,
    COUNT(*) AS book_count
FROM {{ source('raw_data', 'books') }}
WHERE published_year < 2000
GROUP BY decade
```

{% endraw %}

- This model will be materialized as a table where configured in {% raw %}`{{ config() }}`{% endraw %} block.
- I put `schema='transform'` here so this table will be created in the schema `transform`.
- Add `-` in Jinja block to remove leading/trailing spaces as {% raw %}`{{- ... -}}`{% endraw %}.

{% endtab %}

{% endtabs %}

### Compile models

So let's see the final query statement by `dbt compile`.

```sh
$ dbt compile 

18:18:43  Running with dbt=1.10.13
18:18:45  Registered adapter: bigquery=1.10.2
18:18:45  Found 3 models, 2 seeds, 4 data tests, 1 source, 509 macros
18:18:45  
18:18:45  Concurrency: 1 threads (target='dev')
18:18:45  
Compiled node 'old-books-by-decade' is:
SELECT
    SAFE_CAST(FLOOR(published_year / 10) * 10 AS INT64) AS decade,
    COUNT(*) AS book_count
FROM `bluebirz-playground`.`raw`.`books`
WHERE published_year < 2000
GROUP BY decade
```

Yes! The query looks correct.

### Run models

Now we can run it.

```sh
$ dbt run

18:18:50  Running with dbt=1.10.13
18:18:51  Registered adapter: bigquery=1.10.2
18:18:52  Found 3 models, 2 seeds, 4 data tests, 1 source, 509 macros
18:18:52  
18:18:52  Concurrency: 1 threads (target='dev')
18:18:52  
18:18:53  1 of 1 START sql table model transform.old-books-by-decade ..................... [RUN]
18:18:57  1 of 1 OK created sql table model transform.old-books-by-decade ................ [CREATE TABLE (10.0 rows, 3.9 KiB processed) in 3.93s]
18:18:57  
18:18:57  Finished running 1 table model in 0 hours 0 minutes and 4.48 seconds (4.48s).
18:18:57  
18:18:57  Completed successfully
18:18:57  
18:18:57  Done. PASS=1 WARN=0 ERROR=0 SKIP=0 NO-OP=0 TOTAL=1
```

See the result table in BigQuery.

![source dark]({{ page.media_dir }}dbt3-source-table-dark.png){: .dark style="max-width:100%;margin:auto;" .apply-border}
![source light]({{ page.media_dir }}dbt3-source-table-light.png){: .light style="max-width:100%;margin:auto;" .apply-border}

This model runs successfully.

---

## Wrap up

- seeds:
  - put CSV files in `seeds/`{: .filepath} directory.
  - define YAML configurations in syntax like this:

      ```yaml
      version: 2

      seeds:
        - name: <seed_name>
          config:
            enabled: <true|false>
            schema: <schema>
            alias: <alias>
            quote_columns: <true|false>
            column_types:
              <column_name>: <data_type>
      ```

  - execute `dbt seed` to load seeds.
  - refer seeds in models by {% raw %}`{{ ref('<seed_name>') }}`{% endraw %}.
- override schema name by creating `macro/generate_schema_name.sql`{: .filepath} with Jinja as above.
- sources:
  - define YAML configurations in syntax like this:

      ```yaml
      version: 2

      sources:
        - name: <source_name>
          schema: <schema>
          tables:
            - name: <table_name>
              description: <description>
      ```

  - use {% raw %}`{{ source('<source_name>', '<table_name>') }}`{% endraw %} to refer to the source table in the model.
  - create a table instead of a view by default with {% raw %}`{{ config(materialized='table') }}`{% endraw %} in the model.
  - create a table in a specific schema (dataset) with {% raw %}`{{ config(schema='<schema_name>') }}`{% endraw %} in the model.
- compile all models with `dbt compile`.
- run all models with `dbt run`.

---

## Reference

[^seed-config]: [Seed configurations \| dbt Developer Hub](https://docs.getdbt.com/reference/seed-configs)
[^override-macro]: [How does dbt generate a model's schema name?](https://docs.getdbt.com/docs/build/custom-schemas#how-does-dbt-generate-a-models-schema-name)
[^source-config]: [Source configurations \| dbt Developer Hub](https://docs.getdbt.com/reference/source-configs)
