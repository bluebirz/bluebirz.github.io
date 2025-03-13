---
title: DAG integrity - unit test your DAG before deploying
layout: post
author: bluebirz
description: Prepare a test to ensure the pipeline is good enough to deploy
date: 2023-01-08
categories: [data, data engineering]
tags: [Apache Airflow, Python, testing]
comment: true
image:
  path: https://images.unsplash.com/photo-1542984385-2184d2ba45eb?q=80&w=2074&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Emiliano Vittoriosi
  caption: <a href="https://unsplash.com/photos/woman-wearing-black-collared-jacket-0N_azCmUmcg">Unsplash / Emiliano Vittoriosi</a>
---

Hi, guess you are not getting bored about Airflow stuff.

This blog, we are going to see how can we make sure our DAG is looking good. With **DAG integrity** checking method, we can ensure at our DAG is proved to be executable and has no error in a basic level.

---

## The objective

At a unit test step, we just want to guarantee our DAGs are **imported correctly**. No syntax errors nor library import errors. We don't do proving our pipeline is perfect at this time, we do that in integration test or end-to-end test.

What should we do now?

---

## DAGBAG

DAGBAG is a module in Airflow DAG. It stores the DAGs and has structured in DAGs' metadata. For more info, visit [this link](https://airflow.apache.org/docs/apache-airflow/stable/_api/airflow/models/dagbag/index.html).

We can use this module to verify our DAGs are imported properly. Like this code stub.

<script src="https://gist.github.com/bluebirz/b371537716e5c19b8d42b5044da2afe7.js"></script>

After importing `DagBag` and initiate the class object as `dagbag` at line 3, we can print out its attributes `.dags` and `.import_errors` to see list of DAGs and list of errors if any.

This is similar to the commands we used in the last blog.

{% include bbz_custom/link_preview.html post='2022-12-29-try-apache-airflow-2' %}

---

## Combine with unittest

We use `unittest` together with this `DagBag` to test if we have the target DAG or not.

![dag test](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/dag-integrity/Screenshot+2566-01-05+at+20.25.01.png)

Please follow the link below to a complete Dag integrity scripts.

{% include bbz_custom/link_preview.html url='<https://github.com/bluebirz/airflow-docker/blob/main/dags/sample_project/tests/dag_integrity.py>' %}

Now we try run this command to validate the DAG and see we found a DAG in `DagBag`.

```sh
python tests/dag_integrity.py
```

If DAGs are good, we shall see this message.

![good](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/dag-integrity/Screenshot+2566-01-01+at+20.49.18.png)

Otherwise, it will show an error like this.

![err](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/dag-integrity/Screenshot+2566-01-01+at+20.59.07.png)

---

## Further applications

This is great to do unit test before deploying our apps to server, either preproduction or production.

We could add the command into our CI/CD stages. Any in our favor, Github action, Bitbucket pipeline, Google Cloud Build and others.

Have a great day with no bugs.
