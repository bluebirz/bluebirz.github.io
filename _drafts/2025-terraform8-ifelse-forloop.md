---
title: "Let's try: Terraform part 8 - Conditions and Repetition"
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
  index: 8
image:
  path: assets/img/features/external/Blueprint-of-Home.jpg
  lqip: ../assets/img/features/lqip/external/Blueprint-of-Home.webp
  alt: DFD HOUSE PLANS BLOG
  caption: <a href="https://www.dfdhouseplans.com/blog/category/house-plans/">DFD HOUSE PLANS BLOG</a>
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

In Terraform, one resource block basically means one object. However, like other programming languages, Terraform allow us to create resources in dynamic and flexible way. Yes, I'm talking about conditions and repetition.

![image](../assets/img/features/bluebirz/IMG_6642-are.jpg){:style="max-width:75%;margin:auto;" .apply-border}

---

## Count

In some cases, we are going to create **multiple identical** instances.

`count`[^count] is a meta-argument that allows you to create multiple instances of a resource based on a numeric value. This is useful when you want to create a fixed number of resources

This is rare for me to use `count` because I usually have to create different instances.

### Syntax

```terraform
resource "<resource_type>" "<resource_name>" {
  count = <number>
  attribute_1 = "<value>"
  attribute_2 = "<value>"
  attribute_3 = count.index
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

As above, we created `object[0]` and `object[1]` as we have `count = 2`.

---

## Condition

Sometimes we need if-else. Terraform supports ternary operator[^condition] (`?:`). I used to use it with `locals` block to define new variable based on current values.

Read more about `locals` block in [part 7 - Locals, Data, and Output]({% post_url 2025-08-17-try-terraform-part-7 %})

### Syntax

```terraform
resource "<resource_type>" "<resource_name>" {
  count = <condition> ? "<true_value>" : "<false_value>"
  attribute_1 = "<value>"
  attribute_2 = "<value>"
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
  bucket  = google_storage_bucket.bucket.name
  content = local.target_file.content
}
```

Line 6, we defined default value of the variable as `null` and line 10, if the variable is `null` then we assign `target_file` with new populated values.  

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
```

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

If the variable is a set (a.k.a. a list e.g. `[1,2,3]`), we can access the element via either `each.key` or `each.value`.

If the variable is a map (e.g. `[ first = {name = "1"}, second = {name = "2"}]`), we can access the key via `each.key` and we will get `first`, `second` while the value can access via `each.value` then we can get `{name = "1"}` and `{name = "2"}` respectively.

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

```text
  # google_storage_bucket_object.object["file1"] will be created
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
      + name           = "file1.txt"
      + output_name    = (known after apply)
      + self_link      = (known after apply)
      + storage_class  = (known after apply)
    }

  # google_storage_bucket_object.object["file2"] will be created
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
      + name           = "file2.txt"
      + output_name    = (known after apply)
      + self_link      = (known after apply)
      + storage_class  = (known after apply)
    }

```

---

## References

[^foreach]: [The for_each Meta-Argument - Configuration Language \| Terraform \| HashiCorp Developer](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)
[^count]: [The count Meta-Argument - Configuration Language \| Terraform \| HashiCorp Developer](https://developer.hashicorp.com/terraform/language/meta-arguments/count)
[^condition]: [Conditional Expressions - Configuration Language \| Terraform \| HashiCorp Developer](https://developer.hashicorp.com/terraform/language/expressions/conditionals)
