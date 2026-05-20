---
title: Work with files in Terraform
layout: post
author: bluebirz
description: Here are two handy functions to interact with files in Terraform.
date: 2026-05-20
categories: [devops, IaaC]
tags: [Terraform, file operations]
comment: true
image:
  path: https://images.unsplash.com/photo-1563602743113-f340685662a1?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1563602743113-f340685662a1?q=10&w=490&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Elaine Baran
  caption: <a href="https://unsplash.com/photos/person-holding-paper-yXVSWH8hx6A">Unsplash / Elaine Baran</a>
---

Terraform supports file system and we can read file contents and parse to an attribute in order to organize files in the better way.

Here are two handy functions to interact with files in Terraform.

---

## `file()`

The function [`file()`](https://developer.hashicorp.com/terraform/language/functions/file) in Terraform allows a single file to be read as a plain string.

For example, we want a new authorized view on Google BigQuery and the SQL is stored in a file.

### Reference file

The file could be just a simple SQL like this.

{: file="sample_query.sql"}

```sql
select 1 as id
union all
select 2 as id
```

### Terraform file

In Terraform, we can add the file reference as below.

```terraform
resource "google_bigquery_table" "sample_view" {
  dataset_id = var.dataset
  table_id   = var.table
  view {
    use_legacy_sql = false
    query          = file("${path.module}/sample_query.sql") # file reference
  }
}
```

> `${path.module}` returns the path of the current "module", which in this case it'd be current folder of this terraform resource file.
> Read more at [Filesystem and Workspace Info](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info).
{: .prompt-tip }

### Plan result

Terraform will read the file and stream to a string correctly.

```text
Terraform will perform the following actions:

  # google_bigquery_table.sample_view will be created
  + resource "google_bigquery_table" "sample_view" {
      ...

      + view {
          + query          = <<-EOT
                select 1 as id
                union all
                select 2 as id
            EOT
          + use_legacy_sql = false
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

> `EOT` stands for "End of Transmission". This is a character to indicate the end of message.  
> `<<-EOT` implies that starting here until found `EOT` and call it a block of message.
{: .prompt-tip }

---

## `templatefile()`

Similar to `file()` function above, this function [`templatefile()`](https://developer.hashicorp.com/terraform/language/functions/templatefile) reads files and also substitutes values. It's very useful for a flexible design when we want to reuse assets multiple times.

### Reference file

For example, the query requires several variables. We put each of them in format `${<variable_name>}`.

{: file="sample_querytemplate.sql.tmpl"}

```
select id, name 
from `${project_id}.${dataset_id}.${table_id}` 
where id in ${id_filter_list}
```

The template file syntax needs to follow [Terraform string template](https://developer.hashicorp.com/terraform/language/expressions/strings). There are variables (`${...}`), if-statements (`%{if ...}/%{else}/%{endif}`), or for-loop (`%{for ... in ...}/%{endfor}`) allowed.

### Terraform file

In Terraform, using function `templatefile("<filepath>", "<map of variables>")` as below.

```terraform
resource "google_bigquery_table" "sample_view" {
  dataset_id = var.dataset
  table_id   = var.table
  view {
    use_legacy_sql = false
    query = templatefile("${path.module}/sample_querytemplate.sql.tmpl", {
      project_id     = "test_project",
      dataset_id     = "test_dataset",
      table_id       = "test_table",
      id_filter_list = jsonencode([1, 2, 3])
    })
  }
}
```

> [`jsonencode()`](https://developer.hashicorp.com/terraform/language/functions/jsonencode) returns JSON format of the parameter. In this case it will be a string "[1, 2, 3]" instead of an array [1, 2, 3].
{: .prompt-tip }

### Plan result

When `plan` we can see the results as expected. All variables have been compiled properly.

```text
Terraform will perform the following actions:

  # google_bigquery_table.sample_view will be created
  + resource "google_bigquery_table" "sample_view" {
      ...

      + view {
          + query          = <<-EOT
                select id, name 
                from `test_project.test_dataset.test_table` 
                where id in [1,2,3]
            EOT
          + use_legacy_sql = false
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

---

These functions `file()` and `templatefile()` are very convenient when dealing with various file types plus we can improve file structure and decouple with the functions.

---

## References

- [file - Functions - Configuration Language \| Terraform \| HashiCorp Developer](https://developer.hashicorp.com/terraform/language/functions/file)
- [templatefile - Functions - Configuration Language \| Terraform \| HashiCorp Developer](https://developer.hashicorp.com/terraform/language/functions/templatefile)
- [Filesystem and Workspace Info \| References to Values - Configuration Language \| Terraform \| HashiCorp Developer](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)
- [jsonencode - Functions - Configuration Language \| Terraform \| HashiCorp Developer](https://developer.hashicorp.com/terraform/language/functions/jsonencode)
- [Strings and Templates - Configuration Language \| Terraform \| HashiCorp Developer](https://developer.hashicorp.com/terraform/language/expressions/strings)
- [End-of-Transmission character - Wikipedia](https://en.wikipedia.org/wiki/End-of-Transmission_character)
- [google_bigquery_table \| Resources \| hashicorp/google \| Terraform \| Terraform Registry](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_tablehttps://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_table)
