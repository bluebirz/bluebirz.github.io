---
title: "Let's try: dbt part 9 - variables"
layout: post
author: bluebirz
description: 
# date: 
categories: [data, data engineering]
tags: [let's try, Python, dbt]
comment: true
series:
  key: dbt
  index: 9
image:
  path: assets/img/features/external/dbt.png
  lqip: ../assets/img/features/lqip/external/dbt.webp
  alt: dbt-labs/dbt-core
  caption: <a href="https://github.com/dbt-labs/dbt-core">dbt-labs/dbt-core</a>
# media_dir: https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-dbt/dbt8/
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

{% include bbz_custom/tabs.html %}

Variables bring flexibility to our pipelines. There are two easy methods to deploy and utilize variables in dbt.

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

Then we can refer the variable `target_date` using `var()` macro in a model like below.

{% raw %}

```sql
select *
from {{ source("students", "student_grades") }}
where updated_at = '{{ var("target_date") }}'
```

{% endraw %}

The value of `target_date` would be assigned for `updated_at` like this.

```sh
$ dbt compile 
Compiled node 'selected_students' is:
select *
from `bluebirz-playground`.`raw`.`student_grades`
where updated_at = '2026-01-01'
```

### Overriding

And we can override the variables' value with `--vars` flag.

```sh
$ dbt compile --vars '{target_date: 2026-02-01}'
Compiled node 'selected_students' is:
select *
from `bluebirz-playground`.`raw`.`student_grades`
where updated_at = '2026-02-01'
```

> Double-check the quotes and escape characters for the YAML configs and flag `--vars`
{: .prompt-tip }

{% raw %}

### Default value

```
select *
from {{ source("students", "student_grades") }}
where
    updated_at = '{{ var("target_date") }}'
    and name = '{{ var("target_name", "Billy") }}'
```

{% endraw %}

```
dbt compile --select models/students/selected_students.sql
Compiled node 'selected_students' is:
select *
from `bluebirz-playground`.`raw`.`student_grades`
where
    updated_at = '2026-01-01'
    and name = 'Billy'

```

### Dealing with arrays

```yaml
vars:
  target_date: 2026-01-01
  target_subjects:
    - "biology"
    - "physics"
    - "chemistry"
```

Expected

```
dbt compile --select models/students/selected_students.sql
Compiled node 'selected_students' is:
select *
from `bluebirz-playground`.`raw`.`student_grades`
where
    updated_at = '2026-01-01'
    and subject in ('biology', 'physics', 'chemistry')
```

!start tabs
{% raw %}

```jinja
select *
from {{ source("students", "student_grades") }}
where
    updated_at = '{{ var("target_date") }}'
    and subject in {{ var("target_subjects") | replace("[", "(") | replace("]", ")") }}
```

{% endraw %}
{% raw %}

```jinja
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
{% raw %}

```jinja
select *
from {{ source("students", "student_grades") }}
where
    updated_at = '{{ var("target_date") }}'
    and subject in ('{{ var("target_subjects") | join("', '") }}')
```

{% endraw %}

---

## Set locally

### Set and use

In case we have some variables to use in a model and don't want to declare it globally, we can use set
{% raw %}

```sql
{%- set target_date = "2026-01-01" -%}

select *
from {{ source("students", "student_grades") }}
where updated_at = '{{ var("target_date") }}'
```

{% endraw %}

```
dbt compile --select models/students/selected_students.sql
Compiled node 'selected_students' is:
select *
from `bluebirz-playground`.`raw`.`student_grades`
where updated_at = '2026-01-01'
```

### Set arrays

{% raw %}

```jinja
{%- set target_date = "2026-01-01" -%}
{%- set target_subjects = ["biology", "physics", "chemistry"] -%}
select *
from {{ source("students", "student_grades") }}
where
    updated_at = '{{ target_date }}'
    and subject in {{ target_subjects | replace("[", "(") | replace("]", ")") }}
```

{% endraw %}

```
dbt compile --select models/students/selected_students.sql
Compiled node 'selected_students' is:
select *
from `bluebirz-playground`.`raw`.`student_grades`
where
    updated_at = '2026-01-01'
    and subject in ('biology', 'physics', 'chemistry')
```

### Overriding from global vars

{% raw %}

```jinja
{%- set search_date = var("target_date") -%}
select *
from {{ source("students", "student_grades") }}
where updated_at = '{{ search_date }}'
```

{% endraw %}

```
dbt compile --select models/students/selected_students.sql --vars '{target_date: 2026-02-01}'
Compiled node 'selected_students' is:
select *
from `bluebirz-playground`.`raw`.`student_grades`
where updated_at = '2026-02-01'
```

---

## Wrap up

---

## References

- [About var function \| dbt Developer Hub](https://docs.getdbt.com/reference/dbt-jinja-functions/var)
- [About set context method \| dbt Developer Hub](https://docs.getdbt.com/reference/dbt-jinja-functions/set)
- [List of Builtin Filters - Template Designer Documentation — Jinja Documentation](https://jinja.palletsprojects.com/en/stable/templates/#list-of-builtin-filters)
