---
title: "Let's try: Terraform part 4 - modules"
layout: post
description: When it comes to tens or twenties or more resources to handle, it could be many tf scripts to manage.
date: 2023-05-28 00:00:00 +0200
categories: [devops, Iaac]
tags: [Terraform]
image:
  path: ../assets/img/features/external/Blueprint-of-Home.jpg
  alt: DFD HOUSE PLANS BLOG
  caption: <a href="https://www.dfdhouseplans.com/blog/category/house-plans/">DFD HOUSE PLANS BLOG</a>
---

[expand-series]

  1. [Let's try: Terraform part 1 - basic]({% post_url 2023-05-10-try-terraform-part-1 %})
  1. [Let's try: Terraform part 2 - variables]({% post_url 2023-05-13-try-terraform-part-2 %})
  1. [Let's try: Terraform part 3 - backend]({% post_url 2023-05-16-try-terraform-part-3 %})
  1. Let's try: Terraform part 4 - modules
  1. [Let's try: Terraform part 5 - import]({% post_url 2023-06-04-try-terraform-part-5 %})
  1. [Let's try: Terraform part 6 - CI/CD]({% post_url 2023-06-10-try-terraform-part-6 %})

[/expand-series]

We are at part 4 and I would expect that we know well about all `tf` scripts in the folder will be executed as we can't include nor exclude any files. But when it comes to tens or twenties or more resources to handle, it could be many `tf` scripts to manage. How should we partition them not to confuse ourselves?

Modular scheme is one of all answers. In Terraform, we can partition resources in to separated folders and include any or all of them into our main script.

---

## Benefits of modules

We can imagine of external libraries we could `import` in Python. Modules can be included anytime in Terraform in the same way. This comfort us to manage to partition sets of resources into each as we desire.

When we split the resource files into modules. Those module files can be outside the main `tf` scripts folders. After that, we need to include each module into the main script, however updating modules inclusion always requires `init` every time.

---

## Syntax

Writing a module is so easy. We just write a keyword, a source file and variables that the module needs.

```terraform
module "<module_name>" {
  source     = "<module_script_path>"
  attribute1 = value1
  attribute2 = value2 
}
```

The path of the module can be relative path e.g. "../module/folder1/folder2". This is so useful to maintain the file structures at ease.

---

## Sample structure

<script src="https://gist.github.com/bluebirz/7a960260816793a8fc49c98b6ca3f388.js?file=tree.md"></script>

I put the main script in a neighbor folder (`src`) to the module folder (`modules`) and execute the main script in the main folder (`src`). So the module folder won't be included when run.

### in the module folder

There are 2 files as follows.

First is a script for GCS buckets.

<script src="https://gist.github.com/bluebirz/7a960260816793a8fc49c98b6ca3f388.js?file=gcs.tf"></script>

Another is its variables.

<script src="https://gist.github.com/bluebirz/7a960260816793a8fc49c98b6ca3f388.js?file=module_variables.tf"></script>
in the main folder

There are backend and main script here.
<script src="https://gist.github.com/bluebirz/7a960260816793a8fc49c98b6ca3f388.js?file=main.tf"></script>

and variable declaration file.

<script src="https://gist.github.com/bluebirz/7a960260816793a8fc49c98b6ca3f388.js?file=main_variables.tf"></script>

and variable assignment file.
<script src="https://gist.github.com/bluebirz/7a960260816793a8fc49c98b6ca3f388.js?file=var-dev.tfvars"></script>

relationship diagram

So, we can see the relationship of those variables like this.

![diagram](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p4/terraform-module.drawio.png)

The value assignments are cascading from right to left in the diagram.

---

## Let's run

Once we included the module into the main script, we should find the module is imported when `init`.

![init](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p4/01-init.png){:style="max-width:75%;margin:auto;"}

And, of course, we can validate and plan before apply like this.

![plan](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p4/02-validate-plan.png){:style="max-width:75%;margin:auto;"}

---

## References

- [Pass variables values inside terraform modules](https://blog.geralexgr.com/terraform/pass-variables-values-inside-terraform-modules)
- [Modules Overview - Configuration Language \| Terraform \| HashiCorp Developer](https://developer.hashicorp.com/terraform/language/modules)
