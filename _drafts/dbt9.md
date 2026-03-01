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

Variables bring flexibility to our pipelines. Let's see how to deploy and utilize variables in dbt.

---

## Define variables

---

## Wrap up

- `dbt ls` to list models
- `--select` to select models
- `--exclude` to exclude models
- selection flags can be use with `ls`, `compile`, `run`, `build`, `test`, etc.
- `+` to extend the model selection
- `@` to select whole relationship from the selected models, including all ancestors, descendants, and dependencies.
- `dbt docs generate` and `dbt docs serve` to create and view docs.

---

## References

- [Node selection \| Syntax overview \| dbt Developer Hub](https://docs.getdbt.com/reference/node-selection/syntax)
- [About dbt docs commands \| dbt Developer Hub](https://docs.getdbt.com/reference/commands/cmd-docs)
