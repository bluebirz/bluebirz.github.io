---
title: "Let's try: Terraform part 6 - CI/CD"
layout: post
author: bluebirz
description: We're gonna wrap up all basic part 1 to 5 and make it automated by using our CI/CD tool, Google Cloud Build
date: 2023-06-10
categories: [devops, IaaC]
tags: [Terraform, let's try]
series:
  key: terraform
  index: 6
comment: true
image:
  path: assets/img/features/external/Blueprint-of-Home.jpg
  alt: DFD HOUSE PLANS BLOG
  caption: <a href="https://www.dfdhouseplans.com/blog/category/house-plans/">DFD HOUSE PLANS BLOG</a>
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

In this blog we're gonna wrap up all basic part 1 to 5 and make it automated by using our CI/CD tool, Google Cloud Build

If you want to understand what is Google Cloud Build and CI/CD, feel free to follow this link.

{% include bbz_custom/link_preview.html post='2023-04-25-automate-your-project-with-gcb' %}

---

## File structures

Ok, we would reuse the files from the latest blog and have them in this structure.

<script src="https://gist.github.com/bluebirz/3256d7965890fabc5d4cacc3823e75f9.js?file=tree.md"></script>

- folder "modules" has only GCS module and its variables
- folder "src", we split into backend, main, provider, and variables file
- folder "variables", we split variables into 2 files; GCS as "gcs-dev.tfvars" and project name as "project-dev.tfvars".

Also there are other 2 files we didn't make it before in this series. They are:

### "backend-dev.hcl"

HCL file is [HashiCorp Configuration Language](https://github.com/hashicorp/hcl) that we utilise it to store our backend configurations. It would be nice when we're building in multiple environments. Therefore we can leave the backend script blank like this.

<script src="https://gist.github.com/bluebirz/3256d7965890fabc5d4cacc3823e75f9.js?file=backend.tf"></script>

and prepare backend configuration in a separated file, say naming it "backend-dev.hcl"

<script src="https://gist.github.com/bluebirz/3256d7965890fabc5d4cacc3823e75f9.js?file=backend-dev.hcl"></script>

### "cloudbuild.yaml"

Our main character is here. Remember Terraform commands we used in the terminal? We will arrage them all into the file.

<script src="https://gist.github.com/bluebirz/3256d7965890fabc5d4cacc3823e75f9.js?file=cloudbuild.yaml"></script>

It is so easy as we can just use a ready-to-use Terraform image, "hashicorp/terraform:1.0.0". This is a [link to Docker Hub](https://hub.docker.com/r/hashicorp/terraform).

We create 3 simple steps here.

#### init

Get into folder "src" and `init` adding parameters of "backend-dev.hcl". Now we are using the proper state file.

```sh
cd src
terraform init -backend-config="../variables/backend-dev.hcl"
```

#### plan

Run the command.

```sh
cd src
terraform plan $(for v in $(ls ../variables/*.tfvars); do echo -var-file="$v"; done)
```

For the statement `$(for v in ...; do echo -var-file="$v"; done)`, we are listing all "tfvars" files in the folder "variables" then print them out in the format `-var-files="..."`. As a result, it's concatinating to a full command like this.

```sh
terraform plan -var-file="gcs-dev.tfvars" -var-file="project-dev.tfvars"
```

We don't have to update the command every time we created a new "tfvars" file, just put it in the correct folder and the command will reflect them automatically.

#### apply

```sh
cd src
terraform apply $(for v in $(ls ../variables/*.tfvars); do echo -var-file="$v"; done) -auto-approve
```

When everything seems fine we can add `-auto-approve` there.

---

## Try once manually

Let's run it by hand just once.

We `init` it.

![init](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p6/01-init.png){:style="max-width:75%;margin:auto;"}

We `plan` it.

![plan](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p6/02-plan.png){:style="max-width:75%;margin:auto;"}

And we `apply` it.

![apply](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p6/03-apply.png){:style="max-width:75%;margin:auto;"}

So now we can see the bucket "bluebirz_sample_tf_cicd_01" there.

![bucket](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p6/04-result-manual.png){:style="max-width:75%;margin:auto;"}

---

## Run it on Cloud Build

This time we run on Cloud Build.

First of all, make sure we already have a trigger for the repo and granted necessary permissions to the service account of the trigger.

In this case, I have granted permission "Storage Admin" for the Cloud Build service account. See [how to configure access for Cloud Build](https://cloud.google.com/build/docs/securing-builds/configure-access-for-cloud-build-service-account) and [understanding GCP roles](https://cloud.google.com/iam/docs/understanding-roles).

![roles](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p6/05-cloudbuild-permission.png){:style="max-width:75%;margin:auto;"}

I changed the name of target bucket from "bluebirz_sample_tf_cicd\_01" to "bluebirz_sample_tf_cicd_02" so the bucket is expected to be re-created in the new name.

Commit the change and push it. Cloud Build runs successfully.

![build history](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p6/06-build-complete.png){:style="max-width:75%;margin:auto;"}

Go check buckets and yes, it's re-created actually.

![bucket 2](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/terraform/p6/07-result-gcb.png){:style="max-width:75%;margin:auto;"}

---

## Repo

For all source code of this part, I have maintained in the repo below.

{% include bbz_custom/link_preview.html url='<https://github.com/bluebirz/sample-terraform>' %}
