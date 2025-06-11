---
title: (Google) Chat me what you (tell Google Cloud) Build
layout: post
author: bluebirz
description: We can setup a bot to send a Google Chat message when a build on Google Cloud Build is finished.
date: 2021-02-21
categories: [programming, Python]
tags: [Google Cloud Platform, Google Cloud Build, Google Cloud Pub/Sub, Google Cloud Functions, Google Chat, notification]
comment: true
image:
  path: https://images.unsplash.com/photo-1577563908411-5077b6dc7624?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1577563908411-5077b6dc7624?q=10&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Volodymyr Hryshchenko
  caption: <a href="https://unsplash.com/photos/three-crumpled-yellow-papers-on-green-surface-surrounded-by-yellow-lined-papers-V5vqWC9gyEU">Unsplash / Volodymyr Hryshchenko</a>
---

If your team is using Google Cloud Build for CI (Continuous Integration) process and is a client of Google Workspace (a.k.a G-Suite). We can setup a bot to send message when the build is finished.

This tutorial requires basic of Python.

---

## Overview

![overview](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/google-build-chat/build_chat.png)

---

## 1. Google Cloud Build

First of all is, we must have Google Cloud Build triggers ([doc](https://cloud.google.com/build/docs/automating-builds/create-manage-triggers)). If yes, go next.

---

## 2. Google Cloud Pub/Sub

There is a topic of Cloud Pub/Sub named "cloud-build" that we have to create if we don't have yet when we have triggers. The message will be in this format.

```json
{
  "name": "projects/123/locations/global/builds/ca523374-cf65-4acc-b13f-0c32b7c5f0b0",
  "id": "ca523374-cf65-4acc-b13f-0c32b7c5f0b0",
  "projectId": "project",
  "status": "SUCCESS",
  "source": {
    ...
  },
  "steps": [
    {
      ...
    }
  ],
  "results": {
      ...
  },
  "createTime": "2021-02-19T06:27:49.268719440Z",
  "startTime": "2021-02-19T06:27:50.900538766Z",
  "finishTime": "2021-02-19T06:29:32.266544Z",
  "timeout": "1200s",
  "queueTtl": "3600s",
  "logsBucket": "gs://log-bucket",
  "sourceProvenance": {
    ...
  },
  "buildTriggerId": "e6c46525-39be-4886-afe6-d98c18d6893e",
  "options": {
    ...
  },
  "logUrl": "https://console.cloud.google.com/cloud-build/builds/ca523374-cf65-4acc-b13f-0c32b7c5f0b0?project=123",
  "substitutions": {
    "BRANCH_NAME": "branch",
    "COMMIT_SHA": "b7738ee8b38e1a8551ec632e8e79733c9a546fa1",
    "REPO_NAME": "repo",
    "REVISION_ID": "b7738ee8b38e1a8551ec632e8e79733c9a546fa1",
    "SHORT_SHA": "b7738ee"
  },
  "tags": ["trigger-e6c46525-39be-4886-afe6-d98c18d6893e"],
  "timing": {
    "BUILD": {
      "startTime": "2021-02-19T06:28:03.203464932Z",
      "endTime": "2021-02-19T06:29:27.751418550Z"
    },
    "FETCHSOURCE": {
      "startTime": "2021-02-19T06:27:53.686032686Z",
      "endTime": "2021-02-19T06:28:03.203377780Z"
    }
  }
}
```

---

## 3. Google Chat

Next is to create a room of Google Chat and an incoming webhook by [this link](https://developers.google.com/hangouts/chat/how-tos/webhooks).

---

## 4. Google Cloud Functions

After all, it's our turn to create a Google Cloud Functions to connect to the Pub/Sub topic with a condition to send the pushed messages to the Google Chat room through the webhook.

Let's start.

### 4.1 Write a function to handle messages from Pub/Sub

With these lines, the Google Cloud Functions will receive messages from a specific Pub/Sub topic.

```py
import base64
import json

def cloudbuild_notifications(event, context):
    message = json.loads(base64.b64decode(event['data']).decode('utf-8'))
```

A message comes into variable `event`. We extract the byte array in path "data" then decode and transform to json format. Now we have payload in variable `message`.

### 4.2 Create a function to send a Google Chat message

[This doc](https://developers.google.com/hangouts/chat/reference/message-formats) explains us there are 2 types of Google Chat message that are texts and cards. Select cards to expose information in rich way.

{% raw %}

```py
from httplib2 import Http
from dateutil.parser import isoparse
from datetime import datetime, timezone
import pytz
    
def send_ggchat(payload):
    time_pattern = "%Y-%m-%d %H:%M:%S"
    time_timezone = pytz.timezone("Asia/Bangkok")
    time_start = isoparse(payload['timing']['FETCHSOURCE']['startTime']).astimezone(time_timezone)
    time_end = isoparse(payload['timing']['BUILD']['endTime']).astimezone(time_timezone)

    message =  """{{ "cards": [{{
        "header": {{
            "title": "Build Notification for Backend Core",
            "subtitle": "Build {build_id} is {status}"
        }},
        "sections": [{{
            "widgets": [
                {{"keyValue": {{"topLabel": "Repo", "content": "{repo}"}} }},
                {{"keyValue": {{"topLabel": "Branch", "content": "{branch}"}} }},
                {{"keyValue": {{"topLabel": "Commit", "content": "{commit}"}} }},
                {{"keyValue": {{"topLabel": "Created", "content": "{created_time}"}} }},
                {{"keyValue": {{"topLabel": "Status", "content": "{status}"}} }},
                {{"keyValue": {{"topLabel": "Duration (sec)", "content": "{duration}"}} }},
                {{"buttons": [{{
                    "textButton": {{
                        "text": "{build_id} log Link",
                        "onClick": {{"openLink": {{"url": "{log_url}"}} }}
                    }} 
                }} ] }}
            ]
        }} ]
    }} ] }} """.format(
                    build_id=payload['id'].split("-")[0],
                    status=payload['status'],
                    repo=payload['substitutions']['REPO_NAME'],
                    branch=payload['substitutions']['BRANCH_NAME'],
                    commit=payload['substitutions']['SHORT_SHA'],
                    created_time=time_start.strftime(time_pattern),
                    duration=(time_end - time_start).total_seconds(),
                    log_url=payload['logUrl'],
                    )

    message_headers = {'Content-Type': 'application/json; charset=UTF-8'}

    http_obj = Http()
    response = http_obj.request(
        uri="https://chat.googleapis.com/v1/spaces/abc/messages?key=key&token=token",
        method='POST',
        headers=message_headers,
        body=json.dumps(json.loads(message))
    )
```

{% endraw %}

These are my design.

1. Display id of the build and branch in short format.
1. Date and time from Pub/Sub message is in nanosecond format such as "2021-02-19T06:28:04.329309285Z".  
  We apply method `.isoparse()` of library dateutil to transform that string to `datetime`.
1. Update timezone from UTC to "Asia/Bangkok" using the library `pytz`.
1. Add links to the build log.
1. Compute build duration since a start time of `"FETCHSOURCE"` to an end time of `"BUILD"`.

A time to call webhook is to use method `Http().request()`. The body will be an properly encoded json string via `json.dumps(json.loads())`.

Here is an example card.

![example card](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/google-build-chat/Screen-Shot-2021-02-21-at-11.21.01-AM.png)

### 4.3 embed the URL to an environment variable

Hardcoding the URL is not a good idea. We choose to embed it as an environment variable called `"_URL"` then refer it in code with the variable `"GGCHAT_URL"`.

```py
import os

GGCHAT_URL = os.environ.get('_URL', 'Environment variable does not exist')

def send_ggchat(payload):
    # code ...
    response = http_obj.request(
        uri=GGCHAT_URL,
        method='POST',
        headers=message_headers,
        body=json.dumps(json.loads(message))
    )
```

### 4.4 assemble all into `main.py`

Calling the function `send_ggchat()` in function `cloudbuild_notifications()`. This is all of our function in the file "main.py".
{% raw %}

```py
import base64
import json
from httplib2 import Http
from dateutil.parser import isoparse
from datetime import datetime, timezone
import pytz
import os

GGCHAT_URL = os.environ.get('_URL', 'Environment variable does not exist')
    
def send_ggchat(payload):
    time_pattern = "%Y-%m-%d %H:%M:%S"
    time_timezone = pytz.timezone("Asia/Bangkok")
    time_start = isoparse(payload['timing']['FETCHSOURCE']['startTime']).astimezone(time_timezone)
    time_end = isoparse(payload['timing']['BUILD']['endTime']).astimezone(time_timezone)

    message =  """{{ "cards": [{{
        "header": {{
            "title": "Build Notification for Backend Core",
            "subtitle": "Build {build_id} is {status}"
        }},
        "sections": [{{
            "widgets": [
                {{"keyValue": {{"topLabel": "Repo", "content": "{repo}"}} }},
                {{"keyValue": {{"topLabel": "Branch", "content": "{branch}"}} }},
                {{"keyValue": {{"topLabel": "Commit", "content": "{commit}"}} }},
                {{"keyValue": {{"topLabel": "Created", "content": "{created_time}"}} }},
                {{"keyValue": {{"topLabel": "Status", "content": "{status}"}} }},
                {{"keyValue": {{"topLabel": "Duration (sec)", "content": "{duration}"}} }},
                {{"buttons": [{{
                    "textButton": {{
                        "text": "{build_id} log Link",
                        "onClick": {{"openLink": {{"url": "{log_url}"}} }}
                    }} 
                }} ] }}
            ]
        }} ]
    }} ] }} """.format(
                    build_id=payload['id'].split("-")[0],
                    status=payload['status'],
                    repo=payload['substitutions']['REPO_NAME'],
                    branch=payload['substitutions']['BRANCH_NAME'],
                    commit=payload['substitutions']['SHORT_SHA'],
                    created_time=time_start.strftime(time_pattern),
                    duration=(time_end - time_start).total_seconds(),
                    log_url=payload['logUrl'],
                    )

    message_headers = {'Content-Type': 'application/json; charset=UTF-8'}

    http_obj = Http()
    response = http_obj.request(
        uri=GGCHAT_URL,
        method='POST',
        headers=message_headers,
        body=json.dumps(json.loads(message))
    )
    print(response)


def cloudbuild_notifications(event, context):
    message = json.loads(base64.b64decode(event['data']).decode('utf-8'))
    send_ggchat(message)
```

{% endraw %}

### 4.5 Create `requirements.txt`

This is because we have imported many external libraries. Need this to tell Google Cloud Functions to prepare the following library on deployment.

```
python-dateutil
httplib2
pytz
```

### 4.6 Prepare an environment variable file

Because we have environments variables, we also write this file as a reference.

```
_URL: https://chat.googleapis.com/v1/spaces/abc/messages?key=key&token=token
```

Name this "env.yaml".

### 4.7 Arrange files and folders

prepare files like this.

```
.
├── env.yaml
└── source
    ├── main.py
    └── requirements.txt

1 directory, 3 files
```

### 4.8 deploy function

To deploy via terminal/cmd, make sure Google Cloud SDK is already install in the machine ([how to install](https://cloud.google.com/sdk/docs/install)). Go to the folder "source" and submit this command.

```sh
gcloud functions \
--project [project_id] deploy cloudbuild-notifications \
--entry-point cloudbuild_notifications \
--runtime python38 \
--retry \
--env-vars-file ../env.yaml \
--trigger-topic cloud-builds
```

The "project_id" must be matched with the one of Pub/Sub or the function cannot be triggered.

### 4.9 Review it

These message are displayed mean the function is deployed successfully.

```
Deploying function (may take a while - up to 2 minutes)...⠹                                                                                                
For Cloud Build Stackdriver Logs, visit: https://console.cloud.google.com/logs/viewer?project=project&advancedFilter=resource.type%3Dbuild%0Aresource.labels.build_id%3Dd13aeb6e-d08d-417e-9e2d-5bdfc55aa9e5%0AlogName%3Dprojects%2Fproject%2Flogs%2Fcloudbuild
Deploying function (may take a while - up to 2 minutes)...done.                                                                                            
availableMemoryMb: 256
buildId: d13aeb6e-d08d-417e-9e2d-5bdfc55aa9e5
entryPoint: cloudbuild_notifications
environmentVariables:
  _URL: https://chat.googleapis.com/v1/spaces/abc/messages?key=key&token=token
eventTrigger:
  eventType: google.pubsub.topic.publish
  failurePolicy:
    retry: {}
  resource: projects/project/topics/cloud-builds
  service: pubsub.googleapis.com
ingressSettings: ALLOW_ALL
labels:
  deployment-tool: cli-gcloud
name: projects/project/locations/us-central1/functions/cloudbuild-notifications
runtime: python38
serviceAccountEmail: project@appspot.gserviceaccount.com
sourceUploadUrl: https://storage.googleapis.com/xxx
status: ACTIVE
timeout: 60s
updateTime: '2021-02-19T10:56:09.074Z'
versionId: '1'
```

---

## Repo

Here is the repo of this tutorial.

{% include bbz_custom/link_preview.html url='<https://github.com/bluebirz/cloudbuild-to-googlechat>' %}
