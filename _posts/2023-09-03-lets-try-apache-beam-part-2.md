---
title: "Let's try: Apache Beam part 2 - draw the graph"
layout: post
description: We can generate a DAG in visual figure using a few steps.
date: 2023-09-03 00:00:00 +0200
categories: [data, data engineering]
tags: [Python, Apache Beam, batch data processing, Graphviz, let's try]
image:
  path: https://images.unsplash.com/photo-1519320669750-579a8d7f1f6a?q=80&w=1959&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Paulius Dragunas
  caption: <a href="https://unsplash.com/photos/antelope-grand-canyon-M2UXVaLlfds">Unsplash / Paulius Dragunas</a>
---

[expand-series]

  1. [Let's try: Apache Beam part 1 - simple batch]({% post_url 2023-08-30-lets-try-apache-beam-part-1 %})
  1. Let's try: Apache Beam part 2 - draw the graph
  1. [Let's try: Apache Beam part 3 - my own functions]({% post_url 2023-09-27-lets-try-apache-beam-part-3 %})
  1. [Let's try: Apache Beam part 4 - live on Google Dataflow]({% post_url 2023-10-10-lets-try-apache-beam-part-4 %})
  1. [Let's try: Apache Beam part 5 - transform it with Beam functions]({% post_url 2023-10-22-lets-try-apache-beam-part-5 %})
  1. [Let's try: Apache Beam part 6 - instant IO]({% post_url 2024-04-21-lets-try-apache-beam-part-6 %})
  1. [Let's try: Apache Beam part 7 - custom IO]({% post_url 2024-04-28-lets-try-apache-beam-part-7 %})
  1. [Let's try: Apache Beam part 8 - Tags & Side inputs]({% post_url 2024-05-06-lets-try-apache-beam-part-8 %})

[/expand-series]

Continue to part 2.

As we know that Apache Beam pipeline will process like a waterfall from top to bottom, and also no cycle. This is what we call "DAG" or "Directed Acyclic Graph".

We write Beam code in Python and we also can generate a DAG in visual figure using a few steps.

---

## 1. Install Graphviz

`graphviz` is a common package for generating any diagram using DOT language. We need to install this first and there are many installation method depends on your platform. See all download list at <https://graphviz.org/download/>

For me, I prefer using `brew`. Read more at [Homebrew - One place for all]({% post_url 2023-06-20-homebrew-one-place-for-all %})

```sh
brew install graphviz
```

Verify if graphviz has been installed properly with the command.

```sh
dot -V # capital `V`
```

Then we should see its version.

![graphviz](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p2/01-dot-v.png){:style="max-width:75%;margin:auto;"}

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
