---
title: "Let's try: dbt part 6 - snapshots and analyses"
layout: post
author: bluebirz
description: 
# date: 
categories: [data, data engineering]
tags: [let's try, Python, dbt, SQL, Jinja]
comment: true
series:
  key: dbt
  index: 6
image:
  path: assets/img/features/external/dbt.png
  lqip: ../assets/img/features/lqip/external/dbt.webp
  alt: dbt-labs/dbt-core
  caption: <a href="https://github.com/dbt-labs/dbt-core">dbt-labs/dbt-core</a>
media_dir: https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-dbt/dbt4/
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

{% include bbz_custom/tabs.html %}

---

## Jinja

I have the blog [Let's try: Jinja2]({% post_url 2024-08-12-try-jinja2%}) about Jinja and Python. We can re-read Jinja one more time right here.

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

Macros act like functions that we can call them to execute a specific task such as querying latest run date from reference tables or ...

- advantage
- implement
- usage
- `do`
- `call`

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

> The macro above is an overriding by just building the same macro name and add our desired behavior. The built-in macros in dbt can be found [here](https://github.com/dbt-labs/dbt-adapters/tree/main/dbt-adapters/src/dbt/include/global_project/macros) that I came across the forum in [Stackoverflow](https://stackoverflow.com/questions/73784001/where-to-find-dbt-macros-when-wishing-to-edit-it#comment140032887_78568564).
{: .prompt-tip }

To develop a macro, we use Jinja to implement it.

{% raw %}

```jinja
{% macro <macro_name>(<argument_1>, <argument_2>, ... ) -%}
  {# code stub #}
  ...
  {{ return(<variable>) }} {# `return` if needed #}
{%- endmacro %}
```

{% endraw %}

This is an example macro to ...

```jinja

```

---

## Hooks

Hooks are commands automatically executing before or after running models. They're frequently used for chain-execution e.g. stamping the record and time of which model is about to run or run successfully.

- pre-hook: executed before building models, seeds, or snapshots.
- post-hook: executed after building models, seeds, or snapshots.
- on-run-start: executed at the start of `dbt` commands.
- on-run-end: executed at the end of `dbt` commands.

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

### Example

I want to run macro

---

## References

- <https://docs.getdbt.com/reference/dbt-jinja-functions>
- <https://docs.getdbt.com/reference/dbt-jinja-functions/dispatch#overriding-package-macros>
- <https://docs.getdbt.com/reference/macro-properties>
- <https://docs.getdbt.com/docs/build/jinja-macros>
- <https://bookdown.org/sammigachuhi/dbt_book/jinja.html>
- <https://docs.getdbt.com/docs/build/hooks-operations>
