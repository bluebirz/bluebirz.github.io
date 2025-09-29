---
title: "Terraform-docs: generate docs for Terraform"
layout: post
author: bluebirz
description:
# date:
categories: [devops, IaaC]
tags: [Terraform, terraform-docs]
pin: true
comment: true
series:
  key: terraform
  index: 10
image:
  path: assets/img/features/external/tfdoc-banner.png
  lqip: ../assets/img/features/lqip/external/tfdoc-banner.webp
  alt: terraform-docs
  caption: <a href="https://terraform-docs.io">terraform-docs</a>
media-folder: ../assets/img/tmp/tfdocs/
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

{% include bbz_custom/tabs.html %}

We can develop Terraform projects, build and enable modules in our infrastructure. We should have some place to describe our works and let people understand what we made and our team can comprehend so easily in a glance. This will benefit us for better maintenance and monitoring.

---

## `terraform-docs`

`terraform-docs` is a tool to generate documentation from our Terraform project in various formats. It can extract modules, resources, providers, and much more to a single file where we can read and understand it.

This is the homepage of `terraform-docs`.

{% include bbz_custom/link_preview.html url="<https://terraform-docs.io/>" %}

There are many ways of installation described in the link above. I prefer using [homebrew](https://formulae.brew.sh/formula/terraform-docs#default) or [winget](https://winget.run/pkg/Terraform-docs/Terraform-docs).

---

## Example usage

It's so simple to use `terraform-docs` by supply format we would like or a configuration file and the path of Terraform directory.

```sh
# specify format 
terraform-docs [format] [flags] [path]

# specify config file
terraform-docs -c [config file] [path]
```

---

## Formats

There are plenty of formats we can generate with this tool. Markdown, AsciiDoc, JSON, YAML, or just pretty print to console are available.

To me as one who like to write in Markdown, so I usually do it in that format especially in table style.

{% tabs format %}

{% tab format markdown-table %}

```sh
# syntax
terraform-docs markdown table <terraform directory>

# example
terraform-docs markdown table .
```

and the example result:

![markdown table dark]({{ page.media-folder }}markdown-table-dark.png){: .dark style="max-width:85%;margin:auto;" .apply-border}
![markdown table light]({{ page.media-folder }}markdown-table-light.png){: .light style="max-width:85%;margin:auto;" .apply-border}

{% endtab %}

{% tab format markdown-document %}

```sh
# syntax 
terraform-docs markdown document <terraform directory>

# example
terraform-docs markdown document .
```

and the example result:

![markdown document dark]({{ page.media-folder }}markdown-document-dark.png){: .dark style="max-width:85%;margin:auto;" .apply-border}
![markdown document light]({{ page.media-folder }}markdown-document-light.png){: .light style="max-width:85%;margin:auto;" .apply-border}

{% endtab %}

{% endtabs %}

---

## Insert to README file

We can insert the doc into the README file by 2 steps.

1. add this comment block into the file.

    {: file='README.md' }

    ```md
    <!-- BEGIN_TF_DOCS -->
    <!-- END_TF_DOCS -->
    ```

2. run the command

    ```sh
    terraform-docs markdown [table|document] <terraform directory> --output-file <output filepath> --output-mode inject
    ```

Then we can see the example like this.

{: file='README.md' }

```md
# README

lorem ipsum

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 3.5 |

...

<!-- END_TF_DOCS -->
```

However, there is another output mode that is `--output-mode replace`. This mode will replace all the content with the generated doc.

---

## Configuration file

There are lots of customization that we can pack them all in a single configuration file and apply like this.

```sh
terraform-docs -c .terraform-docs.yml <terraform directory>
```

This is an example configuration file.

{: file='.terraform-docs.yml' }

```yaml
formatter: "markdown table"
output:
  file: "./README.md"
  mode: inject
```

For more details, please visit the site below.

{% include bbz_custom/link_preview.html url="<https://terraform-docs.io/user-guide/configuration/>" %}

---

## Add into pre-commit

As I shared about `pre-commit` blog before([here]({% post_url 2025-08-09-try-pre-commit %})), we can include `terraform-docs` into our `pre-commit` hooks like this.

{: file='pre-commit-config.yaml' }

```yaml
repos:
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: "v1.99.5"
    hooks:
      - id: terraform_docs
        args:
          - --args=--config=.terraform-docs.yml

```
