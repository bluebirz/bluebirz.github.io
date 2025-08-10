---
title: "Let's try: Terraform part 7 - Conditions and Iterations"
layout: post
author: bluebirz
description:
# date:
categories: []
tags: []
mermaid: false
comment: true
series:
  key: terraform
  index: 7
image:
  path: assets/img/features/external/Blueprint-of-Home.jpg
  lqip: ../assets/img/features/lqip/external/Blueprint-of-Home.webp
  alt: DFD HOUSE PLANS BLOG
  caption: <a href="https://www.dfdhouseplans.com/blog/category/house-plans/">DFD HOUSE PLANS BLOG</a>
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

When it comes to programming, it can save us for scaling problems. Terraform allows us to operate cloud services in bulk.

## h2

![image](../assets/img/features/bluebirz/IMG_6642-are.jpg){:style="max-width:75%;margin:auto;" .apply-border}

---

## Syntax

```terraform
resource "<resource_type>" "<resource_name>" {
  for_each = "<variable in set or map>"
  attribute_1 = each.key
  attribute_2 = each.value
  ...
}
```

---

#### h4

<https://developer.hashicorp.com/terraform/language/meta-arguments/for_each>
