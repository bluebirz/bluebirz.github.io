---
title: "Let's try: dbt part 2 - first start"
layout: post
author: bluebirz
description:
# date:
categories: []
tags: []
pin: true
math: true 
mermaid: true
comment: true
# series:
#   key: asd
#   index: 1
image:
  path: assets/img/features/external/dbt.png
  lqip: ../assets/img/features/lqip/external/dbt.webp
  alt: dbt-labs/dbt-core
  caption: <a href="https://github.com/dbt-labs/dbt-core">dbt-labs/dbt-core</a>
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

{% include bbz_custom/tabs.html %}

---

## install

```sh
uv add dbt-core dbt-bigquery
```

`dbt` commands are available now.

---

## init

```sh
$ dbt init [--profile <profile_name if existing profile.yml>]

19:33:36  Running with dbt=1.10.13
Enter a name for your project (letters, digits, underscore): dbt_proj01
19:33:42  
Your new dbt project "dbt_proj01" was created!

For more information on how to configure the profiles.yml file,
please consult the dbt documentation here:

  <https://docs.getdbt.com/docs/configure-your-profile>

One more thing:

Need help? Don't hesitate to reach out to us via GitHub issues or on Slack:

  <https://community.getdbt.com/>

Happy modeling!

19:33:42  Setting up your profile.
Which database would you like to use?
[1] bigquery

(Don't see the one you want? <https://docs.getdbt.com/docs/available-adapters>)

Enter a number: 1
[1] oauth
[2] service_account
Desired authentication method option (enter a number): 1
project (GCP project id): <project>
dataset (the name of your dbt dataset): <dataset>
threads (1 or more): 1
job_execution_timeout_seconds [300]:
[1] US
[2] EU
Desired location option (enter a number): 2
19:34:45  Profile dbt_proj01 written to ~/.dbt/profiles.yml using target's profile_template.yml and your supplied values. Run 'dbt debug' to validate the connection.
```

```
.
├── dbt_proj01
│   ├── README.md
│   ├── analyses
│   ├── dbt_project.yml
│   ├── macros
│   ├── models
│   │   └── example
│   │       ├── my_first_dbt_model.sql
│   │       ├── my_second_dbt_model.sql
│   │       └── schema.yml
│   ├── seeds
│   ├── snapshots
│   └── tests
└── logs
    └── dbt.log

```

---

## debug

```sh
$ cd dbt_proj01
$ dbt debug

19:45:27  Running with dbt=1.10.13
19:45:27  dbt version: 1.10.13
19:45:27  python version: 3.11.13
19:45:27  python path: ...
19:45:27  os info: ...
19:45:28  Using profiles dir at ...
19:45:28  Using profiles.yml file at ...
19:45:28  Using dbt_project.yml file at .../dbt_project.yml
19:45:28  adapter type: bigquery
19:45:28  adapter version: 1.10.2
19:45:28  Configuration:
19:45:28    profiles.yml file [OK found and valid]
19:45:28    dbt_project.yml file [OK found and valid]
19:45:28  Required dependencies:
19:45:28   - git [OK found]

19:45:28  Connection:
19:45:28    method: oauth

...

19:45:31    Connection test: [OK connection ok]

19:45:31  All checks passed!
```

---

## models

{% tabs dbt %}

{% tab dbt file tree %}

```
.
└── dbt_proj01
    └── models
        └── example
            ├── my_first_dbt_model.sql
            ├── my_second_dbt_model.sql
            └── schema.yml
```

{% endtab %}

{% tab dbt my_first_dbt_model.sql %}

{: file='models/example/my_first_dbt_model.sql'}

{% raw %}

```sql

/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

{{ config(materialized='table') }}

with source_data as (

    select 1 as id
    union all
    select null as id

)

select *
from source_data

/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null

```

{% endraw %}

{% endtab %}

{% tab dbt my_second_dbt_model.sql %}

{: file='models/example/my_second_dbt_model.sql'}

{% raw %}

```sql

-- Use the `ref` function to select from other models

select *
from {{ ref('my_first_dbt_model') }}
where id = 1
```

{% endraw %}

{% endtab %}

{% tab dbt schema.yml %}

{: file='models/example/schema.yml'}

```yaml

version: 2

models:
  - name: my_first_dbt_model
    description: "A starter dbt model"
    columns:
      - name: id
        description: "The primary key for this table"
        data_tests:
          - unique
          - not_null

  - name: my_second_dbt_model
    description: "A starter dbt model"
    columns:
      - name: id
        description: "The primary key for this table"
        data_tests:
          - unique
          - not_null
```

{% endtab %}

{% endtabs %}

## run

```sh
$ dbt run

20:07:24  Running with dbt=1.10.13
20:07:26  Registered adapter: bigquery=1.10.2
20:07:26  Unable to do partial parsing because saved manifest not found. Starting full parse.
20:07:26  Found 2 models, 4 data tests, 508 macros
20:07:26  
20:07:26  Concurrency: 1 threads (target='dev')
20:07:26  
20:07:31  1 of 2 START sql table model dbt_test_dataset.my_first_dbt_model ............... [RUN]
20:07:35  1 of 2 OK created sql table model dbt_test_dataset.my_first_dbt_model .......... [CREATE TABLE (2.0 rows, 0 processed) in 3.61s]
20:07:35  2 of 2 START sql view model dbt_test_dataset.my_second_dbt_model ............... [RUN]
20:07:36  2 of 2 OK created sql view model dbt_test_dataset.my_second_dbt_model .......... [CREATE VIEW (0 processed) in 1.61s]
20:07:36  
20:07:36  Finished running 1 table model, 1 view model in 0 hours 0 minutes and 9.99 seconds (9.99s).
20:07:36  
20:07:36  Completed successfully
20:07:36  
20:07:36  Done. PASS=2 WARN=0 ERROR=0 SKIP=0 NO-OP=0 TOTAL=2
```

![tables created dark](../assets/img/tmp/dbt/dbt2-run-result-dark.png){: .dark .apply-border style="max-width:60%;margin:auto;"}
![tables created light](../assets/img/tmp/dbt/dbt2-run-result-light.png){: .light .apply-border style="max-width:60%;margin:auto;"}

---

## Wrap up

```sh

uv add dbt-core dbt-<adapter>
pip install dbt-core dbt-<adapter>

dbt init
dbt debug
dbt run
```

---

## References

- <https://docs.getdbt.com/reference/commands/init>
