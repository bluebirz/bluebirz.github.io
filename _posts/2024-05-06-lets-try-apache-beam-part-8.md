---
title: "Let's try: Apache Beam part 8 - Tags & Side inputs"
layout: post
author: bluebirz
description: We will get along together to see how can we design those complex ideas into a simple-readable yet powerful workflow.
date: 2024-05-06
categories: [data, data engineering]
tags: [Python, Apache Beam, side inputs, let's try]
series:
  key: beam
  index: 8
comment: true
image:
  path: https://images.unsplash.com/photo-1519320669750-579a8d7f1f6a?q=80&w=1959&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1519320669750-579a8d7f1f6a?q=10&w=1959&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Paulius Dragunas
  caption: <a href="https://unsplash.com/photos/antelope-grand-canyon-M2UXVaLlfds">Unsplash / Paulius Dragunas</a>
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

We sometimes have to apply some complex conditions in our Beam pipeline. This blog we will get along together to see how can we design those complex ideas into a simple-readable yet powerful workflow.

---

## Quest today

We are finding out preparing these books in the CSV:

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=08-books.csv"></script>

However, we also have a list of banned books' ISBN:

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=08-banned_book.txt"></script>

We have to group the books into one of these:

- "BANNED": any book in the ban list and is published after 1970 will be in this group. They will be sent to "Midnight library". Any that is published before or in 1970 will be unbanned.
- "ANTIQUE": any book which is published until 1970 will be in this group and will be sent to "Archive common library".
- "MODERATE": any book which is published in between 1971 and 2017 will be in this list and will be sent to "Central library".
- "MODERN": any book which is published since 2018 will be in this group and will be sent to "New Bloom library".

---

## Side inputs

First thing first, we are able to tell which book is in the ban list. One solution in order to add ban status into the book list is "Side inputs".

Side inputs are additional inputs we directly added into PTransform.

With side inputs, we are enabling a function to get more parameters.

For example:

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=08-book_banning.py"></script>

We are adding new key "is_banned" if the book's ISBN is in the "banned_book_list" parameter.

To call this `DoFn`, there are 2 ways.

1. Prepare an input **before** the pipeline.  

    <script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=08-main-pardo-sideinput-beforepipe.py"></script>

1. Prepare an input **inside** the pipeline.  

    <script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=08-main-pardo-sideinput-inpipe.py"></script>

> In case of preparing inside, side inputs cannot be PCollection so that we have to use `beam.pvalue.AsIter()` for many values (e.g. a list) or `beam.pvalue.AsSingleton()` for single value (e.g. integer).
{: .prompt-tip }

After the transformation with these side inputs, we are able to see the output like this:

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=08-after-sideinput.json"></script>

---

## Tagging

Now we have a ban flag in the book list. Next is to group or classify each book into each group.

It is the time to utilize tagging feature. This feature allows us to tag a value in each element of the PCollection.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=08-book_tagging.py"></script>

We apply the logic of grouping here and return transformed element and particular tag in each if-clause in the format `yield beam.pvalue.TaggedOutput(self.<tag>, element)`.

Tagging `DoFn` is ready and call it like this:

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=08-main-pardo-tag.py"></script>

- Look at line 12-16, adding `beam.ParDo(<DoFn>).with_outputs(<tags>)` is executing that `DoFn` and get elements with tags in return.
- Line 21 is that we can select a tag to perform some PTransformation by refering as a list, `PCollection[<tag>]`.

Example element after this step would be like this:

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=08-after-tag.json"></script>

---

## Write to files

Applying side inputs and tagging, it's ready to print out to files.

Example "BANNED" books:

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=08-updated_banned_book.csv"></script>

Example "MODERN" books:

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=08-updated_modern_book.csv"></script>

---

## Repo

{% include bbz_custom/link_preview.html url='<https://github.com/bluebirz/sample-beam/tree/main/08-tag-n-side-inputs>' %}

---

## References

- [Side input patterns](https://beam.apache.org/documentation/patterns/side-inputs/)
- [apache_beam.pvalue module](https://beam.apache.org/releases/pydoc/2.29.0/apache_beam.pvalue.html)
