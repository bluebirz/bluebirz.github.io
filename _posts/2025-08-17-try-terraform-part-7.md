---
title: "Let's try: Terraform part 7 - Locals, Data, and Output"
layout: post
author: bluebirz
description: These Terraform blocks can improve readability of our configurations.
date: 2025-08-17
categories: [devops, IaaC]
tags: [Terraform, Google Cloud Platform, Google Cloud Storage, Google Cloud Project, let's try]
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

In Terraform, we may have a situation to blend variables for example I want to put prefixes in BigQuery table names and comply project id as a suffix in every bucket names. Here we can use these blocks to make the configurations better with readability and flexible.

---

## locals

`locals`[^locals] is an expression to define local variables. Even though we don't have to use `locals` because we can define all variables in "tfvars" files but it's useful in some advance expressions and reusability in the same file.

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

When we declare `locals` block, we can refer to any variables in it by `local.variable_name`.

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

As above, after I declared `locals` for 2 bucket names, one is a concatenated string (with variable reference as `${...}`) and another is a plain string, I referred the first one in the resource block as `name = locals.new_bucket_name`.

---

## data

`data`[^data] blocks are for querying values from **existing** resources but **out of the Terraform** configuration. It is useful in the case we want to grab some values to be references somewhere in our configs.

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

data "google_project" "gcp_project" {

}
```

After `terraform apply`, this `data.google_storage_bucket.existing_bucket` will have all attribute of the existing bucket `bluebirz-beam`. Then we can make some uses of it later.

In case we need the current GCP project information, we can use `data` block for `google_project`.

We can find the reference of data source block of Google Cloud Storage bucket [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/storage_bucket) and data source block of Google project [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) as well.

---

## output

We can use `output`[^output] blocks to display particular attributes that we run `terraform apply`. It is much useful for reporting information of the updated infrastructure at the end of `terraform apply`.

### Syntax

```terraform
output "output_name" {
  value = resource_type.resource_name.attribute
}
```

### Example

```terraform
output "existing_bucket_id" {
  value = data.google_storage_bucket.existing_bucket.id
}

output "new_bucket_id" {
  value = google_storage_bucket.new_bucket.id
}

output "gcp_project_id" {
  value = data.google_project.gcp_project.project_id
}
```

There are 3 `output` blocks. First is the id of existing bucket we queried from a `data` block. Second is the bucket id we just created in `resource` block. And last one is the project id.

After `terraform apply`, we can see the outputs like this.

```text
Outputs:

existing_bucket_id = "bluebirz-beam"
gcp_project_id = "bluebirz-playground"
new_bucket_id = "bluebirz-test-bucket-part7-new"
```

---

## References

[^data]: [Query data sources \| Terraform \| HashiCorp Developer](https://developer.hashicorp.com/terraform/tutorials/configuration-language/data-sources)
[^output]: [Output data from Terraform \| Terraform \| HashiCorp Developer](https://developer.hashicorp.com/terraform/tutorials/configuration-language/outputs)
[^locals]: [Simplify Terraform configuration with locals \| Terraform \| HashiCorp Developer](https://developer.hashicorp.com/terraform/tutorials/configuration-language/locals)
