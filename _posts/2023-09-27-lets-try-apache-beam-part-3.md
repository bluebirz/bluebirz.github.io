---
title: "Let's try: Apache Beam part 3 - my own functions"
layout: post
author: bluebirz
description: When it comes to complex transformations, we would design our flows to be more organized and clean.
date: 2023-09-27
categories: [data, data engineering]
tags: [Python, Apache Beam, batch data processing, let's try]
series:
  key: beam
  index: 3
comment: true
image:
  path: https://images.unsplash.com/photo-1519320669750-579a8d7f1f6a?q=80&w=1959&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1519320669750-579a8d7f1f6a?q=10&w=490&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Paulius Dragunas
  caption: <a href="https://unsplash.com/photos/antelope-grand-canyon-M2UXVaLlfds">Unsplash / Paulius Dragunas</a>
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

When it comes to complex transformations, we would design our flows to be more organized and clean. Yes, I'm talking about functions and classes.

How should we create and use them in Apache Beam?

---

## ParDo

`ParDo` is a function of Apache Beam to execute a given class to do some transformations. To implement `ParDo`, we can start from this syntax.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=03-syntax.py"></script>

### Custom class

We start from defining as class and inherits `beam.DoFn`. A required function here is `process()`. We need to implement this and Beam will call the function automatically.

There are some other functions we will see later.

### Main script

We can just import it and execute the custom class by `beam.ParDo(<class name>())`.

---

## Example

Let's say we are running Beam to transform a CSV as same as the last part but we want to use our own functions, also wrapped in a class.

Here it is. We have a class `CSVToDictFn`. It inherits `beam.DoFn` here. This class transforms from a row of CSV to a dict.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=03-CSVToDict-1.py"></script>

Then we go back to main and call the class, like this.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=03-main-1.py"></script>

It will call the function `process` itself.

Here is the output.

![output yield](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p3/01-simple-yield.png){:style="max-width:100%;margin:auto;" .apply-border}

Because `beam.ParDo` will accumulate the result in the end, we should use `yield` here where `yield` produces **an iterator of each element** while `return` returns **an iterator of all elements**.

This is what we will get if we use `return`. It is only the keys of the dictionary.

![output return](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p3/02-simple-return.png){:style="max-width:100%;margin:auto;" .apply-border}

---

## Example with parameters

Let's move to another level.

If we want to parse parameters to the class, we can implement `__init__()` to set them.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=03-CSVToDict-2-init.py"></script>

Here we have `CSVToDictFn` class. This version has `__init__()` to receive variable `schema`. The variable will be used to cast CSV fields to different types.

And we can call the class like this.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=03-main-2.py"></script>

We prepared `schema` at line 8 and call the class at line 23. When calling the class, we also parse `schema` in the parentheses.

The logic of this version of `CSVToDictFn` is to get field names, field types, and value, map with `zip` and construct a dictionary. This can be illustrated as the following figure.

![flow](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p3/schema_zip.drawio.png){:style="max-width:100%;margin:auto;" .apply-border}

---

## Repo

{% include bbz_custom/link_preview.html url='<https://github.com/bluebirz/sample-beam/tree/main/03-functions>' %}
