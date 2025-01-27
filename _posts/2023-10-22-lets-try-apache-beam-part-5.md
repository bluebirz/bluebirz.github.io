---
title: "Let's try: Apache Beam part 5 - transform it with Beam functions"
layout: post
description: We are going to see what functions we can try on our problems.
date: 2023-10-22 00:00:00 +0200
categories: [data, data engineering]
tags: [Python, Apache Beam, batch data processing, let's try]
image:
  path: https://images.unsplash.com/photo-1519320669750-579a8d7f1f6a?q=80&w=1959&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Paulius Dragunas
  caption: <a href="https://unsplash.com/photos/antelope-grand-canyon-M2UXVaLlfds">Unsplash / Paulius Dragunas</a>
---

[expand-series]

  1. [Let's try: Apache Beam part 1 - simple batch]({% post_url 2023-08-30-lets-try-apache-beam-part-1 %})
  1. [Let's try: Apache Beam part 2 - draw the graph]({% post_url 2023-09-03-lets-try-apache-beam-part-2 %})
  1. [Let's try: Apache Beam part 3 - my own functions]({% post_url 2023-09-27-lets-try-apache-beam-part-3 %})
  1. [Let's try: Apache Beam part 4 - live on Google Dataflow]({% post_url 2023-10-10-lets-try-apache-beam-part-4 %})
  1. Let's try: Apache Beam part 5 - transform it with Beam functions
  1. [Let's try: Apache Beam part 6 - instant IO]({% post_url 2024-04-21-lets-try-apache-beam-part-6 %})
  1. [Let's try: Apache Beam part 7 - custom IO]({% post_url 2024-04-28-lets-try-apache-beam-part-7 %})
  1. [Let's try: Apache Beam part 8 - Tags & Side inputs]({% post_url 2024-05-06-lets-try-apache-beam-part-8 %})

[/expand-series]

Apache beam has many transformations out of the box. This blog we are going to see what functions we can try on our problems, and it may be useful for us not to waste time for.

---

## Preparations

This blog we will use the CSV file of 30 people. This.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=05-people.csv"></script>

It contains ID, name, gender, occupation, team, and age.

Also prepare a same method to transform a CSV to dict.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=03-CSVToDict-2-init.py"></script>

---

## Example 1: Women in teams

We want to see list of female in each team.

![Example 1](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p5/05-a.png)

Steps of thought:

1. Read a file and `beam.ParDo()` to transform it to a dict.
1. Perform `beam.Filter()` to get only female.
1. `beam.GroupBy()` to group them based on "team".
1. `beam.Map()` with the function `custom_print()` which displays team and people in the team.  

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=05-a-groupby.py"></script>

- At line 33, `beam.GroupBy()` requires a function to determine what property in an element is a key to be grouped.

---

## Example 2: How many men and women?

We want to see number of men and women in the list.

![Example 2](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p5/05-b.png){:style="max-width:75%;margin:auto;"}

Steps of thought:

1. Read a file and `beam.ParDo()` to transform it to a dict.
1. Group them based on "gender" using `beam.Partition()`.
1. For male, count the male group with `beam.combiners.Count.Globally()` and print out.
1. For female, do the same.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=05-b-partition-count.py"></script>

- `beam.Partition()` requires a function to determine a number of each partition.  
  In this case, we give the number by index via `list.index()`, it was `genders.index()` at line 31.
- `beam.combiners.Count.Globally()` returns a number of elements in the PCollection at line 36, 41.

We perform **branching** here by applying parentheses with different PCollections from the previous step.

As we can see, we have "male_people" and "female_people" PCollections after the 2nd PTransform. After that we use them as initial PCollection of the later blocks.

This can be rendered like this.

![dag](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p5/dag_partition_count.png){:style="max-width:75%;margin:auto;"}

See how to generate a DAG as above at [Let's try: Apache Beam part 2 - draw the graph]({% post_url 2023-09-03-lets-try-apache-beam-part-2 %})

---

## Example 3: Numbers of occupation

We want to see list of single word occupation and number of occurrence.

![Example 3](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p5/05-c.png){:style="max-width:75%;margin:auto;"}

Steps of thought:

1. Read a file and `beam.ParDo()` to transform it to a dict.
1. Split "occupation" into words with `beam.FlatMap()` and `str.split()`.
1. Cleanse all non-alphanumeric with `beam.Regex.replace_all()`.
1. Transform to lowercase with `beam.Map()`.
1. Retrieve only occupation vocabularies with `beam.Regex.matches()`.
1. Group and count number of occurrence using `beam.combiners.Count.PerElement()`.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=05-c-flatmap-regex-countelem.py"></script>

- line 31, `beam.FlatMap()` accepts a function that returns iterable then transform it to PCollection.  
  For example, we have a string "Administrator, charities/voluntary organisations". Then split to ["Administrator", "charities/voluntary", "organisations"]. This list will become a PCollection.
- line 32, `beam.Regex.replace_all()` replace all occurrence in an element to a given string, validated by a Regex.  
  In this case we replace all non-alphanumeric (`r"[^\w\d]"`) to an empty string, implying remove it.
6- line 35, `beam.Regex.matches()` filters elements based on a Regex.  
  In this case we accepts words starting with first 4 letters or more and ends with "ist", "er", "or", "ian", or "ant".
- line 36, `beam.combiners.Count.PerElement()` returns a PCollection of unique elements with their number of occurrences.

Read more about Regex [here]({% post_url 2021-02-27-regex-is-sexy %}),

---

## Example 4: The oldest in a group

We want to see how old of the oldest per team per gender.

![example 4](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/beam/p5/05-d.png){:style="max-width:75%;margin:auto;"}

Steps of thought:

- Read a file and `beam.ParDo()` to transform it to a dict.
- Transform with `beam.Map()` to tuples in format "(team-gender, age)".
- Group with `beam.CombinePerKey()` and supply `max` to return max age of each group.

<script src="https://gist.github.com/bluebirz/c77aa2a47e3e782959bcab4b0d34a7d4.js?file=05-d-combineperkey.py"></script>

- line 32, `beam.CombinePerKey()` requires a PCollection having a key and value.  
  In this case we have key as "team-gender" and the value as "age", the function will group keys together and execute `max` on the value, then return unique keys with `max` of "age".

---

## Repo

I have concluded source code in the repo here.

{% include bbz_custom/link_preview.html url='<https://github.com/bluebirz/sample-beam/tree/main/05-beam-transform>' %}

---

## Reference

- [Python transform catalog overview](https://beam.apache.org/documentation/transforms/python/overview/)
