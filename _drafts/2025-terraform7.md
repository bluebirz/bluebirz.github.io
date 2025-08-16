---
title: "Let's try: Terraform part 7 - Locals, Data, and Outputs"
layout: post
author: bluebirz
description:
# date:
categories: []
tags: []
pin: false
math: false
mermaid: false
comment: true
series:
  key: asd
  index: 1
image:
  path: assets/img/features/
  lqip:
  alt: Unsplash /
  caption: <a href="">Unsplash / </a>
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

## h2

![image](../assets/img/features/bluebirz/IMG_6642-are.jpg){:style="max-width:75%;margin:auto;" .apply-border}

---

## locals

`locals` is an expression to define local variables.

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

```terraform
data "data_source_type" "data_source_name" {
  attribute_1 = "value 1"
  attribute_2 = "value 2"
}
```

```terraform
data "google_storage_bucket" "existing_bucket" {
  name = local.existing_bucket_name
}
```

---

## outputs

```terraform
output "output_name" {
  value = resource_type.resource_name.attribute
}
```

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

- <https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/storage_bucket>
- <https://developer.hashicorp.com/terraform/tutorials/configuration-language/data-sources>
