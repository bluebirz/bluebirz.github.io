---
title: Slack me what you build
layout: post
description: Slack offers APIs that developers love to use for their wonderful automated pipelines.
date: 2024-09-13 00:00:00 +0200
categories: [devops, integration]
tags: [Python, Google Cloud Platform, Google Cloud Pub/Sub, Google Cloud Functions, Google Cloud Build, Google Secret Manager, Slack, webhook, CI/CD]
mermaid: true
image:
  path: https://images.unsplash.com/photo-1563986768609-322da13575f3?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMTc3M3wwfDF8c2VhcmNofDF8fGNvZmZlZXNob3AlMjBzbGFja3xlbnwwfHx8fDE3MjYxMzQ5MjF8MA&ixlib=rb-4.0.3&q=80&w=2000
  alt: Unsplash / Austin Distel
  caption: <a href="https://unsplash.com/photos/person-using-phone-and-laptop-gUIJ0YszPig">Unsplash / Austin Distel</a>
---

I have a blog about sending build results from Google Cloud Build to Google Chat ([here]({% post_url 2021-02-21-google-chat-me-what-you-tell-google-cloud-build %})). And this is a version for Slack.

In case you don't aware of, Slack is a popular messaging app among developer teams and companies with its feature-rich more than just texting between individuals and groups. It also offers APIs that developers love to use for their wonderful automated pipelines.

And Google Cloud Build is a main CI/CD tool in Google Cloud Platform. It's super easy to build your code into services in GCP.

---

## Diagram

```mermaid
sequenceDiagram
  autonumber

  box Google Cloud Platform
  participant gcb as Google<br/>Cloud Build
  participant gps as Google<br/>Cloud Pub/Sub
  participant gcf as Google<br/>Cloud Functions
  participant gsm as Google<br/>Secret Manager
  end

  box Slack
  participant web as Slack<br/>Webhook
  participant chn as Slack<br/>Channel
  end

  gcb->>gps: send build events
  gps->>gcf: trigger eventarc
  gcf->>gsm: get Slack url
  activate gsm
  gsm->>gcf: return Slack url
  deactivate gsm
  gcf->>web: post Slack messages
  web->>chn: display messages
  
```

---

## Services we need

1. Google Cloud Build
1. Google Cloud Pub/Sub topic "cloud-builds"
1. Slack app or webhook API
1. Google Secret Manager to store Slack API as a secret
1. Google Cloud Functions as a main operator

---

## Steps

### 1. Prepare Cloud Build

First of all, we need to enable Google Cloud Build API and Google Cloud Pub/Sub API. There must be one topic called "cloud-builds" and Google Cloud Build will automatically publish build events through that.

![topics](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/gcb-slack/topic.png){:style="max-width:75%;margin:auto;"}

### 2. Prepare Slack webhook API

In this blog we will try Slack webhook API solution. Another is using Slack app.

We can follow the steps to create a webhook url in the link below.

{% include bbz_custom/link_preview.html url='<https://api.slack.com/messaging/webhooks>' %}

We should get an webhook url in the "Incoming webhook" page in settings and it's supposed to be like this "<https://hooks.slack.com/services/ABC/DEF/GHIJ1234>".

![webhook](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/gcb-slack/slack-webhook.png){:style="max-width:75%;margin:auto;"}

### 3. Store webhook in Google Secret Manager

We need to save it secret in Google Secret Manager and retrieve in Google Cloud Functions as an environment variable.

![secret manager](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/gcb-slack/gsm.png){:style="max-width:75%;margin:auto;"}

### 4. Design Slack message template

Go to Slack Block Kit. Here we can design our own style messages that we want to see in Slack channels.

{% include bbz_custom/link_preview.html url='<https://api.slack.com/block-kit/building>' %}

Here is my sample template for this operation.

<script src="https://gist.github.com/bluebirz/0e1df748bc70b080392952e42031d6ba.js?file=template.j2"></script>

### 5. Implement Google Cloud Functions

The last step is to implement the main Cloud Functions.

My Cloud Functions uses Python to receive messages from the topic "cloud-builds" which forwards from Google Cloud Build. Then extract the message and assemble to a new Slack message and send out through the Slack webhook API.

<script src="https://gist.github.com/bluebirz/0e1df748bc70b080392952e42031d6ba.js?file=main.py"></script>

### 6. Deploy Google Cloud Functions

Just using the command to deploy directly.

```sh
gcloud functions deploy NAME [flags]
```

For full scripts, please review "cloudbuild.yaml" in the repo link at the bottom.

---

## Real outputs

When everything is done, we should see the result like this.

![slack message](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/gcb-slack/test-result.png){:style="max-width:75%;margin:auto;"}

---

## Repo

{% include bbz_custom/link_preview.html url='<https://github.com/bluebirz/google-cloud-build-slack-python>' %}
