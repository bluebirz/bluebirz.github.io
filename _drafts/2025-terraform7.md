---
title: "Let's try: Terraform part 7 - Locals, Data, and Outputs"
layout: post
author: bluebirz
description:
# date:
categories: []
tags: []
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

In Terraform, we may have

![image](../assets/img/features/bluebirz/IMG_6642-are.jpg){:style="max-width:75%;margin:auto;" .apply-border}

---

## locals

`locals` is an expression to define local variables[^locals].

### Syntax

```terraform
locals {
  variable_1 = "value 1"
  variable_2 = "value 2"
}

resource "resource_type" "resource_name" {
  attribute_1 = local.variable_1
  attribute_2 = local.variable_2
}
```

### Example

```terraform
variable "new_bucket_name" {
  type    = string
  default = "bluebirz-test-bucket-part7"
}

locals {
  new_bucket_name      = "${var.new_bucket_name}-new"
  existing_bucket_name = "bluebirz-beam"
}

resource "google_storage_bucket" "new_bucket" {
  name     = local.new_bucket_name
  location = "europe-west1"
}
```

---

## data

data[^data]

### Syntax

```terraform
data "data_source_type" "data_source_name" {
  attribute_1 = "value 1"
  attribute_2 = "value 2"
}
```

### Example

```terraform
data "google_storage_bucket" "existing_bucket" {
  name = local.existing_bucket_name
}
```

---

## outputs

We can use `outputs` blocks[^outputs] to display particular attributes that we `terraform apply`. It is greatly useful for reporting information of the updated infrastructure at the end of `terraform apply`.

### Syntax

```terraform
output "output_name" {
  value = resource_type.resource_name.attribute
}
```

### Example

```terraform
output "existing_bucket_name" {
  value = data.google_storage_bucket.existing_bucket.id
}

output "new_bucket_name" {
  value = google_storage_bucket.new_bucket.id
}
```

---

## References

[^data]: [Query data sources \| Terraform \| HashiCorp Developer](https://developer.hashicorp.com/terraform/tutorials/configuration-language/data-sources)
[^outputs]: [Output data from Terraform \| Terraform \| HashiCorp Developer](https://developer.hashicorp.com/terraform/tutorials/configuration-language/outputs)
[^locals]: [Simplify Terraform configuration with locals \| Terraform \| HashiCorp Developer](https://developer.hashicorp.com/terraform/tutorials/configuration-language/locals)
