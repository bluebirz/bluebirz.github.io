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

---

{% include bbz_custom/link_preview.html url="<https://terraform-docs.io/>" %}

brew install terraform-docs

```sh
$ terraform-docs markdown table .
## Requirements

...

## Providers

...

## Modules

...

## Resources

...

## Inputs

...

## Outputs

...
```

This is an example output of the `markdown table` format.

![example dark]({{ page.media-folder }}example-dark.png){: .dark style="max-width:85%;margin:auto;" .apply-border}
![example light]({{ page.media-folder }}example-light.png){: .light style="max-width:85%;margin:auto;" .apply-border}

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

## Apply into pre-commit
