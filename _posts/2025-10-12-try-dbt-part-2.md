---
title: "Let's try: dbt part 2 - first start"
layout: post
author: bluebirz
description: Now let's roll up our sleeves and start dbt together.
date: 2025-10-12
categories: [data, data engineering]
tags: [let's try, Python, dbt, SQL, Jinja, Google BigQuery]
mermaid: true
comment: true
series:
  key: dbt
  index: 2
image:
  path: assets/img/features/external/dbt.png
  lqip: ../assets/img/features/lqip/external/dbt.webp
  alt: dbt-labs/dbt-core
  caption: <a href="https://github.com/dbt-labs/dbt-core">dbt-labs/dbt-core</a>
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

{% include bbz_custom/tabs.html %}

Now let's roll up our sleeves and start dbt together.

---

## Install

First of all, we have to install dbt. dbt must be installed in Python environment so here we can do that via `uv` or `pip`.

The libraries we're gonna install now are `dbt-core` and `dbt-<adapter>` where `<adapter>` is the data warehouse we're going to use. Adapter I use right here is `dbt-bigquery`.

Find out more details about adapters below:

{% include bbz_custom/link_preview.html url='<https://docs.getdbt.com/docs/available-adapters>' %}

Okay, let's install them.

{% tabs dbt2-install %}

{% tab dbt2-install uv %}

```sh
# syntax
uv add dbt-core dbt-<adapter>

# example
uv add dbt-core dbt-bigquery
```

For `uv`, feel free to visit my old blog below:

{% include bbz_custom/link_preview.html post='2025-03-25-try-uv-python.md' %}

{% endtab %}

{% tab dbt2-install pip %}

```sh
# syntax
pip install dbt-core dbt-<adapter>

# example
pip install dbt-core dbt-bigquery
```

{% endtab %}

{% endtabs %}

And `dbt` commands are available now. Check the versions if the installation is completed like this:

```sh
$ dbt --version

Core:
  - installed: 1.10.13
  - latest:    1.10.13 - Up to date!

Plugins:
  - bigquery: 1.10.2 - Up to date!
```

---

## Init

Next step is to initialize the project with this command.

```sh
dbt init 
```

There are prompts to configure our dbt project. This is regarding BigQuery and may differ if we use other adapters.

```
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

> As seen at the last line, `profile.yml`{: .filepath} is in `~/.dbt/`{: .filepath} directory by default.  
> We can copy it into project directory for better file organizing.
{: .prompt-tip}

According the my prompt, I named my project `dbt_proj01` to use `bigquery` as the adapter. So `dbt_proj1`{: .filepath} is now my dbt directory name.

And we should see the file structure have being generated like this.

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
│   ├── profiles.yml  # optional, copied from `~/.dbt/profiles.yml`
│   ├── seeds
│   ├── snapshots
│   └── tests
└── logs
    └── dbt.log

```

Here are the contents by default of `dbt_project.yml`{: .filepath} and `profiles.yml`{: .filepath}.

{% tabs dbt2-yamlconf %}

{% tab dbt2-yamlconf dbt_project.yml %}

{% raw %}

```yaml

# Name your project! Project names should contain only lowercase characters
# and underscores. A good package name should reflect your organization's
# name or the intended use of these models
name: 'dbt_proj01'
version: '1.0.0'

# This setting configures which "profile" dbt uses for this project.
profile: 'dbt_proj01'

# These configurations specify where dbt should look for different types of files.
# The `model-paths` config, for example, states that models in this project can be
# found in the "models/" directory. You probably won't need to change these!
model-paths: ["models"]
analysis-paths: ["analyses"]
test-paths: ["tests"]
seed-paths: ["seeds"]
macro-paths: ["macros"]
snapshot-paths: ["snapshots"]

clean-targets:         # directories to be removed by `dbt clean`
  - "target"
  - "dbt_packages"


# Configuring models
# Full documentation: https://docs.getdbt.com/docs/configuring-models

# In this example config, we tell dbt to build all models in the example/
# directory as views. These settings can be overridden in the individual model
# files using the `{{ config(...) }}` macro.
models:
  dbt_proj01:
    # Config indicated by + and applies to all files under models/example/
    example:
      +materialized: view
```

{% endraw %}

{% endtab %}

{% tab dbt2-yamlconf profiles.yml %}

```yaml
dbt_proj01:
  outputs:
    dev:
      dataset: <dataset>
      job_execution_timeout_seconds: 300
      job_retries: 1
      location: EU
      method: oauth
      priority: interactive
      project: <project>
      threads: 1
      type: bigquery
  target: dev
```

{% endtab %}

{% endtabs %}

---

## Debug

After initializing, we should (and always) verify if the configuration and connection are correct.

```sh
# go into the project 
cd dbt_proj01

dbt debug
```

And we should see `All checks passed` at the end.

```
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

## Models

Initialization checked.

Debug checked.

Now we come see what our models are, by default.

{% tabs dbt2-model %}

{% tab dbt2-model file tree %}

All models are in `models/`{: .filepath} directory.

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

{% tab dbt2-model my_first_dbt_model.sql %}

`my_first_dbt_model.sql`{: .filepath} is materialized as a table having one column `id` and 2 records.

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

{% tab dbt2-model my_second_dbt_model.sql %}

`my_second_dbt_model.sql`{: .filepath} is materialized as a view querying `my_first_dbt_model` where `id` is 1.

{% raw %}

```sql

-- Use the `ref` function to select from other models

select *
from {{ ref('my_first_dbt_model') }}
where id = 1
```

{% endraw %}

{% endtab %}

{% tab dbt2-model schema.yml %}

And `schema.yml`{: .filepath} is a definition of our models. We can specify descriptions, column definition and data tests here.

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

---

## Compile

Models are written in SQL and Jinja. We can compile them to see the final statements with this.

```sh
# go into the project 
cd dbt_proj01

dbt compile
```

And we should see this message confirming that all models are completed with no errors.

```
19:34:42  Running with dbt=1.10.13
19:34:43  Registered adapter: bigquery=1.10.2
19:34:43  Found 2 models, 4 data tests, 508 macros
19:34:43  
19:34:43  Concurrency: 1 threads (target='dev')
```

All compiled models are stored in `target/compiled/<project_name>/models/`{: .filepath} directory.

Let's see what's inside.

{% tabs dbt2-compiled %}

{% tab dbt2-compiled file tree %}

```
target/compiled
└── dbt_proj01
    └── models
        └── example
            ├── my_first_dbt_model.sql
            ├── my_second_dbt_model.sql
            └── schema.yml
                ├── not_null_my_first_dbt_model_id.sql
                ├── not_null_my_second_dbt_model_id.sql
                ├── unique_my_first_dbt_model_id.sql
                └── unique_my_second_dbt_model_id.sql
```

{% endtab %}

{% tab dbt2-compiled my_first_dbt_model.sql %}

```sql
/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/



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

{% endtab %}

{% tab dbt2-compiled my_second_dbt_model.sql %}

```sql
-- Use the `ref` function to select from other models

select *
from `<project>`.`<dataset>`.`my_first_dbt_model`
where id = 1
```

{% endtab %}

{% endtabs %}

These compiled statements can be actually run now.

---

## Run

We can either compile before or not, and this command is to compile and run all models then produce the tables/views in the real environment.

```sh
# go into the project 
cd dbt_proj01

dbt run
```

```
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

The log says that everything is good. When we check in the BigQuery, we should see the new tables/views from the models we ran seconds ago.

![tables created dark](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-dbt/dbt2-run-result-dark.png){: .dark .apply-border style="max-width:60%;margin:auto;"}
![tables created light](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-dbt/dbt2-run-result-light.png){: .light .apply-border style="max-width:60%;margin:auto;"}

As we can see, the models' names are utilized to be their table/view names.

---

## Wrap up

Let's wrap everything up for what commands we ran.

```sh
# install dbt
uv add dbt-core dbt-<adapter>
pip install dbt-core dbt-<adapter>

dbt init    # initialize
dbt debug   # verify 
dbt compile # build final statements
dbt run     # build real tables/views
```

---

## References

- [Supported data platforms \| dbt Developer Hub](https://docs.getdbt.com/docs/supported-data-platforms)
- [About dbt init command \| dbt Developer Hub](https://docs.getdbt.com/reference/commands/init)
- [About dbt debug command \| dbt Developer Hub](https://docs.getdbt.com/reference/commands/debug)
- [About dbt compile command \| dbt Developer Hub](https://docs.getdbt.com/reference/commands/compile)
- [About dbt run command \| dbt Developer Hub](https://docs.getdbt.com/reference/commands/run)
