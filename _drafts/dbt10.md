---
title: "Let's try: dbt part 10 - packages"
layout: post
author: bluebirz
description: 
# date: 2026-03-28
categories: [data, data engineering]
tags: [let's try, Jinja, Python, SQL, dbt]
comment: true
series:
  key: dbt
  index: 10
image:
  path: assets/img/features/external/dbt.png
  lqip: ../assets/img/features/lqip/external/dbt.webp
  alt: dbt-labs/dbt-core
  caption: <a href="https://github.com/dbt-labs/dbt-core">dbt-labs/dbt-core</a>
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

{% include bbz_custom/tabs.html %}

dbt community is one of big factors that makes developers love dbt. Now we can find third-party packages to improve productivity and development velocity.

---

## dbt packages

Packages are external dbt projects we can install into our own projects and reuse for various functionalities. Here is the dbt packages hub homepage.

{% include bbz_custom/link_preview.html url='<https://hub.getdbt.com/>' %}

And we are going to use some packages right now.

### 1. define packages

Start from creating `packages.yml`{: .filepath} as the example below.

```yaml
packages:
  - package: brooklyn-data/dbt_artifacts
    version: 2.2.2
```

### 2. install packages

Execute this command to install and update packages according to `packages.yml`{: .filepath}

```sh
dbt deps
```

---

## Wrap up

---

## References
