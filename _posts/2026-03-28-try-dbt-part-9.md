---
title: "Let's try: dbt part 9 - variables"
layout: post
author: bluebirz
description: Variables bring flexibility to our pipelines so we define and utilize them here.
date: 2026-03-28
categories: [data, data engineering]
tags: [let's try, Jinja, Python, SQL, dbt]
comment: true
series:
  key: dbt
  index: 9
image:
  path: /assets/img/features/external/dbt.png
  lqip: /assets/img/features/lqip/external/dbt.webp
  alt: dbt-labs/dbt-core
  caption: <a href="https://github.com/dbt-labs/dbt-core">dbt-labs/dbt-core</a>
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

{% include bbz_custom/tabs.html %}

Variables bring flexibility to our pipelines. There are two easy methods to define and utilize variables in dbt.

---

## Set globally

We can declare and define through `dbt_project.yml`{: .filepath} as below.

### Define and use

Config in `dbt_project.yml`{: .filepath} can be made under the key `vars` like this.

{: file='dbt_project.yml'}

```yaml
vars:
  target_date: 2026-01-01
```

This is the new variable `target_date` and then we can refer the variable `target_date` using `var()` macro in a model like below.

{% raw %}

```sql
select *
from {{ source("students", "student_grades") }}
where updated_at = '{{ var("target_date") }}'
```

{% endraw %}

When we compile and the value of `target_date` would be assigned for `updated_at` like this.

```sh
$ dbt compile 
Compiled node 'selected_students' is:
select *
from `bluebirz-playground`.`raw`.`student_grades`
where updated_at = '2026-01-01'
```

### Overriding

There is a case we want to override the variables' value so with `--vars` flag the values will be substituted.

```sh
$ dbt compile --vars '{target_date: 2026-02-01}'
Compiled node 'selected_students' is:
select *
from `bluebirz-playground`.`raw`.`student_grades`
where updated_at = '2026-02-01'
```

> Double-check the quotes and escape characters for the YAML configs and flag `--vars`.
{: .prompt-tip }

### Default value

In some cases, we need default values for variables. Supplying second argument to `var()` macro is giving default values.

{% raw %}

```sql
select *
from {{ source("students", "student_grades") }}
where
    updated_at = '{{ var("target_date") }}'
    and name = '{{ var("target_name", "Billy") }}'
```

{% endraw %}
Now `Billy` is a default value when `target_name` can't be found like this.

```sh
$ dbt compile 
Compiled node 'selected_students' is:
select *
from `bluebirz-playground`.`raw`.`student_grades`
where
    updated_at = '2026-01-01'
    and name = 'Billy'

```

### Dealing with arrays

We can define an array in YAML syntax using hyphens (`-`) or brackets (`[]`) as below.

```yaml
vars:
  target_date: 2026-01-01
  target_subjects:
    - "biology"
    - "physics"
    - "chemistry"
  other_subjects: ["literature", "mathematics"]
```

Now let's say we want this final query below as a model.

```sh
$ dbt compile 
Compiled node 'selected_students' is:
select *
from `bluebirz-playground`.`raw`.`student_grades`
where
    updated_at = '2026-01-01'
    and subject in ('biology', 'physics', 'chemistry')
```

There are different ways to achieve it.

{% tabs dbt9-arr %}

{% tab dbt9-arr loop %}

We can do it in traditional loop way. With iterating over an array using [for-loop](https://jinja.palletsprojects.com/en/stable/templates/#for), concatenating each element in it with comma `,` if the element isn't the last in the array, and we can explicitly get a complete string having commas from that array.

{% raw %}

```sql
select *
from {{ source("students", "student_grades") }}
where
    updated_at = '{{ var("target_date") }}'
    and subject in (
        {%- for subject in var("target_subjects") -%}
            '{{ subject }}' {%- if not loop.last -%},{%- endif -%}
        {%- endfor -%}
    )
```

{% endraw %}

{% endtab %}

{% tab dbt9-arr replace %}

{% raw %}

By default, an array can be cast to a string in format `[a, b, c, ...]`, so we can just using Jinja filter [`replace`](https://jinja.palletsprojects.com/en/stable/templates/#jinja-filters.replace) to transform `[]` to `()`.

```sql
select *
from {{ source("students", "student_grades") }}
where
    updated_at = '{{ var("target_date") }}'
    and subject in {{ var("target_subjects") | replace("[", "(") | replace("]", ")") }}
```

{% endraw %}

{% endtab %}

{% tab dbt9-arr join %}

Or just a Jinja filter [`join`](https://jinja.palletsprojects.com/en/stable/templates/#jinja-filters.join) to combine all elements with commas and surround them with quotes and parentheses `('...')` then we now get a complete string.

{% raw %}

```sql
select *
from {{ source("students", "student_grades") }}
where
    updated_at = '{{ var("target_date") }}'
    and subject in ('{{ var("target_subjects") | join("', '") }}')
```

{% endraw %}

{% endtab %}

{% endtabs %}

---

## Set locally

In case we don't want to declare it globally but just have some to use in a single model, we can do this.

### Set and use

{% raw %}

Using `{% set <variable> = <value> %}` to declare a variable and its value in the model. Then refer the variables just by writing statement `{{ <var> }}`.

```sql
{%- set target_date = "2026-01-01" -%}

select *
from {{ source("students", "student_grades") }}
where updated_at = '{{ target_date }}'
```

{% endraw %}

Now `target_date` is "2026-01-01" after compiling.

```sh
$ dbt compile
Compiled node 'selected_students' is:
select *
from `bluebirz-playground`.`raw`.`student_grades`
where updated_at = '2026-01-01'
```

### Set arrays

Also declare arrays and concatenate it to string like above examples.

{% raw %}

```sql
{%- set target_date = "2026-01-01" -%}
{%- set target_subjects = ["biology", "physics", "chemistry"] -%}
select *
from {{ source("students", "student_grades") }}
where
    updated_at = '{{ target_date }}'
    and subject in {{ target_subjects | replace("[", "(") | replace("]", ")") }}
```

{% endraw %}

Now we get the array like this.

```sh
$ dbt compile
Compiled node 'selected_students' is:
select *
from `bluebirz-playground`.`raw`.`student_grades`
where
    updated_at = '2026-01-01'
    and subject in ('biology', 'physics', 'chemistry')
```

### Overriding from global vars

And of course, defining local variables by inheriting global variables is also possible.

{% raw %}

```sql
{%- set search_date = var("target_date") -%}
select *
from {{ source("students", "student_grades") }}
where updated_at = '{{ search_date }}'
```

{% endraw %}

Then `--vars` flag is usable here.

```sh
$ dbt compile --vars '{target_date: 2026-02-01}'
Compiled node 'selected_students' is:
select *
from `bluebirz-playground`.`raw`.`student_grades`
where updated_at = '2026-02-01'
```

---

## Wrap up

{% raw %}

- Define global variables with key `vars` in `dbt_project.yml`{: .filepath}.
- Utilize global variables by `{{ var("<var>", "<default_value>") }}`.
- Define local variables with `{% set <var> = <value> %}` in a model.
- Utilize local variables by `{{ <var> }}`.
- Flag `--vars` is for overriding variables when execute dbt commands.
- Jinja filters like `replace`, `join` and for-loop are useful for array concatenation.

{% endraw %}

---

## References

- [About var function \| dbt Developer Hub](https://docs.getdbt.com/reference/dbt-jinja-functions/var)
- [About set context method \| dbt Developer Hub](https://docs.getdbt.com/reference/dbt-jinja-functions/set)
- [List of Builtin Filters - Template Designer Documentation — Jinja Documentation](https://jinja.palletsprojects.com/en/stable/templates/#list-of-builtin-filters)
