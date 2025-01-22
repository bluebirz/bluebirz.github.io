---
title: A private repo for our own Python packages
layout: post
description: Google Artifact Registry is a service from Google to store an image, a module in Python, NodeJS, and much more.
date: 2023-03-25 00:00:00 +0200
categories: []
tags: []
image:
  path: ../assets/img/features/ashin-k-suresh-mkxTOAxqTTo-unsplash.jpg
  alt: Unsplash / Ashin K Suresh
  caption: <a href="https://unsplash.com/photos/a-lit-up-box-sitting-on-top-of-a-table-mkxTOAxqTTo">Unsplash / Ashin K Suresh</a>
---

Functions are very common in programming schemes. They are useful for repeated operations and readability. Then, what if we have to add the same functions into our programs for many?

Imagine we have many projects in our hands, and some of them need a same function. We might end up copying that same function into each. That will be a redundancy problem which mean we probably have to maintain the function multiple times based on number of copies.

---

## Talk a basic one

Let's say we have files like this.

<script src="https://gist.github.com/bluebirz/88927b7f719c0e1610a636ff66641336.js?file=local-structure.md"></script>

We have a function to sum all integers in a list here in "adder.py".

<script src="https://gist.github.com/bluebirz/88927b7f719c0e1610a636ff66641336.js?file=local-adder.py"></script>

We can import it into a main program "main.py" like this.

<script src="https://gist.github.com/bluebirz/88927b7f719c0e1610a636ff66641336.js?file=local-main.py"></script>

Run and the output should be like the following.

![local adder](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/custom-py-modules/00-start.png)

But, how could we share this adder function for the team?

---

Introducing...

## Google Artifact Registry

Google Artifact Registry is a service from Google to store an image, a package in Python, NodeJS, and much more (see full list [here](https://cloud.google.com/artifact-registry/docs/supported-formats).)

We now use it to store our functions. Here is the list of our missions today.

1. Build a package and upload to Google Artifact Registry repository
1. Prepare setting to access the repo
1. Install the package
1. Test if we can import the package successfully

Let's go!

### 1. Build and upload

#### 1.1 Prepare a repository in Google Artifact Registry

- Make sure the API is enabled, otherwise enable it.

![GAR api](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/custom-py-modules/01-enable-api.png){:style="max-width:50%;margin:auto;"}

- Create a repo. Feel free to use the web console, but this time we use gcloud command.

```sh
gcloud artifacts repositories create {REPO-NAME} --repository-format=python --location={LOCATION}
```

![repo create](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/custom-py-modules/02-create-repo.png){:style="max-width:66%;margin:auto;"}

- Verify if the repo is ready

![repo created](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/custom-py-modules/03-ui-repo.png){:style="max-width:66%;margin:auto;"}

#### 1.2 Prepare a package

Install libraries.

<script src="https://gist.github.com/bluebirz/88927b7f719c0e1610a636ff66641336.js?file=artifact-requirements.txt"></script>

Setup files for packaging.

<script src="https://gist.github.com/bluebirz/88927b7f719c0e1610a636ff66641336.js?file=artifact-structure.md"></script>

- "LICENSE"  
    <script src="https://gist.github.com/bluebirz/88927b7f719c0e1610a636ff66641336.js?file=artifact-license"></script>
- "README.md"  
    <script src="https://gist.github.com/bluebirz/88927b7f719c0e1610a636ff66641336.js?file=artifact-readme.md"></script>
- "pyproject.toml"  
    <script src="https://gist.github.com/bluebirz/88927b7f719c0e1610a636ff66641336.js?file=artifact-pyproject.toml"></script>
- src files.  
  Should have a folder with same name as project name in pyproject.toml at line #6 to avoid naming mistakes.
- test files.
  Can be empty at this moment.

#### 1.3 Build the package
