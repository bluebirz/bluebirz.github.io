---
title: CloudEvents standard
layout: post
description: This standard helps us communicate between source and consumer in order to develop the system a lot easier.
date: 2023-07-16 00:00:00 +0200
categories: [data, data engineering]
tags: [CloudEvents, standards]
image:
  path: ../assets/img/features/external/cloudevents-icon-color.png
  alt: cloudevents 
  caption: <a href="https://cloudevents.io">cloudevents</a>
---

My current works involve real-time integration and processing. There are variety of data categories and formats. It would be challenging for both sources and consumers to ingest data when they come in different faces, because of their data schemas.

Introduce a standard specification of real-time event data.

---

## CloudEvents

**CloudEvents** is a specification hosted by Cloud Native Computing Foundation (CNCF) and the project has been started since 2018.

Official document is in Github at the [link here](https://github.com/cloudevents/spec).

---

## Benefits

This standard helps us communicate between source and consumer in order to develop the system a lot easier. It's like a framework for real-time integrations.

When an incident happened, we can take less time to scope down where it was and investigate back a lot faster.

As it is a standard, what we developers have to do is to adopt and adapt it for our projects or organizations.

---

## What's for the standard

CloudEvents defines 2 main parts of event data.

1. Required fields
1. Optional fields

### Required fields

There are 4 main fields we have to put into CloudEvents payload.

1. `id`  
  `id` is a string identifies the event. This is able to be UUID or counter and must have a unique value.
1. `source`  
  This is a string identifies data source. Recommended to be address accessible via internet (URL or email) or application identifier.  
  Combination of `source` and `id` must be unique all across the system.
1. `specversion`  
  It's a version of CloudEvents standard. At this time is `1.0`, to comply all event data with this standard.
1. `type`  
  `type` is source-defined event data type and should be formatted like a package name that can be tracked back to each layer of creation/production.

### Optional fields

Other than those required fields, we can add these or else we see fit into the payload as long as they're aligned with policies and standards of the organization.

1. `datacontenttype`  
  I usually design this as "application/json" because it is always Pub/Sub message. However we can design in other formats when needed.
1. `dataschema`  
  Schema of the event data, in a URI format.
1. `subject`  
This field is for the case a consumer can't/wouldn't read whole payload, for any reasons. It will show brief information for them.
1. `time`  
  Timestamp of when the event occurred in datetime string format.
1. `data`  
  This is where we can put contents of the event data.

### Guidelines

- All CloudEvents standard fields follow  
  - must be **lowercase**
  - only alphanumeric (`r'[a-z0-9]'`)
  - descriptive, concise
  - should not longer than 20 letters
- Data size should be 64KB or smaller when produced.
- Security and privacy
  - Should not contain sensitive information
  - Should be encrypted
  - Ensure the channel is secure and trustable

---

## Sample CloudEvents payload

As above, there're 4 mandatory fields we need to follow. And the rest are by our design. One thing to keep in mind is, we design this to align and comply with our organization's standards.

### Example 1: User login event

<script src="https://gist.github.com/bluebirz/b224ac719ef627aba58150d13085dcc9.js?file=sample-userlogin.json"></script>

### Example 2: Sensor data

<script src="https://gist.github.com/bluebirz/b224ac719ef627aba58150d13085dcc9.js?file=sample-tempsensor.json"></script>
