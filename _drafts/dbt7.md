---
title: "Let's try: dbt part 7 - tests"
layout: post
author: bluebirz
description:
# date: 
categories: [data, data engineering]
tags: [let's try, Python, dbt, SQL, Jinja]
comment: true
series:
  key: dbt
  index: 7
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

## Test

## Generic test

Generic tests
May be known as schema tests.
Predefined tests such as unique, not_null, accepted_values, relationships and more.
We can configure these tests in a YAML file.
Singular tests
May be known as data tests.
Custom SQL select statements that return zero rows to pass the tests.
We can create singular tests in SQL file inside the tests directory.
