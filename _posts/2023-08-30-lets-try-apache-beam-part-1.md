---
title: "Let's try: Apache Beam part 1 - simple batch"
layout: post
author: bluebirz
description: Apache Beam is a tool from Apache for processing data, both batch and real-time basis.
date: 2023-08-30 00:00:00 +0200
categories: [data, data engineering]
tags: [Python, Apache Beam, batch data processing, let's try]
series:
  key: beam
  index: 1
image:
  path: https://images.unsplash.com/photo-1519320669750-579a8d7f1f6a?q=80&w=1959&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Paulius Dragunas
  caption: <a href="https://unsplash.com/photos/antelope-grand-canyon-M2UXVaLlfds">Unsplash / Paulius Dragunas</a>
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

Hi~

New series of "Let's try" is here. We are talking about one of popular transformation tools – Apache Beam.

---

## What's Apache Beam

**Apache Beam** is a tool from Apache for processing data, both batch and real-time basis. This is popular as its open-source license and capability to work on data processing tasks. This is about "T" - Transform in "ETL" term as if we are cooking fried eggs for our nice consumers.

Apache Beam can be performed on mainstream languages such as Java, Python, and Go.

{% include bbz_custom/link_preview.html url='<https://beam.apache.org/>' %}

Of course, we will take it in Python.

---

## Concept of this blog

We need some backgrounds before going to the hand-on.

### Terms

Apache Beam consists of 3 simple terms:

- `Pipeline`: This is the overall of tasks.
- `PCollection`: This is a set of data. It can be **bounded**, a finite dataset a.k.a. batch, or **unbounded**, an infinite dataset a.k.a. streaming.
- `PTranform`: This is an operation to transform data.

A `Pipeline` starts from `PCollection` from bounded or unbounded datasource and transform using `PTransform`, and so on until the end.

![pipeline](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p1/beam.drawio.png)

---

### Runner

Apache Beam requires "runner" for executing the task. There are several runners for different platforms/engines. For more info, please visit this link.

{% include bbz_custom/link_preview.html url='<https://beam.apache.org/documentation/runners/capability-matrix/>' %}

In this blog, we are using Python Direct Runner which is one of simplest runners.

---

## Begin the hand-on

This hand-on is reading a CSV file and do some transformations.

### 1. Install Apache Beam

Prepare your environment and install Apache Beam with this command.

```sh
pip install apache-beam
```

### 2. Prepare a CSV file

Now we made a sample CSV file.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=01-mock.csv"></script>

### 3. Read the file

We can write Python code to read the file as follows.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=01-batch1.py"></script>

We want to read it locally so we import `DirectRunner()` or parse `'DirectRunner'` for the parameter `runner`. After that we add pipe (`|`) in order to add new step for `beam.io.ReadFromText()`.  This function read texts from a given file.

I usually pipe `beam.Map(print)` to debug. This statement mean commanding Beam to execute `PTransform`, `print` to print values, via `beam.Map()` and parse `PCollection` from the previous step, which is what we have read from the file.

And here is the result.

![read](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p1/beam1.png){:style="max-width:75%;margin:auto;"}

### 4. Map to dict

We want more step. I've prepare function `mapToDict()` that get a string and parse to CSV dict. This function is called by `beam.Map(mapToDict)` and then `print` again.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=01-batch2.py"></script>

![map to dict](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p1/beam2.png){:style="max-width:75%;margin:auto;"}

### 5. Filter

We want only `F`, the female person, therefore we add the step `beam.Filter()`. This function will filter only records in `PCollection` that meet the condition.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=01-batch3.py"></script>

![filter](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p1/beam3.png){:style="max-width:75%;margin:auto;"}

### 6. Map to CSV rows

Say we have processed completely and want to save the output into a file, so that we need to transform from `dict` to `str` in CSV format.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=01-batch4.py"></script>

The method `mapToCSVRow` will product a string of CSV format.

![map to csv](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p1/beam4.png){:style="max-width:75%;margin:auto;"}

### 7. Write to new CSV file

Right here, we use `beam.io.WriteToText()` to write the `PCollection` from the last `PTransform` into a file. Add `shard_name_template=""` in order to produce file without sharding name, otherwise it will be like "-00000-of-00001" at the end of the filename.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=01-batch5.py"></script>

### 8. The new CSV file

Now the output is ready like this.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=01-processed.csv"></script>

---

## Repo

{% include bbz_custom/link_preview.html url='<https://github.com/bluebirz/sample-beam/tree/main/01-simple-batch>' %}
