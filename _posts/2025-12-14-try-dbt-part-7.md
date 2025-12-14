---
title: "Let's try: dbt part 7 - tests"
layout: post
author: bluebirz
description: we can add tests on important fields in dbt
date: 2025-12-14
categories: [data, data engineering]
tags: [let's try, Python, dbt, SQL, Jinja, testing]
comment: true
series:
  key: dbt
  index: 7
image:
  path: assets/img/features/external/dbt.png
  lqip: ../assets/img/features/lqip/external/dbt.webp
  alt: dbt-labs/dbt-core
  caption: <a href="https://github.com/dbt-labs/dbt-core">dbt-labs/dbt-core</a>
media_dir: https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-dbt/dbt7/
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

{% include bbz_custom/tabs.html %}

Come to one of important parts of the data flow, we can add tests on important fields in dbt and here we are going to see how.

---

## dbt tests

In dbt, we can perform tests by 2 types:

1. **Generic tests**
    - This type of tests is **predefined** tests that we can simply call it like macros.
    - Perform tests on a specific field of a model.
    - We can configure generic tests in YAML files of many paths such as models, sources, seeds, and snapshots.
1. **Singular tests**
    - This type is **custom queries** that we can design in a complex and flexible way.
    - Perform tests either on fields or cross-models.
    - We can write singular tests under `tests/`{: .filepath} directory.

We can execute tests by running commands in 2 options.

1. `dbt test`: execute tests only.
1. `dbt build`: execute tests and build models when tests passed.

In this blog, we only test on models.

Okay. Let's begin.

---

## Generic test

Generic tests can be configured with these 4 out-of-the-box patterns; `unique`, `not_null`, `accepted_values`, `relationships` under `data_tests` key.

So here we are looking into each of them plus crafting our own custom generic tests.

### Prepare sources and models

Let's say we have 2 source tables: `student_grades` and `subjects` where is referenced by `subject` field in `student_grades` as below.

{% tabs dbt7-source %}

{% tab dbt7-source sources.yml %}

```yml
sources:
  - name: students
    schema: raw
    tables:
      - name: student_grades
        columns:
          - name: id
          - name: name
          - name: subject
          - name: grade
          - name: updated_at
  - name: subjects
    schema: raw
    tables:
      - name: subjects
        columns:
          - name: id
          - name: names
```

{% endtab %}

{% tab dbt7-source table: student_grades %}

![student_grades dark]({{ page.media_dir }}student-dark.png){: .dark style="max-width:100%;margin:auto;" .apply-border}
![student_grades light]({{ page.media_dir }}student-light.png){: .light style="max-width:100%;margin:auto;" .apply-border}

{% endtab %}

{% tab dbt7-source table: subjects %}

![subjects dark]({{ page.media_dir }}subject-dark.png){: .dark style="max-width:60%;margin:auto;" .apply-border}
![subjects light]({{ page.media_dir }}subjects-light.png){: .light style="max-width:60%;margin:auto;" .apply-border}

{% endtab %}

{% endtabs %}

We could spot that the table `student_grades` has some strange values:

- `id` of the first row is `null`.
- There are 2 "reed" names.
- There is the subject "literature" which does not exist in table `subjects`.
- The last row has grade "5" while others have 1-4.

Then we create a simple view model named `calc_grades` by just deriving everything from `student_grades`.

{% tabs dbt7-model %}

{% tab dbt7-model calc_grades.sql %}

{% raw %}

```sql
select * from {{ source("students", "student_grades") }}
```

{% endraw %}

{% endtab %}

{% tab dbt7-model calc_grades.yml %}

```yml
models:
  - name: calc_grades
    config:
      materialized: view
      schema: transform
    columns:
      - name: id
      - name: name
      - name: subject
      - name: grade
      - name: updated_at
```

{% endtab %}

{% tab dbt7-model dbt run result %}

We should see the similar outputs after `dbt run`.

```
21:54:02  Running with dbt=1.10.13
21:54:03  Registered adapter: bigquery=1.10.2
21:54:04  Found 7 models, 14 seeds, 8 data tests, 4 snapshots, 1 analysis, 5 sources, 510 macros
21:54:04  
21:54:04  Concurrency: 1 threads (target='dev')
21:54:04  
21:54:09  1 of 1 START sql view model transform.calc_grades .............................. [RUN]
21:54:11  1 of 1 OK created sql view model transform.calc_grades ......................... [CREATE VIEW (0 processed) in 1.45s]
21:54:11  
21:54:11  Finished running 1 view model in 0 hours 0 minutes and 7.15 seconds (7.15s).
21:54:11  
21:54:11  Completed successfully
21:54:11  
21:54:11  Done. PASS=1 WARN=0 ERROR=0 SKIP=0 NO-OP=0 TOTAL=1
```

{% endtab %}

{% endtabs %}

Now we're gonna add generic tests into our view model.

### test: `not_null`

`not_null` targets whether a specific field contains `null` values.

{% tabs dbt7-nn %}

{% tab dbt7-nn syntax %}

```yml
models:
  - name: <model_name>
    columns:
      - name: <column_name>
        data_tests:
          - not_null
```

{% endtab %}

{% tab dbt7-nn example %}

```yml
models:
  - name: calc_grades
    config:
      materialized: view
      schema: transform
    columns:
      - name: id
        data_tests:
          - not_null
      - name: name
      - name: subject
      - name: grade
      - name: updated_at
```

{% endtab %}

{% tab dbt7-nn dbt test result %}

```
21:56:32  1 of 1 START test not_null_calc_grades_id ...................................... [RUN]
21:56:34  1 of 1 FAIL 1 not_null_calc_grades_id .......................................... [FAIL 1 in 1.47s]
21:56:34  
21:56:34  Finished running 1 test in 0 hours 0 minutes and 4.10 seconds (4.10s).
21:56:34  
21:56:34  Completed with 1 error, 0 partial successes, and 0 warnings:
21:56:34  
21:56:34  Failure in test not_null_calc_grades_id (models/students/calc_grades.yml)
21:56:34    Got 1 result, configured to fail if != 0
21:56:34  
21:56:34    compiled code at target/compiled/dbt_proj01/models/students/calc_grades.yml/not_null_calc_grades_id.sql
21:56:34  
21:56:34  Done. PASS=0 WARN=0 ERROR=1 SKIP=0 NO-OP=0 TOTAL=1
```

{% endtab %}

{% tab dbt7-nn final test query %}

{: file='not_null_calc_grades_id.sql'}

```sql
select id
from `bluebirz-playground`.`transform`.`calc_grades`
where id is null
```

{% endtab %}

{% endtabs %}

### test: `unique`

`unique` focuses if there is duplicate values in a specific field.

{% tabs dbt7-unq %}

{% tab dbt7-unq syntax %}

```yml
models:
  - name: <model_name>
    columns:
      - name: <column_name>
        data_tests:
          - unique
```

{% endtab %}

{% tab dbt7-unq example %}

```yml
models:
  - name: calc_grades
    config:
      materialized: view
      schema: transform
    columns:
      - name: id
      - name: name
        data_tests:
          - unique
      - name: subject
      - name: grade
      - name: updated_at
```

{% endtab %}

{% tab dbt7-unq dbt test result %}

```
21:57:41  1 of 1 START test unique_calc_grades_name ...................................... [RUN]
21:57:42  1 of 1 FAIL 1 unique_calc_grades_name .......................................... [FAIL 1 in 1.43s]
21:57:42  
21:57:42  Finished running 1 test in 0 hours 0 minutes and 4.15 seconds (4.15s).
21:57:42  
21:57:42  Completed with 1 error, 0 partial successes, and 0 warnings:
21:57:42  
21:57:42  Failure in test unique_calc_grades_name (models/students/calc_grades.yml)
21:57:42    Got 1 result, configured to fail if != 0
21:57:42  
21:57:42    compiled code at target/compiled/dbt_proj01/models/students/calc_grades.yml/unique_calc_grades_name.sql
21:57:42  
21:57:42  Done. PASS=0 WARN=0 ERROR=1 SKIP=0 NO-OP=0 TOTAL=1

```

{% endtab %}

{% tab dbt7-unq final test query %}

{: file='unique_calc_grades_name.sql'}

```sql
with dbt_test__target as (

  select name as unique_field
  from `bluebirz-playground`.`transform`.`calc_grades`
  where name is not null

)

select
    unique_field,
    count(*) as n_records

from dbt_test__target
group by unique_field
having count(*) > 1
```

{% endtab %}

{% endtabs %}

### test: `relationships`

`relationships` refers to referential values across models that every values in a model must be exist in a reference model.

{% tabs dbt7-rel %}

{% tab dbt7-rel syntax %}

```yml
models:
  - name: <model_name>
    columns:
      - name: <column_name>
        data_tests:
          - relationships:
              arguments:
                to: <referent table using source() or ref()>
                field: <field_name of referent table>
```

{% endtab %}

{% tab dbt7-rel example %}

```yml
models:
  - name: calc_grades
    config:
      materialized: view
      schema: transform
    columns:
      - name: id
      - name: name
      - name: subject
        data_tests:
          - relationships:
              arguments:
                field: name
                to: source('subjects', 'subjects')
      - name: grade
      - name: updated_at
```

{% endtab %}

{% tab dbt7-rel dbt test result %}

```
21:58:34  1 of 1 START test relationships_calc_grades_subject__name__source_subjects_subjects_  [RUN]
21:58:36  1 of 1 FAIL 1 relationships_calc_grades_subject__name__source_subjects_subjects_  [FAIL 1 in 1.40s]
21:58:36  
21:58:36  Finished running 1 test in 0 hours 0 minutes and 3.90 seconds (3.90s).
21:58:36  
21:58:36  Completed with 1 error, 0 partial successes, and 0 warnings:
21:58:36  
21:58:36  Failure in test relationships_calc_grades_subject__name__source_subjects_subjects_ (models/students/calc_grades.yml)
21:58:36    Got 1 result, configured to fail if != 0
21:58:36  
21:58:36    compiled code at target/compiled/dbt_proj01/models/students/calc_grades.yml/relationships_calc_grades_98611d65b006dbb31a361fa7d65fecc0.sql
21:58:36  
21:58:36  Done. PASS=0 WARN=0 ERROR=1 SKIP=0 NO-OP=0 TOTAL=1
```

{% endtab %}

{% tab dbt7-rel final test query %}

{: file='relationships_calc_grades_xxx.sql'}

```sql
with child as (
    select subject as from_field
    from `bluebirz-playground`.`transform`.`calc_grades`
    where subject is not null
),

parent as (
    select name as to_field
    from `bluebirz-playground`.`raw`.`subjects`
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null
```

{% endtab %}

{% endtabs %}

### test: `accepted_values`

`accepted_values` is a list of values that the specific field should have.

{% tabs dbt7-acp %}

{% tab dbt7-acp syntax %}

```yml
models:
  - name: <model_name>
    columns:
      - name: <column_name>
        data_tests:
          - accepted_values:
              arguments:
                values: <list of accepted values>
                quote: <true|false if `values` is a string>
```

{% endtab %}

{% tab dbt7-acp example %}

```yml
models:
  - name: calc_grades
    config:
      materialized: view
      schema: transform
    columns:
      - name: id
      - name: name
      - name: subject
      - name: grade
        data_tests:
          - accepted_values:
              arguments:
                values:
                  - 1
                  - 2
                  - 3
                  - 4
                quote: false
      - name: updated_at
```

{% endtab %}

{% tab dbt7-acp dbt test result %}

```
21:59:30  1 of 1 START test accepted_values_calc_grades_grade__False__1__2__3__4 ......... [RUN]
21:59:32  1 of 1 FAIL 1 accepted_values_calc_grades_grade__False__1__2__3__4 ............. [FAIL 1 in 1.38s]
21:59:32  
21:59:32  Finished running 1 test in 0 hours 0 minutes and 3.65 seconds (3.65s).
21:59:32  
21:59:32  Completed with 1 error, 0 partial successes, and 0 warnings:
21:59:32  
21:59:32  Failure in test accepted_values_calc_grades_grade__False__1__2__3__4 (models/students/calc_grades.yml)
21:59:32    Got 1 result, configured to fail if != 0
21:59:32  
21:59:32    compiled code at target/compiled/dbt_proj01/models/students/calc_grades.yml/accepted_values_calc_grades_grade__False__1__2__3__4.sql
21:59:32  
21:59:32  Done. PASS=0 WARN=0 ERROR=1 SKIP=0 NO-OP=0 TOTAL=1
```

{% endtab %}

{% tab dbt7-acp final test query %}

{: file='accepted_values_calc_grades_xxx.sql'}

```sql
with all_values as (

    select
        grade as value_field,
        count(*) as n_records

    from `bluebirz-playground`.`transform`.`calc_grades`
    group by grade

)

select *
from all_values
where value_field not in (
    1,2,3,4
)
```

{% endtab %}

{% endtabs %}

### custom generic tests

We can craft our own generic tests[^customgentest] by writing `test` macros in `test/generic/`{: .filepath} and call it in YAML files.

This time we are testing and marking failed if there are any records having `updated_at` within date 5th of a month.

{% tabs dbt7-ctm %}

{% tab dbt7-ctm syntax: test macro %}

{% raw %}

```jinja
{% test <test_macro_name>(model, column_name) %}

select {{ column_name }} as target_field 
from {{ model }}
{# add where/join/group/etc. logic to fail the test #}

{% endtest %}
```

{% endraw %}

{% endtab %}

{% tab dbt7-ctm syntax: configs %}

```yml
models:
  - name: <model_name>
    columns:
      - name: <column_name>
        data_tests:
          - <test macro name>
```

{% endtab %}

{% tab dbt7-ctm sample: test macro %}

{: file='no_update_first_5_days.sql'}

{% raw %}

```sql
{% test no_update_first_5_days(model, column_name) %}

    with
        validation as (select {{ column_name }} as datetime_field from {{ model }}),
        validation_error as (
            select datetime_field
            from validation
            where extract(day from datetime_field) <= 5
        )

    select *
    from validation_error

{% endtest %}
```

{% endraw %}

{% endtab %}

{% tab dbt7-ctm example: configs %}

```yml
models:
  - name: calc_grades
    config:
      materialized: view
      schema: transform
    columns:
      - name: id
      - name: name
      - name: subject
      - name: grade
      - name: updated_at
        data_tests:
          - no_update_first_5_days
```

{% endtab %}

{% tab dbt7-ctm dbt test result %}

```
09:59:30  1 of 1 START test no_update_first_5_days_calc_grades_updated_at ................ [RUN]
09:59:33  1 of 1 FAIL 1 no_update_first_5_days_calc_grades_updated_at .................... [FAIL 1 in 2.86s]
09:59:33  
09:59:33  Finished running 1 test in 0 hours 0 minutes and 7.03 seconds (7.03s).
09:59:33  
09:59:33  Completed with 1 error, 0 partial successes, and 0 warnings:
09:59:33  
09:59:33  Failure in test no_update_first_5_days_calc_grades_updated_at (models/students/calc_grades.yml)
09:59:33    Got 1 result, configured to fail if != 0
09:59:33  
09:59:33    compiled code at target/compiled/dbt_proj01/models/students/calc_grades.yml/no_update_first_5_days_calc_grades_updated_at.sql
09:59:33  
09:59:33  Done. PASS=0 WARN=0 ERROR=1 SKIP=0 NO-OP=0 TOTAL=1
```

{% endtab %}

{% tab dbt7-ctm final test query %}

{: file='no_update_first_5_days_calc_grades_updated_at.sql'}

```sql
    with
        validation as (select updated_at as datetime_field from `bluebirz-playground`.`transform`.`calc_grades`),
        validation_error as (
            select datetime_field
            from validation
            where extract(day from datetime_field) <= 5
        )

    select *
    from validation_error
```

{% endtab %}

{% endtabs %}

---

## Singular tests

Singular tests[^singtest] are custom queries to verify data in our own way.

This time we are testing if there are any grade in a subject is 1 or below then display id and name of every students who have grades in the subjects.

We are writing our query `stem_under_grade_2.sql` in `tests/`{: .filepath} directory and execute `dbt test`.

{% tabs dbt7-sing %}

{% tab dbt7-sing query in tests %}

{: file='stem_under_grade_2.sql' }

{% raw %}

```sql
select id, name
from {{ ref("calc_grades") }}
where subject in ('biology', 'physics', 'computer', 'math')
qualify min(grade) over (partition by subject) <= 1
```

{% endraw %}

{% endtab %}

{% tab dbt7-sing dbt test result %}

```
12:18:55  1 of 1 START test stem_under_grade_2 ........................................... [RUN]
12:18:58  1 of 1 FAIL 3 stem_under_grade_2 ............................................... [FAIL 3 in 3.01s]
12:18:58  
12:18:58  Finished running 1 test in 0 hours 0 minutes and 6.81 seconds (6.81s).
12:18:58  
12:18:58  Completed with 1 error, 0 partial successes, and 0 warnings:
12:18:58  
12:18:58  Failure in test stem_under_grade_2 (tests/stem_under_grade_2.sql)
12:18:58    Got 3 results, configured to fail if != 0
12:18:58  
12:18:58    compiled code at target/compiled/dbt_proj01/tests/stem_under_grade_2.sql
12:18:58  
12:18:58  Done. PASS=0 WARN=0 ERROR=1 SKIP=0 NO-OP=0 TOTAL=1
```

{% endtab %}

{% tab dbt7-sing final test query %}

{: file='stem_under_grade_2.sql'}

```sql

    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  select id, name
from `bluebirz-playground`.`transform`.`calc_grades`
where subject in ('biology', 'physics', 'computer', 'math')
qualify min(grade) over (partition by subject) <= 1
  
  
      
    ) dbt_internal_test
```

{% endtab %}

{% endtabs %}

---

## Wrap up

- commands:
  - `dbt test` to execute tests.
  - `dbt build` to execute tests and build models.
- generic tests:
  - configure in YAML files; models, sources, seeds, and snapshots.
  - `not_null` to see if there are `null` values.
  - `unique` to find duplicates.
  - `relationships` to verify if value references are missing.
  - `accepted_values` to compare if values are in the specific list.
  - create custom generic tests by a new query file in `tests/generic/`{: .filepath} directory with the macro syntax {% raw %}`{% test <test_macro_name>(model, column_name) %}...{% endtest %}`{% endraw %}.
- singular tests:
  - create new query files in `tests/` directory.

---

## References

[^customgentest]: [Writing custom generic data tests \| dbt Developer Hub](https://docs.getdbt.com/best-practices/writing-custom-generic-tests)
[^singtest]: [Singular data tests \| Add data tests to your DAG \| dbt Developer Hub](https://docs.getdbt.com/docs/build/data-tests#singular-data-tests)
