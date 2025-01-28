---
title: Automate your project with Google Cloud Build
layout: post
description: Automate deployment is a useful scheme associated with Git concepts. 
date: 2023-04-25 00:00:00 +0200
categories: [devops, integration]
tags: [CI/CD, Google Cloud Platform, Google Cloud Build, Google Cloud Storage, jq]
image:
  path: https://images.unsplash.com/photo-1647427060118-4911c9821b82?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Simon Kadula
  caption: <a href="https://unsplash.com/photos/a-factory-filled-with-lots-of-orange-machines-8gr6bObQLOI">Unsplash / Simon Kadula</a>
---

Automate deployment is a useful scheme associated with Git concepts. We can write code for many projects and push to git for version controls. Then we should gain benefits from that for deliver those product to our platforms.

Here is the link I wrote about how to start with git.

{% include bbz_custom/link_preview.html post='2019-10-04-try-git' %}

---

## What is CI/CD

CI/CD stands for "Continuous Integration / Continuous Delivery". This is a significant setup for automate deployment.

![cicd](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/google-cloud-build/cicd.png)

**Continuous Integration** covers the way we can integrate the source code from git and automate test. **Continuous Delivery** goes further with delivering those fully tested code to deploying on the servers.

The work is running by the steps defined in the build definition e.g. unit test, then integration test, finally deploy.

---

## What is Google Cloud Build

Google Cloud Build is one of the CI/CD tool, other you may hear the name are Jenkins and Github Action, for instance.

When we enabled the Google Cloud Build API, we now ready for that.

![cloud build api](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/google-cloud-build/01-gcb-api.png){:style="max-width:75%;margin:auto;"}

This is the build history. All builds can be viewed here.

![build history](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/google-cloud-build/02-gcb-history.png){:style="max-width:75%;margin:auto;"}

And this is the trigger page. All triggers can be seen and we can manage like create, delete, update, and disable on this page.

![trigger](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/google-cloud-build/03-gcb-trigger.png){:style="max-width:75%;margin:auto;"}

We can connect to other services like send notifications on Google Chat when the build is complete. See the link below.

{% include bbz_custom/link_preview.html post='2021-02-21-google-chat-me-what-you-tell-google-cloud-build' %}

This time we are going to deploy CI/CD pipeline on Google Cloud Build. Let's go!

---

## Quest today

Let's give a story, we want to upload validated JSON files from our repo to Google Cloud Storage. The steps should be:

1. Verify all JSON files are correct
1. Copy all JSON files to Google Cloud Storage.

Interested? Let's go!

---

## Connect to the repo

There are several connectors from many git providers to Google Cloud Build. I use Github so I wanna show 2 simplest ways here.

### 1. Github App

We can just install the Cloud Build Github app till finish and we can create a trigger on the connection. The app is [here](https://github.com/marketplace/google-cloud-build) but we can install through these steps.

#### 1.1. Connect Repository

![connect repo](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/google-cloud-build/03a-gcb-select-source.png){:style="max-width:75%;margin:auto;"}

#### 1.2. Authenticate and install app

![install app](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/google-cloud-build/03b-gcb-install-app.png){:style="max-width:66%;margin:auto;"}

#### 1.3. Install on Github page

![install github page](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/google-cloud-build/03c-consent.png){:style="max-width:75%;margin:auto;"}

#### 1.4. Select repo

![select repo](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/google-cloud-build/03d-select-repo.png){:style="max-width:75%;margin:auto;"}

### 2. Mirror the repo

This solution is also easy. We can create a repo in Google Cloud Source Repository by mirroring the real repo in Github or BitBucket. Follow these steps.

#### 2.1. create a repo in Cloud Source Repo

First thing first, create a repo on **Google Cloud Source Repository**. Go to <https://source.cloud.google.com/> and create a repo.

![gsr repo](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/google-cloud-build/04-csr-start.png){:style="max-width:75%;margin:auto;"}

#### 2.2. Connect external repository

![connect external repo](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/google-cloud-build/05-csr-connect.png){:style="max-width:75%;margin:auto;"}

#### 2.3. Authorize to Github

![Authorize](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/google-cloud-build/06-csr-connect-github.png){:style="max-width:66%;margin:auto;"}

#### 2.4. Select a repo

![select repo](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/google-cloud-build/07-csr-connect-confirm.png){:style="max-width:75%;margin:auto;"}

#### 2.5. Mirror completed

![complete](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/google-cloud-build/08-csr-connected.png){:style="max-width:75%;margin:auto;"}

---

## Create a trigger

Next we can create a trigger to do the CI/CD job.

We can manually create a trigger on the web at <https://console.cloud.google.com/cloud-build/triggers>. Alternatively using `gcloud` command like this.

### 1. Connect repo through Github app

```sh
gcloud beta builds triggers create github \
--name=<TRIGGER_NAME> \
--region=<REGION> \
--repo-name=<REPO_NAME> \
--repo-owner=<OWNER_NAME> \
--branch-pattern=<BRANCH_PATTERN> \
--build-config=<CLOUDBUILD_YAML_FILEPATH>
```

- `TRIGGER_NAME`: name of this trigger. Usually express project name, environment, and branch.
- `REGION`: region of the trigger
- `REPO_NAME`: name of the source repo.
- `OWNER_NAME`: owner of the repo
- `BRANCH_PATTERN`: branch pattern e.g. `^main$` means branch "main" or `^feature-.*` means branches begins with "feature-"
- `CLOUDBUILD_YAML_FILEPATH`: the path of build definition. Usually use "cloudbuild.yaml" for Google Cloud Build here.

![connect github](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/google-cloud-build/09a-app-gcb-trigger-create.png){:style="max-width:75%;margin:auto;"}

### 2. Connect repo through mirroring

```sh
gcloud beta builds triggers create cloud-source-repositories \
--name=<TRIGGER_NAME> \
--repo=<REPO_NAME> \
--branch-pattern=<BRANCH_PATTERN> \
--build-config=<CLOUDBUILD_YAML_FILEPATH>
```

![connect repo](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/google-cloud-build/09-gcb-trigger-create.png){:style="max-width:75%;margin:auto;"}

---

## Check the trigger

After creating a trigger, we should see the trigger is there properly.

![trigger check](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/google-cloud-build/10-gcb-trigger-list.png){:style="max-width:75%;margin:auto;"}

---

## Setup Cloud Build file

This is the main part of CI/CD. Each CI/CD tool uses their own format to work, like this Google Cloud Build.

<script src="https://gist.github.com/bluebirz/173e3e72760379e58cbf3b99a0aaea82.js?file=cloudbuild.yaml"></script>

Start from `steps` key, followed by a list.

One item in the list should have `name` of the image name, and `args` for the image arguments.

For example above, there are 2 steps

1. The step has `id` "check-json". This step is based on the image `name` "gcloud".  
  It `waitFor` nothing, yes the step can be executed immediately. Once the image is loaded and ready, we build it and access `entrypoint` "bash" and supply the `args` that "update, install 'jq', and execute 'jq empty' to check if any JSON files are incorrect"
1. This step's `id` is "copy-json". It runs on the image `name` "gsutil".  
  This waitFor the step "check-json" to be completed first. Once the image is ready, we command it to copy ("cp") to the bucket through its `args`.

For all available key and schema, please follow [this link](https://cloud.google.com/build/docs/build-config-file-schema).

---

## Make a commit and push

Once push completed and wait for some time, we can see if the build is successful or not. If not, we can amend our code and push again.

![push](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/google-cloud-build/11-gcb-run.png){:style="max-width:75%;margin:auto;"}

If using the app, we can check the build via the Github checks page by clicking the blue tick (or red cross if failed).

![github checks](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/google-cloud-build/11a-app-gcb-run.png){:style="max-width:75%;margin:auto;"}

It will redirect to checks view.

![check view](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/google-cloud-build/11b-app-gcb-check.png){:style="max-width:75%;margin:auto;"}

---

## Verify the build result

Okay, the build is successful and we can check if our deployment is successful too.

![check result](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/google-cloud-build/12-gcs-files.png){:style="max-width:75%;margin:auto;"}

Yes, the files are there. The quest is completed.

---

## Repo

The source code can be found here.

{% include bbz_custom/link_preview.html url='<https://github.com/bluebirz/cloudbuild-sample>' %}
