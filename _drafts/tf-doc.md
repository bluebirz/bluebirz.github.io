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

---

{% include bbz_custom/link_preview.html url="<https://terraform-docs.io/>" %}

There are many ways of installation described in the link above. I prefer using [homebrew](https://formulae.brew.sh/formula/terraform-docs#default) or [winget](https://winget.run/pkg/Terraform-docs/Terraform-docs)

---

## Example usage

 cd to the Terraform directory first.

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
# cd into the Terraform module directory first

terraform-docs markdown table .
```

and the example result:

![markdown table dark]({{ page.media-folder }}markdown-table-dark.png){: .dark style="max-width:85%;margin:auto;" .apply-border}
![markdown table light]({{ page.media-folder }}markdown-table-light.png){: .light style="max-width:85%;margin:auto;" .apply-border}

{% endtab %}

{% tab format markdown-document %}

```sh
# cd into the Terraform module directory first

terraform-docs markdown document .
```

and the example result:

![markdown document dark]({{ page.media-folder }}markdown-document-dark.png){: .dark style="max-width:85%;margin:auto;" .apply-border}
![markdown document light]({{ page.media-folder }}markdown-document-light.png){: .light style="max-width:85%;margin:auto;" .apply-border}

{% endtab %}

{% endtabs %}

---

## Insert to README file

---

## Configuration file

{: file='.terraform-docs.yml' }

```yaml
formatter: "markdown table"
output:
  file: "./README.md"
  mode: inject
```

---

## Add into pre-commit

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
