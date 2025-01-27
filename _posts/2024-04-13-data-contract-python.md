---
title: Data contracts in action (Python)
layout: post
description: Last blog we talked about data contracts in NodeJS. This time we will do the same but in Python.
date: 2024-04-13 00:00:00 +0200
categories: [data, data engineering]
tags: [Python, data contract, jsonschema]
mermaid: true
image:
  path: https://images.unsplash.com/photo-1554252116-38656d028f1b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMTc3M3wwfDF8c2VhcmNofDd8fGUtc2lnbmF0dXJlfGVufDB8fHx8MTcxMjI0NjA0NHww&ixlib=rb-4.0.3&q=80&w=2000
  alt: Unsplash / Kelly Sikkema
  caption: <a href="https://unsplash.com/photos/sign-here-sign-near-blank-space-on-paper-wDghq14BBa4">Unsplash / Kelly Sikkema</a>
---

{% include bbz_custom/tabs.html %}

Last blog we talked about data contracts and implementation in NodeJS. This time we will do the same but in Python.

In case of the NodeJS version, click [the link here]({% post_url 2024-04-06-data-contract-js %})

---

## Recap

There is a validation step in extract layer in ETL. It is to make sure incoming data is sufficiently qualified to be in our databases.

```mermaid
---
config:
  width: 100%
---
flowchart TB
  classDef hl fill:#c35b20,stroke:#D9882F

  s(Source) -- send data --> a(API)

  subgraph ETL
    subgraph extract [Extract]
      direction LR
      e[[Extract]] ~~~ v[[Validate]]:::hl
    end
  
  extract --> t[[Transform]] --> l[[Load]]
  end

  a --> ETL --> d(Destination)
```

In this case, we are creating an API to retrieving data and validate it. The tools we need are OpenAPI and Python library for validation, `jsonschema`.

---

## API Swagger

We are using the same API definition file, `people` and also `pets`.

{% tabs def %}

{% tab def people %}

<script src="https://gist.github.com/bluebirz/b5ca8729b15a2147a7da06c231b1c453.js?file=people.yml"></script>

{% endtab %}

{% tab def pets %}

<script src="https://gist.github.com/bluebirz/b5ca8729b15a2147a7da06c231b1c453.js?file=pets.yml"></script>

{% endtab %}

{% endtabs %}

---

## Making an app with validation

Introduce `jsonschema`. This library helps us validate an object with expected schema. It works as same as AJV in NodeJS.

{% include bbz_custom/link_preview.html url='<https://python-jsonschema.readthedocs.io/en/stable/>' %}

### 1. Create a python app

Begin with a sample Flask app.

<script src="https://gist.github.com/bluebirz/636c5daddb70b0aa355268a5e54678a0.js?file=01-blank-flask.py"></script>

And install the requirements.

<script src="https://gist.github.com/bluebirz/636c5daddb70b0aa355268a5e54678a0.js?file=requirements.txt"></script>

It should show like this when execute.

![api](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data-contract-py/01-flask.png)

### 2. Read the contract

Start with just a single contract, `people`.

<script src="https://gist.github.com/bluebirz/636c5daddb70b0aa355268a5e54678a0.js?file=02-add-endpoint.py"></script>

As you see, at line 6-7 we are reading the contract file and store into variable `contract`.

### 3. Validate a request payload

<script src="https://gist.github.com/bluebirz/636c5daddb70b0aa355268a5e54678a0.js?file=03-validate-endpoint.py"></script>

- line 9: get the payload using `request.get_json()`.
- line 10: refer the raw contract at `/components/schemas/people`.
- line 11: validate the payload and raw contract using `jsonschema.validate()`.
- line 12: return `200` as "OK" when all process above is okay. Otherwise return "500 Internal Server Error" as below.

![call api](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data-contract-py/02-output-val-failed.png){:style="max-width:66%;margin:auto;"}

### 4. Handling errors

Hmmm the error above is bulky and unconcise. We should improve like this.

<script src="https://gist.github.com/bluebirz/636c5daddb70b0aa355268a5e54678a0.js?file=04-handle-validate-err.py"></script>

- If everything is okay, it should return `200` in `try` block.
- If there is a validation error, it should return `400` with message from `jsonschema.ValidationError.message` in the first `except` block.
- Anything else, return `400` and print the log into console.

### 5. Complete API with validation

<script src="https://gist.github.com/bluebirz/636c5daddb70b0aa355268a5e54678a0.js?file=05-single-endpoint-app.py"></script>

### 6. Test

#### a. The payload is fine

![fine](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data-contract-py/03-call-ok.png){:style="max-width:66%;margin:auto;"}

#### b. The payload has incorrect field type

![incorrect](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data-contract-py/04-call-failed-wrong-types.png){:style="max-width:66%;margin:auto;"}

#### c. The payload misses some required fields

![missing](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data-contract-py/05-call-failed-missing-req-field.png){:style="max-width:66%;margin:auto;"}

---

## Manage multiple contracts

A second ago we validate only `people` contract. Now we have `pets` and want to validate both.

Therefore, we can prepare a generic function like this.

<script src="https://gist.github.com/bluebirz/636c5daddb70b0aa355268a5e54678a0.js?file=06-generic.py"></script>

- line 8-13: read contract files and store in a `dict`, giving filename as keys.
- line 16-30: refactor the validation into a generic function, require contract key and payload as parameters.

And call this generic function from each endpoint.

<script src="https://gist.github.com/bluebirz/636c5daddb70b0aa355268a5e54678a0.js?file=07-call-generic.py"></script>

The complete code is here.

<script src="https://gist.github.com/bluebirz/636c5daddb70b0aa355268a5e54678a0.js?file=08-multiple-endpoint-app.py"></script>

Let's make a call to this API with an error expected.

![error](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data-contract-py/06-call-failed-pets.png){:style="max-width:66%;margin:auto;"}

Good. Our simple API with contract validation is ready.

---

## Repo

Full code is located here.

{% include bbz_custom/link_preview.html url='<https://github.com/bluebirz/sample-data-contracts-py>' %}
