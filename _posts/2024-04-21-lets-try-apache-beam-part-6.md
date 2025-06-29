---
title: "Let's try: Apache Beam part 6 - instant IO"
layout: post
author: bluebirz
description: Apache Beam provides inputs and outputs for PCollection in many packages.
date: 2024-04-21
categories: [data, data engineering]
tags: [Python, Apache Beam, Google Cloud Platform, Google BigQuery, Google Cloud Pub/Sub, Google Cloud Storage, let's try]
series:
  key: beam
  index: 6
mermaid: true
comment: true
image:
  path: https://images.unsplash.com/photo-1519320669750-579a8d7f1f6a?q=80&w=1959&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1519320669750-579a8d7f1f6a?q=10&w=1959&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Paulius Dragunas
  caption: <a href="https://unsplash.com/photos/antelope-grand-canyon-M2UXVaLlfds">Unsplash / Paulius Dragunas</a>
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

Apache Beam provides inputs and outputs for PCollection in many packages. We just import and call them properly and get the job done.

This blog we will see 3 IO (input/output) modules that I usually work with.

---

## 1. Text (Google Cloud Storage)

A very basic one.

Beam has `beam.io` library and there are `ReadFromText()` and `WriteToText()` in order to read and write a text file respectively.

We also use them to work with files in Google Cloud Storage as they are text files.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=06-a-text.py"></script>

- line 14: `ReadFromText()` to read a file at `input_file` which is from `argparse`.
- line 16: `WriteToText()` to create a file at `output_file`.

This pipeline can be drawn to diagram like this.

```mermaid
sequenceDiagram
  autonumber

  participant i as input text file
  actor b as Apache Beam
  participant o as output text file
  
  i->>b: read file
  note over b: transform
  b->>o: write file
```

---

## 2. Database (Google BigQuery)

Another Google Cloud service that I use so often.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=06-b-bq.py"></script>

- line 14: `ReadFromBigQuery()` and supply `query=` to run the query.
- line 18: supply `temp_dataset=` in order to allow Beam can use the given dataset to store temporary data generated by Beam.

> If we don't supply `temp_dataset=`, Beam will automatically create a new dataset every time it runs.
{: .prompt-info }

![datasets](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p6/bq-temp-ds.png)
*Beam automatically generates temporary datasets.*

This pipeline is as the diagram below:

```mermaid
sequenceDiagram
  autonumber

  participant s as BigQuery<br/>source table
  actor b as Apache Beam
  participant d as BigQuery<br/>destination table
  
  note over b: read query file
  b->>s: request query job
  activate s
  s->>b: return query result
  deactivate s
  b->>d: write to destination
```

---

## 3. Messaging (Google Cloud Pub/Sub)

Come to real-time things.

Google Cloud Pub/Sub is one of source and sink integrated with Beam. We are able to setup Beam to listen to a publisher or a subscriber by design.

For this time, I setup Beam to read data from a subscriber then transform before send to another topic.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=06-c-pubsub.py"></script>

- line 10: set the option with `streaming=True`. Allow Beam to run as a streaming pipeline.
- line 15: `ReadFromPubSub()` by reading from a specific subscriber.
- line 26: After transforming, share the result to a topic through `WriteToPubSub()`.

> Make sure the PCollection is a byte string by using `.encode()` before throw them to `WriteToPubSub()`.
{: .prompt-warning }

We can test publish something on the topic and pull from the subscription. Like this.

![publish](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p6/pubsub-pub-pull.png)

`originMessageId` is parsed from the topic in transformation step.

This diagram describes the flow of this Beam pipeline.

```mermaid
sequenceDiagram
  autonumber
  
  actor u as User
  participant p1 as First<br/>publisher
  participant s1 as First<br/>subscriber (pull)
  actor b as Apache Beam
  participant p2 as Second<br/>publisher
  participant s2 as Second<br/>subscriber (pull)
 
  u->>p1: publish a message
  p1->>s1: send a message
  b->>s1: pull a message
  activate s1
  s1->>b: return a message
  deactivate s1
  note over b: transform
  b->>p2: publish a message
  activate s1
  p2->>s2: send a message
```

---

## Repo

Feel free to review full code here.

{% include bbz_custom/link_preview.html url='<https://github.com/bluebirz/sample-beam/tree/main/06-io>' %}

---

## References

- [apache_beam.io.textio module](https://beam.apache.org/releases/pydoc/current/apache_beam.io.textio.html)
- [apache_beam.io.gcp.bigquery module](https://beam.apache.org/releases/pydoc/2.36.0/apache_beam.io.gcp.bigquery.html)
- [Dataflow - BigQuery autodetect?](https://stackoverflow.com/questions/67633861/dataflow-bigquery-autodetect/67643669#67643669)
- [apache_beam.io.gcp.pubsub module](https://beam.apache.org/releases/pydoc/2.29.0/apache_beam.io.gcp.pubsub.html)
