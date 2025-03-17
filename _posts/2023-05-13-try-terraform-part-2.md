---
title: "Let's try: Terraform part 2 - variables"
layout: post
author: bluebirz
description: Terraform supports variable assignment in their way. Let's see how.
date: 2023-05-13
categories: [devops, IaaC]
tags: [Terraform, VSCode, let's try]
series:
  key: terraform
  index: 2
comment: true
image:
  path: assets/img/features/external/Blueprint-of-Home.jpg
  alt: DFD HOUSE PLANS BLOG
  caption: <a href="https://www.dfdhouseplans.com/blog/category/house-plans/">DFD HOUSE PLANS BLOG</a>
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

We come in this part 2 and we are going to discuss about Terraform variables. Terraform supports variable assignment in their way. Let's see how.

---

## Declarations

### Declare a variable

We usually declare a Terraform variable  in this format.

```terraform
variable "<name>" {
  type    = <type>
  default = <default_value>
}
```

`type` and `default` are frequently used attributes. For other attributes. Please visit the link below for more info.

{% include bbz_custom/link_preview.html url='<https://developer.hashicorp.com/terraform/language/values/variables>' %}

### Assign a value to a variable

Then we can assign a value to a variable using this simple syntax.

```terraform
<name> = <value>
```

### Assign a variable to a resource

Then we can assign a variable to an attribute of a resource using var. followed by the variable name, like this.

```terraform
resource "resource_A" "resource_name_A" {
  attribute_1 = var.<variable_name_1>
  attribute_2 = var.<variable_name_2>
}
```

### VSCode Plugin

This will be more useful when we develop a Terraform script with a good IDE and a good plugin. For me, I would love to share this plugin for VSCode and we can write a lot faster with its auto-complete on variable assignment.

{% include bbz_custom/link_preview.html url='<https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform>' %}

And the auto-complete will be ready like this.

![plugin](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p2/01-auto-complete.png){:style="max-width:75%;margin:auto;"}{:style="max-width:75%;margin:auto;"}

---

## Files pattern

We can write all in a single file but I suggest to split the files into this. It would be useful when we have multiple sets of variable, multiple environments.

```
.
├── main.tf
├── variables.tf
└── var-dev.vars
```

- `main.tf` is our first `tf` script.
- `variables.tf` is the variable declaration file.
- `var-dev.vars` is the variable assignment file.  
  As aforementioned, name can be anything also the extention. We can name it `dev.tfvars` or something else, just make sure the contents inside is according to the variable assignment syntax above. However, I recommend to have `.tfvars` so the plugin can work perfectly, but not this time ;P

And here are the sample files.

### main.tf

<script src="https://gist.github.com/bluebirz/04e9663fc3e41dc47e514cd8954566b7.js?file=main.tf"></script>

### variables.tf

<script src="https://gist.github.com/bluebirz/04e9663fc3e41dc47e514cd8954566b7.js?file=variables.tf"></script>

### var-dev.vars

<script src="https://gist.github.com/bluebirz/04e9663fc3e41dc47e514cd8954566b7.js?file=var-dev.vars"></script>

---

## Executions

Now our files are ready there. Let's go to the execution part.

### Plan

Say validation completes and to plan, if we run this.

```sh
terraform plan
```

Terraform could detect there are variables in the script and ask us the values. Like this.

![plan](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p2/02-plan-no-file.png){:style="max-width:75%;margin:auto;"}

Because we have variable file now we can input the file using this command.

```sh
terraform plan -var-file=<filepath>
```

![plan with vars](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p2/03-plan-with-file.png){:style="max-width:75%;margin:auto;"}

### Apply

Everything is fine so we can apply with the variable file and force approval.

```sh
terraform apply -var-file=<filepath> -auto-approve
```

![apply](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p2/04-apply-with-file.png){:style="max-width:75%;margin:auto;"}

### Destroy

Cleanup the resouce with the command.

```sh
terraform destroy -var-file=<filepath> -auto-approve
```

![destroy](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p2/05-destroy-with-file.png){:style="max-width:75%;margin:auto;"}

---

Now we can customize the variables into our use cases.
