---
title:
layout: post
author: bluebirz
description:
# date:
categories: []
tags: []
pin: true
mermaid: true
comment: true
image:
  path: https://images.unsplash.com/photo-1566725158719-2ef50641aa9d?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=2070
  lqip: https://images.unsplash.com/photo-1566725158719-2ef50641aa9d?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=10&w=490
  alt: Unsplash / Giordano Rossoni
  caption: <a href="https://unsplash.com/photos/a-spiral-staircase-in-a-building-with-graffiti-on-it-czu8X_gfpP0">Unsplash / Giordano Rossoni</a>
---

{% include bbz_custom/tabs.html %}

```sql
with recursive
  fib as (
    select 0 as idx, 0 as fib_val, 1 as next_fib_val
    union all
    select idx + 1, next_fib_val as fib_val, fib_val + next_fib_val as next_fib_val
    from fib
    where idx < 10
  )
select idx, fib_val from fib
order by idx
```

---

## References

- <https://stackoverflow.com/a/21746167>
- <https://www.linkedin.com/posts/josesilesb_a-powerful-sql-concept-you-want-in-your-pocket-activity-7386302743889494017-nZ2H?utm_source=share&utm_medium=member_desktop&rcm=ACoAABOXNNQB_VdJ9oOuXc_oLUlgjoeS6g_3fr8>
- <https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax#recursive_cte>
- <https://medium.com/@shuvro_25220/fibonacci-series-using-bigquery-recursive-cte-f8c584c5144e>
