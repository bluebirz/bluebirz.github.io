---
title: "Let's try: Github actions for Github integration"
layout: post
author: bluebirz
description: "With Github Actions, our CI/CD directly connect to Github repo and able to deploy to our GCP services"
# date: 
categories: [devops, integration]
tags: [Google Cloud Platform, Github, CI/CD, Github Actions, Workload Identity Federation, Terraform, OIDC]
mermaid: true
comment: true
image:
  path: assets/img/features/bluebirz/ghact.drawio.png
  lqip: ../assets/img/features/lqip/bluebirz/ghact.drawio.webp
  alt: Github actions icon 
  caption: 
media_subpath: 
---

Speaking of CI/CD tools, I have some [old blogs about Google Cloud Build]({{ site.url }}/tags/google-cloud-build). But today we come to talk about another popular CI/CD tool which comes with Github, that is "Github Actions".

---

## What is "Github Actions"?

Github Actions is a CI/CD tool comes with Github. When we implemented our own apps in Github repositories, we can use this tool out-of-the-box. Similar to Google Cloud Build, we can control our workflows to run, test, and deploy with simple YAML files.

This is an official page of Github Actions.

{% include bbz_custom/link_preview.html url="<https://github.com/features/actions>" %}

---

## Start a first action

Github Actions just needs YAML files inside `.github/workflows` directory so we're gonna create a very simple workflow in one YAML file.

### 1. Create a workflow file

The command below will create an empty file inside that directory.

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

### 2. Simple echo

We edit the content of `.github/workflows/sample.yml` file to just say "hello world", like this.

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

- `name` is a name of this Github workflow.
- `on` is an event to run this workflow and `workflow_dispatch` means we can run this workflow manually.
- `jobs` is a section we define each of our jobs.
  - `prepare` is a job name as a local reference.
  - `name` here is the job name to display in the Github Actions page.
  - `runs-on` is an OS image to run this job. We can use `ubuntu-latest`, `windows-latest`, or `macos-latest` runners.
  - `steps` is a list of steps we want to execute in this job.

### 3. Review the workflow

When we commit and push it to the default branch, we can find the new workflow here at the "Actions" tab of the repository.

![action-page](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/github-actions/01-action-page.png){: style="max-width:66%;margin:auto;"}

> New workflow can be found when the workflow files are ready in the default branch[^defaultbranch][^thomas] or a pull request that have it if the trigger is on `pull_request`.  
> Find out the default branch at the "Settings" tab, under "Branches" section.
{: .prompt-tip }

As we set `on` event to `workflow_dispatch`, this means we can run this workflow manually by selecting the branch and clicking the "Run workflow" button.

![run wokflow](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/github-actions/02-try-run.png){: style="max-width:95%;margin:auto;"}

When the job ran completely (or failed), we can see the status and the job history like this.

![run complete](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/github-actions/03-run-complete.png){: style="max-width:95%;margin:auto;"}

### 4. Review results

When we clicked the job name, we can see the details of the job.

This job names "prepare" and has only one step, "simple echo" so we can see only one box.

![run dag](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/github-actions/04-run-dag.png){: style="max-width:95%;margin:auto;"}

Clicking the "prepare" box will show the output of the step. There is "hello world" under the "simple echo" step.

![dag output](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/github-actions/05-dag-output.png){: style="max-width:95%;margin:auto;"}

---

## Some more configs

### Variables

We can define variables

```yaml
env:
  text: "Hello world."
```

And reference them in the workflow like this.

{% raw %}

```yaml
env:
  text: "Hello world."

jobs:
  prepare:
    name: "prepare"
    runs-on: ubuntu-latest
    steps:
      - name: simple echo
        run: |
          echo "${{ env.text }}"
```

{% endraw %}

We can also embed variables[^embvars] in the repo at "Settings" tab &rarr; "Security" section &rarr; "Secrets and variables" &rarr; "Actions".

### Trigger events

```yaml
on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main
  workflow_dispatch: # manual trigger
```

There are several events to trigger[^trigger] the workflow.

- `push` event will trigger the workflow when we push to the given branch. It's `main` branch in the example above.
- `pull_request` event will trigger when we create a pull request to the given branch. It's also a `main` branch in the example.
- `workflow_dispatch` event to run manually.

### Job details

{% raw %}

```yaml
jobs:
  <job_name>:
    name: "<job_name>"
    runs-on: <runner>
    needs: <job_name> # optional, to run after another job
    environment: <environment_name> # optional, to run in a specific environment
    steps:
      - name: "<step_name>"
        run: |
          <commands>
    outputs: # optional, to define outputs for the job
      <output_name>: "<output_value>"
```

{% endraw %}

Under `jobs`, we can define each job and its details[^wfsyntax]:

- `name`: name of the job to display.
- `runs-on`: the runner to run this job. It can be `ubuntu-latest`, `windows-latest`, or `macos-latest`.
- `needs`: one or more job names to run before this job as dependencies.
- `environment`: a specific environment to run this job.
- `steps`: a list of steps to run.
  - `name`: name of the step.
  - `run`: commands to run in this step.
- `outputs`: outputs of the job in case we want to parse to other jobs.

---

## Work with Google Cloud

Now we are at the core. When it comes to CI/CD, we usually have to integrate it with some platforms such as GCP.

In this blog, we are going to implement a simple Github workflow to check Google Cloud Storage files through GCP Workload Identity Federation. We need to understand how can we authenticate and let's see together.

### Workload Identity Federation

Workload Identity Federation[^wif] allows us to securely authenticate to Google Cloud Platform without service account keys or other risky methods if we lose them. Instead, we use short-lived tokens as an identity, including impersonating service accounts.

 When the setup is ready, our Github actions can connect to the GCP as this diagram.

```mermaid
sequenceDiagram
  autonumber

  box Google Cloud
    participant WIP as Workload Identity Pool
    participant WIPP as Workload Identity<br/>Pool Provider
    participant SA as GCP Service Account
  end
  
  box Github
    participant GHA as Github Actions
  end

  alt setup
    WIP ->> WIPP : contains
    SA ->> WIPP : binding with principal<br/>or principal set
  end
  GHA ->> SA : uses
    SA ->> WIPP : authorize
  activate WIPP
  WIPP ->> GHA : access token
  deactivate WIPP
```

There are many ways to setup the GCP Workflow Identity Federation e.g. gcloud CLI[^gcpblog]. This blog will use Terraform[^tf] to create the resources.

### Create Workflow Identity Federation resources

1. First, we need a GCP Workload Identity Pool. This resource is currently in `google-beta` provider.

    ```terraform
    resource "google_iam_workload_identity_pool" "my_github_pool" {
      provider = google-beta

      workload_identity_pool_id = "pool-id"
      display_name              = "pool-name"
      description               = "Identity pool operates in FEDERATION_ONLY mode for testing purposes"
    }
    ```

    > Deleting a pool has 30 days of grace period which means the deleted pool can be restored and we can't create a new pool with the same name for the certain period[^delpool].
    {: .prompt-warning }

1. Next is the provider in the pool. There are many ways to setup `attribute_condition` and this time I set the condition to be repo owner[^attribcond].

    ```terraform
    resource "google_iam_workload_identity_pool_provider" "my_github_provider" {
      provider = google-beta

      workload_identity_pool_id          = google_iam_workload_identity_pool.my_github_pool.workload_identity_pool_id
      workload_identity_pool_provider_id = "provider-id"
      display_name                       = "provider-name"
      description                        = "Provider for GitHub Actions to access Google Cloud resources"
      attribute_condition                = "assertion.repository_owner == 'owner'"
      attribute_mapping = {
        "google.subject"             = "assertion.sub"
        "attribute.actor"            = "assertion.actor"
        "attribute.repository"       = "assertion.repository"
        "attribute.repository_owner" = "assertion.repository_owner"
      }
      oidc {
        issuer_uri = "https://token.actions.githubusercontent.com"
      }
    }
    ```

    > Deleting a provider has 30 days of grace period which means the deleted provider can be restored and we can't create a new provider with the same name for the certain period[^delprovider].
    {: .prompt-warning }

1. Third, create a service account to connect to the provider.

    ```terraform
    resource "google_service_account" "my_service_account" {
      account_id   = "service-account-id"
      display_name = "service-account-name"
      description  = "Service account for GitHub Actions to access Google Cloud resources"
    }
    ```

1. We are binding the service account with the role `roles/iam.workloadIdentityUser` as a user of the provider.  
    `members` must be either `principal` or `principalSet`[^principaltypes] and assign the corresponding principal identifier[^saconn]. There are some forums[^soferr][^ghacterr] in case of the errors from incorrect `members`.

    ```terraform
    resource "google_service_account_iam_binding" "github_actions_sa_member" {
      service_account_id = google_service_account.my_service_account.name
      role               = "roles/iam.workloadIdentityUser"
      members            = ["principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.my_github_pool.name}/attribute.repository_owner/owner"]
    }
    ```

1. Last, we grant Service Account Token Creator role for impersonation and other necessary roles.

    ```terraform
    resource "google_project_iam_member" "github_actions_sa_iam_roles" {
      for_each = toset([
        "roles/iam.serviceAccountTokenCreator",
        "roles/storage.admin",
      ])
      role   = each.value
      member = "serviceAccount:${google_service_account.my_service_account.email}"
    }
    ```

### Create Github Actions with GCP provider

Let's say we have completed the setup and it's the time to create a Github Actions to do something with GCP services.

1. prepare credentials

    ```yaml
    env:
      PROJECT_ID: <project_id>
      WLID_PROVIDER: projects/<project_number>/locations/global/workloadIdentityPools/<pool_id>/providers/<provider_id>
      SA_EMAIL: <service_account>@<project_id>.iam.gserviceaccount.com
    ```

    We need project id, project number, pool id, provider id, and service account email.

    > The project number (e.g. `projects/123456789/`) is required to authenticate to the provider, or we could see an error when authenticating.
    {: .prompt-warning }

1. checkout[^checkout] first and the workflow can access and fetch the repo.

    ```yaml
    steps:
      - name: Checkout
        uses: actions/checkout@v3
    ```

1. authenticate to GCP[^auth] with the service account.

    {% raw %}

    ```yaml
      - name: Authenticate to Google Cloud
        uses: google-github-actions/auth@v2
        with:
          workload_identity_provider: ${{ env.WLID_PROVIDER }}
          project_id: ${{ env.PROJECT_ID }}
          service_account: ${{ env.SA_EMAIL }}
    ```

    {% endraw %}

1. setup gcloud[^setupgcloud] to configure Google SDK into the Github Actions environment.

    {% raw %}

    ```yaml
      - name: Setup GCloud
        uses: google-github-actions/setup-gcloud@v2
        with:
          project_id: ${{ env.PROJECT_ID }}
    ```

    {% endraw %}

### Example result

At the step "List files", I run `gcloud storage ls gs://...` and it successfully returns a list of folders and files in that path.

![gcp action](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/github-actions/06-gcp.png){:style="max-width:75%;margin:auto;"}

### Debug OIDC Claims

OIDC or OpenID Connect[^oidcgh][^oidcgcp] is a protocol to verify the identity of the user or service. At the step of creating provider, we set OIDC URI to be Github that means Github will send a token to GCP to verify.

However, when we have issues with OIDC claims, we can add this step of "actions-oidc-debugger"[^debug] to debug OIDC claims in order to investigate values and other issues in authentication.

{% raw %}

```yaml
  - name: Debug OIDC Claims
    uses: github/actions-oidc-debugger@main
    with:
      audience: "${{ github.server_url }}/${{ github.repository_owner }}"
```

{% endraw %}

---

## Repo

I have setup both Terraform and Github Actions in the repo below.

{% include bbz_custom/link_preview.html url='<https://github.com/bluebirz/sample-github-actions>' %}

---

## References

[^checkout]: [actions/checkout: Action for checking out a repo](https://github.com/actions/checkout)
[^auth]: [google-github-actions/auth: A GitHub Action for authenticating to Google Cloud.](https://github.com/google-github-actions/auth)
[^soferr]: [google cloud platform - github actions to GCP OIDC error: 403 'Unable to acquire impersonated credentials' \[principalSet mismatch with the Subject claim\] - Stack Overflow](https://stackoverflow.com/questions/76346361/github-actions-to-gcp-oidc-error-403-unable-to-acquire-impersonated-credential)
[^ghacterr]: [Github actions 'Unable to acquire impersonated credentials' from GCP OIDC: error403 \[principalSet mismatch with the Subject claim\] · Issue #310 · google-github-actions/auth](https://github.com/google-github-actions/auth/issues/310)

[^principaltypes]: [Principal types](https://cloud.google.com/iam/docs/workload-identity-federation#principal-types)
[^delpool]: [Delete a pool](https://cloud.google.com/iam/docs/manage-workload-identity-pools-providers#delete-pool)
[^delprovider]: [Delete a provider](https://cloud.google.com/iam/docs/manage-workload-identity-pools-providers#delete-provider>)
[^saconn]: [Allow your external workload to access Google Cloud resources](https://cloud.google.com/iam/docs/workload-download-cred-and-grant-access?_gl=1*1wpewb4*_ga*MTQ0ODU0NDYzMy4xNjc4NjM4OTE0*_ga_WH2QY8WWF5*czE3NTI2OTU1NjckbzE5JGcxJHQxNzUyNjk1NzE3JGoxMSRsMCRoMA..#service-account-impersonation)

[^gcpblog]: [Secure your use of third party tools with identity federation \| Google Cloud Blog](https://cloud.google.com/blog/products/identity-security/secure-your-use-of-third-party-tools-with-identity-federation)
[^debug]: [github/actions-oidc-debugger: An Action for printing OIDC claims in GitHub Actions.](https://github.com/github/actions-oidc-debugger)
[^trigger]: [Triggering a workflow - GitHub Docs](https://docs.github.com/en/actions/how-tos/writing-workflows/choosing-when-your-workflow-runs/triggering-a-workflow)
[^wif]: [Workload Identity Federation  \|  IAM Documentation  \|  Google Cloud](https://cloud.google.com/iam/docs/workload-identity-federation)
[^setupgcloud]: [google-github-actions/setup-gcloud: A GitHub Action for installing and configuring the gcloud CLI.](https://github.com/google-github-actions/setup-gcloud?tab=readme-ov-file)
[^tf]: [google_iam_workload_identity_pool_provider \| Resources \| hashicorp/google \| Terraform \| Terraform Registry](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool_provider)
[^wfsyntax]: [Workflow syntax for GitHub Actions - GitHub Docs](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)
[^embvars]: [Store information in variables - GitHub Docs](https://docs.github.com/en/actions/reference/variables-reference)
[^defaultbranch]: [Workflow is not shown so I cannot run it manually (Github Actions) - Stack Overflow](https://stackoverflow.com/a/71423764)
[^thomas]: [Running a GitHub Actions workflow that doesn't exist yet on the default branch - Thomas Levesque's .NET Blog](https://thomaslevesque.com/2024/04/25/running-a-github-actions-workflow-that-doesnt-exist-yet-on-the-default-branch/)
[^attribcond]: [Define an attribute condition](https://cloud.google.com/iam/docs/workload-identity-federation-with-deployment-pipelines#conditions)
[^oidcgh]: [Configuring OpenID Connect in cloud providers - GitHub Docs](https://docs.github.com/en/actions/how-tos/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-cloud-providers)
[^oidcgcp]: [Configure Workload Identity Federation with other identity providers  \|  IAM Documentation  \|  Google Cloud](https://cloud.google.com/iam/docs/workload-identity-federation-with-other-providers)
