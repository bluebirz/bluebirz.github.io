---
title: "Let's try: Terraform part 5 - import"
layout: post
author: bluebirz
description: What to do if we want to develop the tf scripts on the existing resources?
date: 2023-06-04 00:00:00 +0200
categories: [devops, IaaC]
tags: [Terraform, let's try]
series:
  key: terraform
  index: 5
comment: true
image:
  path: ../assets/img/features/external/Blueprint-of-Home.jpg
  alt: DFD HOUSE PLANS BLOG
  caption: <a href="https://www.dfdhouseplans.com/blog/category/house-plans/">DFD HOUSE PLANS BLOG</a>
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

Come to see again at part 5. All 4 parts is about creating a new resource and developing in `tf` scripts.

The next question is, what to do if we want to develop the `tf` scripts on the existing resources?

---

## Import an existing resource

esources before/without maintaining in our Terraform stacks. Don't worry, we can enlist them into. This is called Terraform import.

Terraform import can only importing resources' states into our state file, so we have to update the `tf` scripts ourselves which is not quite a big deal.

![diagram](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p5/Terraform.drawio.png)

Let's say, we created two buckets manually like this.

![bucket](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p5/01-manual-create-buckets.png){:style="max-width:75%;margin:auto;"}

There are 2 choices to import a resource into Terraform depends on how we currently design and manage the scripts.

1. import into main scripts.
1. import into modules.

---

## resource in main scripts

If we go easy by writting resources in a single main folder, now we can do the following steps.

1. Prepare an empty resource
1. Import the state by referring the resource
1. Show the state and update in `tf` scripts
1. Verify `tf` scripts

### 1. Prepare an empty resource

<script src="https://gist.github.com/bluebirz/e8ddb289d8d5cf5a175e1727cbaf0497.js?file=main-before.tf"></script>

### 2. import the state to the resource

Run the command.

```sh
terraform import -var-file="<var-file>" \
    '<resource_type>.<resource_name>' <resource_address>
```

- `var-file` is for when we are using variables in the scripts, or Terraform will ask for the values.
- `Resource type` and **name** are what we define in the tf script.
- `Resource address` can be generated in the format given in Terraform registry.  
  For this case, GCS bucket's address format is [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket#import) which is `<project_name>/<bucket_name>` or just `bucket_name`.

![import](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p5/02-import-bucket-main.png){:style="max-width:75%;margin:auto;"}

### 3. Show state and update scripts

Once the import is done successfully. We can list and see its configurations.

```terraform
terraform state list
terraform state show <state_name>
```

![state show](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p5/03-show-bucket-main.png){:style="max-width:75%;margin:auto;"}

Then copy the config into the resource block.

<script src="https://gist.github.com/bluebirz/e8ddb289d8d5cf5a175e1727cbaf0497.js?file=main-after.tf"></script>

### 4. Verify scripts

Then we can `plan` to see any missing between state and scripts.

![plan](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p5/04-plan-error-copy-whole.png){:style="max-width:75%;margin:auto;"}

Oops! we got errors. There we can see unconfigurable attributes for `self_link`, `url` and `id` is invalid key. These are attributes we don't need in the resource block so we delete them out.

<script src="https://gist.github.com/bluebirz/e8ddb289d8d5cf5a175e1727cbaf0497.js?file=main-after-fix.tf"></script>

Try `plan` again and yes we did it. It says no change now.

![plan again](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p5/05-plan-fix-error.png){:style="max-width:75%;margin:auto;"}

---

## resource in modules

### 1. Prepare an empty resource

We can prepare a module resource like this.

<script src="https://gist.github.com/bluebirz/e8ddb289d8d5cf5a175e1727cbaf0497.js?file=module-gcs-before.tf"></script>

and include it into the main script as follow.

<script src="https://gist.github.com/bluebirz/e8ddb289d8d5cf5a175e1727cbaf0497.js?file=main-module.tf"></script>

### 2. import the state to the resource

When it comes to modules, we just change a bit on the command here.

```terraform
terraform import -var-file="<var-file>" \
    'module.<module_name>.<resource_type>.<resource_name>' <resource_address>
```

In this case:

- `module_name` is "bucket" as defined in the main script
- `resource_type` is "google_cloud_storage_bucket" as defined in the module
- `resource_name` is "bucket_in_module" as it is in the module as well

And it should show that the module's resource has been imported successfully, like this.

![import resource](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p5/06-import-bucket-module.png){:style="max-width:75%;margin:auto;"}

When list the state, we can see the module's state there.

### 3. Show state and update scripts

Then show the module's state.

```terraform
terraform state list
terraform state show <state_name>
```

![state show](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p5/07-show-bucket-module.png){:style="max-width:75%;margin:auto;"}

and copy into the resource block in the module.

<script src="https://gist.github.com/bluebirz/e8ddb289d8d5cf5a175e1727cbaf0497.js?file=module-gcs-updated.tf"></script>

### 4. Verify scripts

Finally try `plan` to see "no change" and that's mean we're done now.

![plan](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p5/08-plan-after-import.png){:style="max-width:75%;margin:auto;"}

---

## Update state

Say we have manually updated some configs on the existing resources we have in Terraform state. For example, I changed my bucket class from "STANDARD" to "NEARLINE".

![gcs class](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p5/09-change-class.png){:style="max-width:75%;margin:auto;"}

Only the bucket "bluebirz-manual-create-bucket-for_main" has been changed for the bucket class.

![updated class](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p5/10-all-buckets.png){:style="max-width:75%;margin:auto;"}

Fortunately, we have the state of this resource. Life is easier as we just update the state of this bucket using the command.

```sh
terraform apply -var-file="<var-file>" -refresh-only -auto-approve
```

Terraform will fetch and update the latest configurations to be matched between the state file and the cloud provider.

![update state](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p5/11-apply-refresh.png){:style="max-width:75%;margin:auto;"}

We can see what's been changed in the output of the command. And we have to update our scripts as well for those changed configs.
