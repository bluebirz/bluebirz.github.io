---
title: "Let's try: Terraform part 3 - backend"
layout: post
description: Terraform also provides us to manage multiple states.
date: 2023-05-16 00:00:00 +0200
categories: [devops, IaaC, let's try]
tags: [Terraform, Google Cloud Platform, Google Cloud Storage]
image:
  path: ../assets/img/features/external/Blueprint-of-Home.jpg
  alt: DFD HOUSE PLANS BLOG
  caption: <a href="https://www.dfdhouseplans.com/blog/category/house-plans/">DFD HOUSE PLANS BLOG</a>
---

[expand-series]

  1. [Let's try: Terraform part 1 - basic]({% post_url 2023-05-10-try-terraform-part-1 %})
  1. [Let's try: Terraform part 2 - variables]({% post_url 2023-05-13-try-terraform-part-2 %})
  1. Let's try: Terraform part 3 - backend
  1. [Let's try: Terraform part 4 - modules]({% post_url 2023-05-28-try-terraform-part-4 %})
  1. [Let's try: Terraform part 5 - import]({% post_url 2023-06-04-try-terraform-part-5 %})
  1. [Let's try: Terraform part 6 - CI/CD]({% post_url 2023-06-10-try-terraform-part-6 %})

[/expand-series]

When it comes to real-world situation, we have multiple environments. Beside the variable files we talked in the last blog, Terraform also provides us to manage multiple states. First it doesn't mean multiple state files in the same folder or something along those lines, but the multiple storage for each state file. This is called "Backend".

**Backend for Terraform defines the place we keep the state files**. By default it is the local storage, our harddrives. Terraform supports on-cloud solution for this scenario. Today we're gonna use of course Google Cloud Storage.

For all available solutions please check the doc at [this link](https://developer.hashicorp.com/terraform/language/settings/backends/gcs).

---

## Syntax

The keyword of this is backend and we can define it to use Google Cloud Storage as a backend like this.

```terraform
terraform {
  backend "gcs" {
    bucket = "<bucket_name>"
    prefix = "<path_prefix>"
  }
}
```

Different backend requires different attributes that we can check on the doc above.

We need to create that bucket first, Terraform can use it to store the state files there.

---

## Set the ball rolling

Now let's see how we can make it in real case.

### Create "backend.tf"

We will create a new file for the backend.

<script src="https://gist.github.com/bluebirz/18d2776ce67e82a9462eb6e2cf5ed6d6.js"></script>

This means our state files will be in "gs://bluebirz-terraform-backend-bucket/terraform/state/".

### Init

If we `terraform init` successfully we can see the message of backend "gcs" showing.

![init](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p3/01-init.png){:style="max-width:75%;margin:auto;"}

Otherwise, we need to re-initial. It could happen from changing backend after first initialization.

![reinit](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p3/02-init-fail.png){:style="max-width:75%;margin:auto;"}

### Apply

Assume `validate` and `plan` are done completely, we can apply the changes.

![apply](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p3/03-apply.png){:style="max-width:75%;margin:auto;"}

And see the result. There should be a new bucket from our `tf` script.

![result](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p3/04-buckets.png){:style="max-width:75%;margin:auto;"}

We can see the state file in the backend bucket have a state of the resource we create which is the new bucket, "bluebirz_bucket_test1". Terraform just move the state file from local to the bucket we defined.

![gsutil cat](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p3/05-cat-state.png){:style="max-width:75%;margin:auto;"}

---

## Same backend, different script

For some cases, if we have other `tf` scripts but use the same backend, it means we are changing the existing resources instead of create a new one.

For example, I create a new folder named "another_folder" and `init`.

![init new folder](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p3/06-same-backend-new-tf.png){:style="max-width:75%;margin:auto;"}

Also prepare the `tf` scripts there. However the scripts are changed for only the bucket name from "bluebirz_bucket_test1" to "bluebirz_bucket_test2". You can see the `plan` showing the existing bucket will be replaced instead of being created.

![validate new folder](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p3/07-same-backend-plan.png){:style="max-width:75%;margin:auto;"}

---

We can apply this scenario for our work in order to efficiently manage the services and infrastures in various environments.
