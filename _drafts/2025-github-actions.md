---
title: "Let's try: Github actions in action"
layout: post
author: bluebirz
description:
# date: 
categories: []
tags: []
mermaid: false
comment: true
image:
  path: assets/img/features/bluebirz/ghact.drawio.png
  lqip: ../assets/img/features/lqip/bluebirz/ghact.drawio.webp
  alt: Github actions icon 
  caption: 
media_subpath: 
---


- Workload Identity Federation
- sample yaml file
- github workflow with gcp checkout

## h2

---

## What is "Github Actions"?

---

## Start a first action

### Create a workflow file

```sh
mkdir -p .github/workflows
touch sample.yml
```

So we should have the file in the structure like this.

```md
.
└── .github
    └── workflows
        └── sample.yml
```

### Simple echo

```yaml
name: "Sample workflow"

on:
  workflow_dispatch:

jobs:
  prepare:
    name: "prepare"
    runs-on: ubuntu-latest
    steps:
      - name: simple echo
        run: >
          echo "hello world"
```

### Review the workflow

![action-page](../assets/img/tmp/01-action-page.png){: style="max-width:66%;margin:auto;"}

> New workflow can be found when the workflow files are ready in the default branch.
{: .prompt-tip }

![run wokflow](../assets/img/tmp/02-try-run.png){: style="max-width:75%;margin:auto;"}

![run complete](../assets/img/tmp/03-run-complete.png)

### Review results

![run dag](../assets/img/tmp/04-run-dag.png)

![dag output](../assets/img/tmp/05-dag-output.png)

### Variables

---

## Work with Google Cloud

### Authentication

Workload Identity Federation allows you to authenticate to Google Cloud without needing to store long-lived credentials in your GitHub repository. Instead, you can use short-lived tokens that are automatically generated.

### Checkout step

### Simple gcloud commands

---

## References

- [google-github-actions/auth: A GitHub Action for authenticating to Google Cloud.](https://github.com/google-github-actions/auth)
- [Workload Identity Federation  \|  IAM Documentation  \|  Google Cloud](https://cloud.google.com/iam/docs/workload-identity-federation)
- [Quickstart for GitHub Actions - GitHub Docs](https://docs.github.com/en/actions/get-started/quickstart)
- <https://github.com/actions/runner?tab=readme-ov-file>
