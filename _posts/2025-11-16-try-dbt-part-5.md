---
title: "Let's try: dbt part 5 - from Jinja to macros and hooks"
layout: post
author: bluebirz
description: One of core features is controlling dbt flows with Jinja and write macros and hooks
date: 2025-11-16
categories: [data, data engineering]
tags: [let's try, Python, dbt, SQL, Jinja]
comment: true
series:
  key: dbt
  index: 5
image:
  path: assets/img/features/external/dbt.png
  lqip: ../assets/img/features/lqip/external/dbt.webp
  alt: dbt-labs/dbt-core
  caption: <a href="https://github.com/dbt-labs/dbt-core">dbt-labs/dbt-core</a>
media_dir: https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-dbt/dbt5/
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

{% include bbz_custom/tabs.html %}

Not only SQL that we can execute in dbt, one of the core features is Jinja and in this blog we are controlling the flow by writing macros and configure hooks.

---

## Jinja

I have the blog [Let's try: Jinja2]({% post_url 2024-08-12-try-jinja2%}) about Jinja and Python. Let's recap one more time right here.

{% raw %}

### Comments

A comment must be written in `{# ... #}`.

```jinja
{# this is a comment #}
```

### Statements

A statement controls program flow and is written in `{% ... %}`.

#### Variables

Use `set` to declare and initiate a variable.

```jinja
{% set var_a = 1 %}
{% set str = "abcd" %}
{% set is_empty = false %}
{% set arr = ['a', 'b', 'c'] %}
{% set tuple = ('a', 'b') %}
{% set dictionary = dict(a=1, b=2, c=3, d=[4, 5]) %} 
              {# or {'a': 1, 'b': 2, 'c': 3, 'd': [4, 5]} #}
{% set dict_arr = [dict(a=1), dict(b=2), dict(c=3), dict(d=[4, 5])] %}
              {# or [{'a' : 1}, {'b': 2}, {'c': 3}, {'d': [4, 5]}] #}
{% set multiline_text %}
  Lorem ipsum dolor sit amet consectetur adipiscing elit. 
  Quisque faucibus ex sapien vitae pellentesque sem placerat. 
  In id cursus mi pretium tellus duis convallis. 
  Tempus leo eu aenean sed diam urna tempor. 
{% endset %}
```

#### If-else structure

Simply put `if`-`elif`-`else` and finish with `endif`.

```jinja
{% if <statement> %}
  ...
{% elif <statement> %}
  ...
{% else %}
  ...
{% endif %}
```

#### For-loop

Simply put `for`-`endfor` as well.

```jinja
{% for element in <iterator> %}
  ...
{% endfor %}
```

When iterate over dictionary, we can use `.items()` to extract key-value.

```jinja
{% for dict in <dict_iterator> %}
  {% for key, value in dict.items() %}
  ...
  {% endfor %}
{% endfor %}
```

### Expressions

An expression is an output. We refer them by `{{ ... }}`.

```jinja
{{ var_a }}
```

{% endraw %}

---

## Macros

Macros act like functions that we can call them to execute specific tasks such as querying latest run date from reference tables or inserting some records into log table.

We have written one macro `generate_schema_name()` before in [Let's try: dbt part 3 - seed and source]({% post_url 2025-10-18-try-dbt-part-3 %}) for creating schema with plain input name instead of concatenation as below.

{% raw %}

{: file='generate_schema_name.sql'}

```jinja
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

> The macro above is an overriding by just building the same macro name and add our desired behavior. The built-in macros in dbt can be found [here](https://github.com/dbt-labs/dbt-adapters/tree/main/dbt-adapters/src/dbt/include/global_project/macros) that I came across [the Stackoverflow forum](https://stackoverflow.com/questions/73784001/where-to-find-dbt-macros-when-wishing-to-edit-it#comment140032887_78568564).
{: .prompt-tip }

### Develop a macro

To develop a macro, we start a Jinja structure below.

{% raw %}

```jinja
{% macro <macro_name>(<argument_1>, <argument_2>, ... ) -%}
  {# code stub #}
  ...
  {{ return(<variable>) }} {# `return` if needed #}
{%- endmacro %}
```

And we also can define the property file[^macroprop] like this.

{: file='macros/properties.yml'}

```yml
macros:
  - name: <macro_name>
    description: <macro_description>
    arguments:
      - name: <argument_name>
        type: <argument_type>
        description: <argument_description>
```

### Use a macro

We can simply call a macro with an expression (`{{ ... }}`) or defining a new variable for the return with a statement (`{% ... %}`) as examples below.

```jinja
{# call a macro with expression #}
{{ my_macro(param01, param02) }}

{# call a macro with statement and get return value #}
{% set some_var = my_compute_macro(param01, param02, param03) %}
```

{% endraw %}

### Example macro

Let's say that we have this log table.

![log light]({{ page.media_dir }}log-light.png){: .light style="max-width:90%;margin:auto;" .apply-border}
![log dark]({{ page.media_dir }}log-dark.png){: .dark style="max-width:90%;margin:auto;" .apply-border}

And we want a macro to find the data in the reference table as of the last date in the log table.

Then we write this macro property file.

{: file='macros/properties.yml'}

```yml
macros:
  - name: get_last_date_from_log
    description: get last date from log table
    arguments:
      - name: ref_table
        type: string
        description: reference table to be searched in this log table
```

And develop the macro script as follows.

{% raw %}

{: file='macros/get_last_date_from_log.sql'}

```jinja
{% macro get_last_date_from_log(ref_table) %}
    {% set log_table = "raw.logs" %}
    {% set query %}
      SELECT MAX(process_date) as last_process_date
      FROM `{{ log_table }}`
      WHERE true 
        AND process_name = "{{ ref_table }}"
        AND is_successful IS TRUE 
    {% endset %}

    {% if execute %}
        {{ print("query = " + query) }}
        {% set query_result = run_query(query) %}
        {{ log(query_result.columns["last_process_date"].values()) }}
        {{ return(query_result.columns[0].values()[0]) }}
    {% endif %}
{% endmacro %}
```

- **line 1**: start from `{% macro <macro_name>(<params>) %}` where `params` is just `ref_table`.
- **line 2**: I want to have a variable `log_table` to be the name of log table.
- **line 3**: define `query` to be a statement to query log table with `{% set query %}`.
- **line 5,7**: substitute `{{ log_table }}` and `{{ ref_table }}` in the `query`.
- **line 9**: complete defining `query` with `{% endset %}`.
- **line 11**: apply `{% if execute %}` to be run when it is execute[^execute] mode which means we're building/compiling/running the model, not the steps generating the DAGs.
- **line 12**: `{{ print() }}` to print[^print] out to console.
- **line 13**: query with `run_query`[^query] and save result into `query_result`.
- **line 14**: `query_result` is type `Table`[^tabletype] and we can `log()`[^log] to write it into the log file to see the value of column `last_process_date`.
- **line 15**: finally return the date with `{{ return() }}`.
- **line 17**: end the macro with `{% endmacro %}`.

{% endraw %}

Now we can make use of this macro as below:

{% raw %}

{: file='climate-stat-from-log.sql'}

```sql
{%- set last_date = get_last_date_from_log(this.table) -%}
select *
from {{ source("delhi_climate", "daily_delhi_climate") }}
where date = "{{ last_date }}"
```

We are just call the macro and receive its returned value by a statement `{% set var = macro(params) %}`. And `this.table` means the table name of this model, in this case it's the file name `climate-stat-from-log`.

`this`[^this] is also a dbt Jinja function.

{% endraw %}

And we can try compiling to see result.

{% tabs dbt5-macro %}

{% tab dbt5-macro Compiled result %}

When we `dbt compile` we can see the query that we `print("query = " ...)` and the compiled model as below.

```
22:42:51  Running with dbt=1.10.13
22:42:53  Registered adapter: bigquery=1.10.2
22:42:53  Found 6 models, 7 seeds, 4 data tests, 2 sources, 510 macros
22:42:53  
22:42:53  Concurrency: 1 threads (target='dev')
22:42:53  
query = 
      SELECT MAX(process_date) as last_process_date
      FROM `raw.logs`
      WHERE true 
        AND process_name = "climate-stat-from-log"
        AND is_successful IS TRUE 
    
Compiled node 'climate-stat-from-log' is:
select *
from `bluebirz-playground`.`raw`.`daily_delhi_climate`
where date = "2016-11-10"
```

{% endtab %}

{% tab dbt5-macro dbt log %}

When we check the log at `logs/dbt.log`{: .filepath}, We can also see what we `print()` and the date that we `log()` at the second to last line.

{: file='logs/dbt.log'}

```
23:42:55.769840 [debug] [Thread-1 (]: Began compiling node model.dbt_proj01.climate-stat-from-log
23:42:55.780263 [info ] [Thread-1 (]: query = 
      SELECT MAX(process_date) as last_process_date
      FROM `raw.logs`
      WHERE true 
        AND process_name = "climate-stat-from-log"
        AND is_successful IS TRUE 
    
23:42:55.789551 [debug] [Thread-1 (]: On model.dbt_proj01.climate-stat-from-log: /* {"app": "dbt", "dbt_version": "1.10.13", "profile_name": "dbt_proj01", "target_name": "dev", "node_id": "model.dbt_proj01.climate-stat-from-log"} */

    
      SELECT MAX(process_date) as last_process_date
      FROM `raw.logs`
      WHERE true 
        AND process_name = "climate-stat-from-log"
        AND is_successful IS TRUE 
    
  
23:42:55.790241 [debug] [Thread-1 (]: Opening a new connection, currently in state closed
23:42:56.422744 [debug] [Thread-1 (]: BigQuery adapter: https://console.cloud.google.com/bigquery?project=<project>&j=<job_id>&page=queryresults
23:42:57.036284 [debug] [Thread-1 (]: (datetime.date(2016, 11, 10),)
23:42:57.038868 [debug] [Thread-1 (]: Writing injected SQL for node "model.dbt_proj01.climate-stat-from-log"
```

{% endtab %}

{% endtabs %}

These functions above are parts of dbt Jinja functions[^jinjafunc].

---

## Hooks

Hooks[^hook] are commands automatically executing before or after running models. They're frequently used for chain-execution e.g. stamping the record and time of which model is about to run or run successfully.

- `pre-hook`: executed before building models, seeds, or snapshots.
- `post-hook`: executed after building models, seeds, or snapshots.
- `on-run-start`: executed at the start of `dbt` commands.
- `on-run-end`: executed at the end of `dbt` commands.

### Define hooks

We can define `pre-hook` and `post-hook` in either `dbt_project.yml`{: .filepath}, model files, or `properties.yml`{: .filepath}. But `on-run-start` and `on-run-end` need to be configured in `dbt_project.yml`{: .filepath}.

{% tabs dbt5-hooks %}

{% tab dbt5-hooks file tree %}

```
dbt_directory
├── dbt_project.yml
└── models
    └─── <model_name>
        ├── property.yml
        └── model_file.sql
```

{% endtab %}

{% tab dbt5-hooks dbt_project.yml %}

```yml
models:
  <project_name>:
    +pre-hook:
      - "<pre-hook statement for models>"
    +post-hook:
      - "<post-hook statement for models>"

seeds:
  <project_name>:
    +pre-hook:
      - "<pre-hook statement for seeds>"
    +post-hook:
      - "<post-hook statement for seeds>"

snapshots:
  <project_name>:
    +pre-hook:
      - "<pre-hook statement for snapshots>"
    +post-hook:
      - "<post-hook statement for snapshots>"

on-run-start:
  - "<on-run-start statement>"

on-run-end:
  - "<on-run-end statement>"
```

{% endtab %}

{% tab dbt5-hooks model SQL files %}

{% raw %}

```jinja
{{-
  config(
    pre_hook=["<statement>"],
    post_hook=["<statement>"],
    ) 
-}}
SELECT ...
```

{% endraw %}

{% endtab %}

{% tab dbt5-hooks property.yml %}

```yml
models:
  - name: [<model_name>]
    config:
      pre_hook: 
      - "<pre-hook statement for models"
      post_hook: 
      - "<post-hook statement for models"

seeds:
  - name: [<seed_name>]
    config:
      pre_hook: 
      - "<pre-hook statement for seeds"
      post_hook: 
      - "<post-hook statement for seeds"

snapshots:
  - name: [<snapshot_name>]
    config:
      pre_hook: 
      - "<pre-hook statement for snapshots"
      post_hook: 
      - "<post-hook statement for snapshots"

```

{% endtab %}

{% endtabs %}

### Example hooks

We just want to print out each hook is executed and we can see the result.

{% tabs dbt5-hooks-example %}

{% tab dbt5-hooks-example dbt_project.yml %}

Just print out which is executed.

{% raw %}

```yml
on-run-start:
  - "{{ print('on-run-start executed') }}"

on-run-end:
  - "{{ print('on-run-end executed') }}"
```

{% endraw %}

{% endtab %}

{% tab dbt5-hooks-example model SQL files %}

I reuse the model from macro section above to add hooks right here to print out which hook is executed.

{% raw %}

{: file='climate-stat-from-log.sql'}

```sql
{{-
    config(
        pre_hook=["{{ print('pre-hook executed') }}"],
        post_hook=["{{ print('post-hook executed') }}"],
    )
-}}
{%- set last_date = get_last_date_from_log(this.table) -%}
select *
from {{ source("delhi_climate", "daily_delhi_climate") }}
where date = "{{ last_date }}"
```

{% endraw %}

{% endtab %}

{% tab dbt5-hooks-example Run result %}

When `dbt run`, we can see these texts respectively:

1. `on-run-start executed`
1. `pre-hook executed`
1. `post-hook executed`
1. `on-run-end executed`

```
22:19:40  Running with dbt=1.10.13
22:19:42  Registered adapter: bigquery=1.10.2
22:19:42  Found 6 models, 7 seeds, 2 operations, 4 data tests, 2 sources, 510 macros
22:19:42  
22:19:42  Concurrency: 1 threads (target='dev')
22:19:42  
on-run-start executed
22:19:45  1 of 1 START hook: dbt_proj01.on-run-start.0 ................................... [RUN]
22:19:45  1 of 1 OK hook: dbt_proj01.on-run-start.0 ...................................... [OK in 0.02s]
22:19:45  
22:19:45  1 of 1 START sql table model dbt_test_dataset.climate-stat-from-log ............ [RUN]
query = 
      SELECT MAX(process_date) as last_process_date
      FROM `raw.logs`
      WHERE true 
        AND process_name = "climate-stat-from-log"
        AND is_successful IS TRUE 
    
pre-hook executed
post-hook executed
22:19:49  1 of 1 OK created sql table model dbt_test_dataset.climate-stat-from-log ....... [CREATE TABLE (1.0 rows, 2.4 KiB processed) in 4.87s]
22:19:49  
on-run-end executed
22:19:49  1 of 1 START hook: dbt_proj01.on-run-end.0 ..................................... [RUN]
22:19:49  1 of 1 OK hook: dbt_proj01.on-run-end.0 ........................................ [OK in 0.00s]
22:19:49  
22:19:49  Finished running 2 project hooks, 1 table model in 0 hours 0 minutes and 7.31 seconds (7.31s).
22:19:50  
22:19:50  Completed successfully
22:19:50  
22:19:50  Done. PASS=3 WARN=0 ERROR=0 SKIP=0 NO-OP=0 TOTAL=3
```

{% endtab %}

{% endtabs %}

---

## Wrap up

{% raw %}

- Jinja
  - comment: `{# ... #}`
  - variable: `{% set var = ... %}` or `{% set var %} ... {% endset %}`
  - if-else: `{% if bool %} ... {% elif bool %} ... {% else %} ... {% endif %}`
  - for-loop: `{% for element in iterator %} ... {% endfor %}`
  - for-loop over dictionary: `{% for key, value in dict.items() %} ... {% endfor %}`
  - expression: `{{ ... }}`
- Macros
  - define macro: `{% macro <name>(params) %} ... {% endmacro %}`
  - use macro by `{{ macro(params) }}` or `{% set var = macro(params) %}`
  - `execute` is true when it's execute mode that is to build/compile/run the models.
  - `{{ print() }}` to print out to console.
  - `{{ run_query() }}` to execute the query with the project adapter.
  - After `run_query()`, the `Table` object will be returned and we can unpack the values.
  - `{{ log() }}` to write into log file at `logs/dbt.log`{: .filepath}.
  - `{{ return() }}` to return value
  - `this` refers to the current model and `this.table` is the table name of the current model.
- Hooks
  - set `on-run-start` or `on-run-end` in `dbt_project.yml`{: .filepath} to trigger when `dbt` commands start/end.
  - set `pre_hook` or `post_hook` to trigger before/after the specific model/seed/snapshot is built.

{% endraw %}

---

## References

[^jinjafunc]: [dbt Jinja functions \| dbt Developer Hub](https://docs.getdbt.com/reference/dbt-jinja-functions)
[^macroprop]: [Macro properties \| dbt Developer Hub](https://docs.getdbt.com/reference/macro-properties)
[^query]:  [About run_query macro \| dbt Developer Hub](https://docs.getdbt.com/reference/dbt-jinja-functions/run_query)
[^execute]: [About execute variable \| dbt Developer Hub](https://docs.getdbt.com/reference/dbt-jinja-functions/execute)
[^print]: [About print function \| dbt Developer Hub](https://docs.getdbt.com/reference/dbt-jinja-functions/print)
[^tabletype]: [Table - agate documentation](https://agate.readthedocs.io/en/latest/api/table.html)
[^log]: [log \| dbt Developer Hub](https://docs.getdbt.com/reference/dbt-jinja-functions/log)
[^this]: [about this \| dbt Developer Hub](https://docs.getdbt.com/reference/dbt-jinja-functions/this)
[^hook]: [Hooks and operations \| dbt Developer Hub](https://docs.getdbt.com/docs/build/hooks-operations)
