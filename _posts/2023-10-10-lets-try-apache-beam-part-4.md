---
title: "Let's try: Apache Beam part 4 - live on Google Dataflow"
layout: post
author: bluebirz
description: This is a good time to see how we can run Apache Beam project on Cloud. 
date: 2023-10-10
categories: [data, data engineering]
tags: [Python, Apache Beam, batch data processing, Google Cloud Platform, Google Cloud Dataflow, Google Artifact Registry, Google Cloud Storage, Argparse, let's try]
series:
  key: beam
  index: 4
comment: true
image:
  path: https://images.unsplash.com/photo-1519320669750-579a8d7f1f6a?q=80&w=1959&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1519320669750-579a8d7f1f6a?q=10&w=1959&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Paulius Dragunas
  caption: <a href="https://unsplash.com/photos/antelope-grand-canyon-M2UXVaLlfds">Unsplash / Paulius Dragunas</a>
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

We have experimented our Apache Beam pipeline on local machines. This is a good time to see how we can run Apache Beam project on Cloud.

Of course, the cloud is Google Cloud Platform. Yes we're talking Google Dataflow.

---

## What is Google Dataflow?

Google Dataflow is a GCP service to run Apache Beam on provisioned VM instances as worker nodes. We can also configure the instances, how much RAM, CPU we need, networking and much more.

We can deploy our Beam pipeline to run on Dataflow by various methods. Also we are able to integrate the pipeline with other GCP services, such as processing files in Google Cloud Storage, receiving message from Google Pub/Sub, and write processed data into Google Cloud Firestore.

However, today we will see just a simple pipeline as the previous parts, read and write a simple file.

---

## Runner

Core concept is here. When we are using Google Dataflow, we have to use its dedicate runner. It is `DataflowRunner`.

Using `DataflowRunner`, we would need to specify either in `beam.Pipeline()` or `python -m` command.

As well as we have to enable the Dataflow API beforehand.

![dataflow api](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p4/01-dataflow-api.png){:style="max-width:75%;margin:auto;"}

Let's get to see examples.

---

## Example 1: Direct from local

Let's start from a basic one.

### Prepare files

Say we have this. The pipeline should produce outputs of only "F" people.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=04-a-main.py"></script>

In `run_beam()`, there are GCS files we want to read and write (line 30-31). There we specify runner as DataflowRunner at line 37.

### Run it

To make it run on Dataflow, we can execute this command in Terminal.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=04-a-cmd.sh"></script>

- flag `--region` is a region of Dataflow job as we want.
- flag `--runner` is a `DataflowRunner` here.
- flag `--project` is a project of the job.
- flag `--temp_location` is a GCS folder for storing temporary file generated by Dataflow job.

### Check results

Wait for some time and we can see green lights like this.

![dataflow map](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p4/02-df-a-noimage.png){:style="max-width:75%;margin:auto;"}

You might notice the code has `import csv` inside the function `mapToDict()`.

I had imported it at the top and got an error, so that I understand it's about the imported library is not available in the Dataflow worker nodes.

![dataflow error](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p4/03-df-a-error-import.png){:style="max-width:75%;margin:auto;"}

We can check if the files are ready.

![gcs](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p4/04-df-a-gcs-procfile.png){:style="max-width:50%;margin:auto;"}

And the content is correct.

![gsutil cat](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p4/05-df-a-cat.png){:style="max-width:75%;margin:auto;"}

---

## Example 2: Container image

Because direct deployment above is good for such a small code, when it comes to bigger ones, that method is not working.

We consider using container image in order to pack source code in a place and easy to deploy.

### Prepare files

Prepare folder structure like this.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=04-tree.md"></script>

A file `CSVToDict`.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=03-CSVToDict-2-init.py"></script>

A file "main.py". This time we want only "M" people.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=04-b-main.py"></script>

And Dockerfile.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=04-Dockerfile"></script>

Now we have a blank "requirements.txt" because we don't have any external library to use at this time.

### Prepare a container image

Now we have to build an image and upload it to Google Artifact Registry.

We need to create a repo in Google Artifact Registry first.

```sh
gcloud artifacts repositories create sample-beam \
   --repository-format=docker \
   --location=europe-west1 \
   --async
```

### Run it

Then we can build and push the image and create a Beam pipeline based on the image.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=04-b-cmd.sh"></script>

- flag `--region` is a region of Dataflow job as we want.
- flag `--runner` is a `DataflowRunner` here.
- flag `--project` is a project of the job.
- flag `--temp_location` is a GCS folder for storing temporary file generated by Dataflow job.
- flag `experiments=use_runner_v2` enables Dataflow Runner V2.
- flag `sdk_container_image` is an image of this Beam job.

### Check results

The Dataflow job is green like this.

![dataflow run](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p4/06-df-b-image.png){:style="max-width:75%;margin:auto;"}

We would find the image of this pipeline by checking at "sdk_container_image" under "Pipeline options" in the bottom right.

And check the output file if it has only "M" people. Yes.

![gsutil cat after dataflow](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p4/07-df-b-cat.png){:style="max-width:75%;margin:auto;"}

Read more about Google Artifact Registry here.

{% include bbz_custom/link_preview.html post='2023-03-25-private-repo-python' %}

---

## Example 3: Container image with parameters

For some reasons, we need to input file paths instead of hardcoding it.

We would consider `Argparse`, a library for managing inputs from command line.

### Prepare files

We have updated "main.py" a bit to get file paths from input arguments (line 12-17) and select only whose "id" is odd (line 37).

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=04-c-main.py"></script>

### Run it

Do the same, build and push an image then run Beam from that.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=04-c-cmd.sh"></script>

- flag `--region` is a region of Dataflow job as we want.
- flag `--runner` is a `DataflowRunner` here.
- flag `input_file` and `output_file` are custom parameters.
- flag `--project` is a project of the job.
- flag `--temp_location` is a GCS folder for storing temporary file generated by Dataflow job.
- flag `experiments=use_runner_v2` enables Dataflow Runner V2.
- flag `sdk_container_image` is an image of this Beam job.

### Check results

Now we will see the Beam job run completely. As the same, we can spot "input_file" and "output_file" under "Pipeline options".

![dataflow with gar](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p4/08-df-c-imageparams.png){:style="max-width:75%;margin:auto;"}

And the file is showing people with odd ids.

![gar result](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p4/09-df-c-cat.png){:style="max-width:75%;margin:auto;"}

Read more about `Argparse` here.

{% include bbz_custom/link_preview.html post='2023-02-26-argparse-python-param' %}

---

## Repo

You can check my repo of this part here.

{% include bbz_custom/link_preview.html url='<https://github.com/bluebirz/sample-beam/tree/main/04-dataflow>' %}

---

## References

- [Dataflow Real-time data intelligence](https://cloud.google.com/products/dataflow?hl=en)
- [Run the pipeline on the Dataflow service](https://cloud.google.com/dataflow/docs/quickstarts/create-pipeline-python#run-the-pipeline-on-the-dataflow-service)
- [NameError](https://cloud.google.com/dataflow/docs/guides/common-errors#name-error)
- [Pipeline options](https://cloud.google.com/dataflow/docs/reference/pipeline-options)
- [Use Dataflow Runner v2](https://cloud.google.com/dataflow/docs/runner-v2)
