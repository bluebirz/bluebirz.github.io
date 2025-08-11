---
title: "Let's try: Terraform part 7 - Conditions and Repetition"
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

Like other programming languages, Terraform allow us to create resources in dynamic and flexible way. Yes, I'm talking about conditions and repetition.

## h2

![image](../assets/img/features/bluebirz/IMG_6642-are.jpg){:style="max-width:75%;margin:auto;" .apply-border}

---

## Repeat

In some cases, we are going to create multiple identical instances

`count` is a meta-argument that allows you to create multiple instances of a resource based on a numeric value. This is useful when you want to create a fixed number of resources

---

## Condition

---

## Loop

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
