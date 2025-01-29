---
title: "Let's try: Apache Beam part 2 - draw the graph"
layout: post
author: bluebirz
description: We can generate a DAG in visual figure using a few steps.
date: 2023-09-03 00:00:00 +0200
categories: [data, data engineering]
tags: [Python, Apache Beam, batch data processing, Graphviz, let's try]
series:
  key: beam
  index: 2
image:
  path: https://images.unsplash.com/photo-1519320669750-579a8d7f1f6a?q=80&w=1959&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Paulius Dragunas
  caption: <a href="https://unsplash.com/photos/antelope-grand-canyon-M2UXVaLlfds">Unsplash / Paulius Dragunas</a>
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

Continue to part 2.

As we know that Apache Beam pipeline will process like a waterfall from top to bottom, and also no cycle. This is what we call "DAG" or "Directed Acyclic Graph".

We write Beam code in Python and we also can generate a DAG in visual figure using a few steps.

---

## 1. Install Graphviz

`graphviz` is a common package for generating any diagram using DOT language. We need to install this first and there are many installation method depends on your platform. See all download list at <https://graphviz.org/download/>

For me, I prefer using `brew`.

```sh
brew install graphviz
```

Verify if graphviz has been installed properly with the command.

```sh
dot -V # capital `V`
```

Then we should see its version.

![graphviz](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p2/01-dot-v.png){:style="max-width:75%;margin:auto;"}

Read more about `brew` at link below.

{% include bbz_custom/link_preview.html post='2023-06-20-homebrew-one-place-for-all' %}

---

## 2. Apply `RenderRunner` in Beam

Now we go back to our Beam code and update the code like this.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=02-render.py"></script>

We are using `RenderRunner` to generate a DOT script for `graphviz`. Read more about this runner at [this doc](https://beam.apache.org/releases/pydoc/2.48.0/apache_beam.runners.render.html).

Also we put `beam.options.pipeline_options.PipelineOptions()` for the parameter `options` as well or it won't generate a figure.

---

## 3. Execute

Let's say we have a complete code like this one.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=02-render-sample.py"></script>

What we should do next is to run this with parameter `--render_output="<path>"`. For example:

```sh
python3 main.py --render_output="dag.png"
```

![execute](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p2/02-renderrunner.png){:style="max-width:75%;margin:auto;"}

Therefore we will see "dag.png" as follows.

![dag](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p2/03-dag_default.png){:style="max-width:75%;margin:auto;"}

However, if we name the step like this.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=02-render-sample-step-name.py"></script>

The figure it generated also has the name we put.

![dag 2](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p2/04-dag_name.png){:style="max-width:75%;margin:auto;"}

---

## Repo

{% include bbz_custom/link_preview.html url='<https://github.com/bluebirz/sample-beam/tree/main/02-graph>' %}
