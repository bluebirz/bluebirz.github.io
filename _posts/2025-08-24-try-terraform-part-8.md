---
title: "Let's try: Terraform part 8 - Conditions and Repetition"
layout: post
author: bluebirz
description: We can use if-else and for-loop in Terraform with these syntax.
date: 2025-08-24
categories: [devops, IaaC]
tags: [Terraform, let's try]
comment: true
series:
  key: terraform
  index: 8
image:
  path: assets/img/features/external/Blueprint-of-Home.jpg
  lqip: ../assets/img/features/lqip/external/Blueprint-of-Home.webp
  alt: DFD HOUSE PLANS BLOG
  caption: <a href="https://www.dfdhouseplans.com/blog/category/house-plans/">DFD HOUSE PLANS BLOG</a>
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

In Terraform, one resource block basically means one object. However, like other programming languages, Terraform allow us to create resources in dynamic and flexible way. Yes, I'm talking about conditions and repetition.

---

## Count

In some cases, we are going to create **multiple identical** instances.

`count`[^count] is a meta-argument that allows you to create multiple instances of a resource based on a numeric value. This is useful when you want to create a fixed number of resources.

This is rare for me to use `count` because I usually have to create different instances.

### Syntax

```terraform
resource "<resource_type>" "<resource_name>" {
  count = <number>
  attribute_1 = "<value>"
  attribute_2 = "<value>"
  attribute_3 = "${count.index}"
  ...
}
```

If needed, we can use `count.index` to get the index of each instance, starting from 0.

### Example

```terraform
resource "google_storage_bucket_object" "object" {
  count   = 2
  name    = uuid()
  bucket  = google_storage_bucket.bucket.name
  content = "This is a test object in the bucket."
}
```

This resource is an object in Google Cloud Storage. I want to make the object by 2 (`count = 2`) and give the name by auto-generated UUID (`name = uuid()`).

After we `apply` it, there will be an array of `google_storage_bucket_object` according to the resource block we defined with `count`.

```sh
$ tf state list

google_storage_bucket.bucket
google_storage_bucket_object.object[0]
google_storage_bucket_object.object[1]
```

As above, we created `object[0]` and `object[1]` from `count = 2`.

---

## Condition

Sometimes we need if-else. Terraform supports ternary operator[^condition] (`?:`). I used to use it with `locals` block to define new variable based on specific conditions.

Read more about `locals` block in [part 7 - Locals, Data, and Output]({% post_url 2025-08-17-try-terraform-part-7 %}).

### Syntax

We can use `locals` to store new values from conditions.

```terraform

locals {
  new_variable = <condition> ? "<true_value>" : "<false_value>"
}

resource "<resource_type>" "<resource_name>" {
  attribute_1 = local.new_variable.value_1
  attribute_2 = local.new_variable.value_2
  ...
}
```

Or just assign values after conditions one by one.

```terraform
resource "<resource_type>" "<resource_name>" {
  attribute_1 = <condition> ? "<true_value_1>" : "<false_value_1>"
  attribute_2 = <condition> ? "<true_value_2>" : "<false_value_2>"
  ...
}
```

### Example

```terraform
variable "object_spec" {
  type = object({
    name    = string
    content = string
  })
  default = null
}

locals {
  target_file = var.object_spec == null ? { name = "default.txt", content = "Default content" } : var.object_spec
}

resource "google_storage_bucket_object" "object" {
  name    = local.target_file.name
  content = local.target_file.content
  bucket  = google_storage_bucket.bucket.name
}

resource "google_storage_bucket_object" "object_2" {
  name    = var.object_spec == null ? "special-file.txt" : var.object_spec.name
  content = var.object_spec == null ? "This is a special file" : var.object_spec.content
  bucket  = google_storage_bucket.bucket.name
}
```

At line 6, we defined default value of the variable as `null`.

At line 10 in resource "object", when the variable's value is `null` then we assign `local.target_file` with new populated values.  

At line 20-21 of resource "object_2", when the variable is `null` then we assign the attributes one by one.

When we run `terraform plan` without any variables, we will have the resource with that populated values.

```text
  # google_storage_bucket_object.object will be created
  + resource "google_storage_bucket_object" "object" {
      + bucket         = "bluebirz-test-bucket"
      + content        = (sensitive value)
      + content_type   = (known after apply)
      + crc32c         = (known after apply)
      + detect_md5hash = "different hash"
      + id             = (known after apply)
      + kms_key_name   = (known after apply)
      + md5hash        = (known after apply)
      + media_link     = (known after apply)
      + name           = "default.txt"
      + output_name    = (known after apply)
      + self_link      = (known after apply)
      + storage_class  = (known after apply)
    }

  # google_storage_bucket_object.object_2 will be created
  + resource "google_storage_bucket_object" "object_2" {
      + bucket         = "bluebirz-test-bucket"
      + content        = (sensitive value)
      + content_type   = (known after apply)
      + crc32c         = (known after apply)
      + detect_md5hash = "different hash"
      + id             = (known after apply)
      + kms_key_name   = (known after apply)
      + md5hash        = (known after apply)
      + media_link     = (known after apply)
      + name           = "special-file.txt"
      + output_name    = (known after apply)
      + self_link      = (known after apply)
      + storage_class  = (known after apply)
    }
```

Look at the output above, line 12 shows the filename of "object" as "default.txt". And line 29 shows "object_2" filename as "special-file.txt".

---

## For-each

When it comes to multiple instances, `for_each`[^foreach] is the meta-argument I use very often. Because of the similarity to dictionary in Python, we just access it via `each.key` and `each.value`.

### Syntax

```terraform
resource "<resource_type>" "<resource_name>" {
  for_each = "<variable in set or map>"
  attribute_1 = each.key
  attribute_2 = each.value
  ...
}
```

If the variable is **a set** (e.g. `[ 1, 2, 3 ]`), we can access the element via either `each.key` or `each.value` because both are the same in value.

If the variable is **a map** (e.g. `[ first = {name = "1"}, second = {name = "2"} ]`), we can access the key via `each.key` and we will get `first` and `second`. And the value can access via `each.value` then we can get `{name = "1"}` and `{name = "2"}` respectively.

### Example

```terraform
variable "object_spec_foreach" {
  type = map(object({
    name    = string
    content = string
  }))
  default = {
    file1 = {
      name    = "file1.txt"
      content = "This is file 1"
    },
    file2 = {
      name    = "file2.txt"
      content = "This is file 2"
    }
  }
}

resource "google_storage_bucket_object" "object" {
  for_each = var.object_spec_foreach
  name     = each.value.name
  bucket   = google_storage_bucket.bucket.name
  content  = each.value.content
}
```

As above, we have default value by 2 elements; `file1` (line 7) and `file2` (line 11). When we apply `for_each` over it, we will have 2 instances in an array of `google_storage_bucket_object.object` having keys `file1` and `file2` from the key name in that map.

After we run `terraform apply` and check the state, we will see:

```text
$ tf state list

google_storage_bucket.bucket
google_storage_bucket_object.object["file1"]
google_storage_bucket_object.object["file2"]
```

We can see that `google_storage_bucket_object.object` has key names according to `each.key` we previously defined in the variable block.

---

## Repo

Here I saved the scripts in one place.

{% include bbz_custom/link_preview.html url='<https://github.com/bluebirz/sample-terraform/tree/main/part-8-count-condition-for_each>' %}

---

## References

[^foreach]: [The for_each Meta-Argument - Configuration Language \| Terraform \| HashiCorp Developer](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)
[^count]: [The count Meta-Argument - Configuration Language \| Terraform \| HashiCorp Developer](https://developer.hashicorp.com/terraform/language/meta-arguments/count)
[^condition]: [Conditional Expressions - Configuration Language \| Terraform \| HashiCorp Developer](https://developer.hashicorp.com/terraform/language/expressions/conditionals)
