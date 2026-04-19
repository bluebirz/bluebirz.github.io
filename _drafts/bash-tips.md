---
title:
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
#   custom_badge: 1
image:
  # path: assets/img/features/
  path: https://images.unsplash.com/photo-1695313129813-6a10cdcbb2f4?q=80&w=1631&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1695313129813-6a10cdcbb2f4?q=10&w=490&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Natalia Gasiorowska
  caption: <a href="https://unsplash.com/photos/a-pencil-drawing-of-a-ball-and-a-pencil-rOVY9FD4G_Q">Unsplash / Natalia Gasiorowska</a>
# media_dir: https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-dbt/dbt8/
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

{% include bbz_custom/tabs.html %}

{% include bbz_custom/styling-columns.html %}

---

bash array

```sh
for i in "${array[@]}"; do
  echo $i
done;
```

```sh
total_elem="${#array[@]}"
for index in "${!array[@]}"; do
  echo "$((index+1)) is ${array[i]}"
done;
```

```sh

```
