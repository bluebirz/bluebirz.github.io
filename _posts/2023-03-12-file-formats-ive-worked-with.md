---
title: "File formats I've worked with"
layout: post
description: There are various file formats in this field of work and now I am going to tell some major formats I have worked with.
date: 2023-03-12 00:00:00 +0200
categories: [programming, tools]
tags: [CSV, JSON, JSONL, Parquet, YAML, YML, Python, Pandas, PyArrow]
image:
  path: https://images.unsplash.com/photo-1611764553921-437fb44f747a?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / David Bruno Silva
  caption: <a href="https://unsplash.com/photos/blue-yellow-red-and-green-papers-Z19vToWBDIc">Unsplash / David Bruno Silva</a>
---

{% include bbz_custom/styling-columns.html %}

Files are mandatory when we talk about data things. Most common thing is file in which we keep data and program configurations.

There are various file formats in this field of work and now I am going to tell some major formats I have worked with.

Let's start now.

---

## CSV

CSV stands for "**C**omma-**S**eparated **V**alues" ([wiki](https://en.wikipedia.org/wiki/Comma-separated_values)). I am greatly certain we are most familiar with this because this file format is the most basic one we have to engage with.

Characteristic of CSV is straightforward yet fuzzy.

- It contains a line of header at the first row (sometimes not).
- It requires a separator as basically comma (sometimes as pipe `|` or semi-colon `;`).
- It needs an exact number of values out of separators all along the file including the header. It must be a solid schema.
- In case a value contains the separator symbol, it must be encapsulated with double-quotes `""`, or the file can't be read at that line due to inconsistent schema.

However, this is a base format we have to work with from its own readability and ease to update values.

<script src="https://gist.github.com/bluebirz/f5efdd35f392cfe93faa9db39e452e26.js?file=sample-csv.csv"></script>

I would love to recommend this extension when work with CSV file on VSCode. This can help us verify schemas, columns, values of the opened CSV file at a good level. It is [Rainbow CSV](https://marketplace.visualstudio.com/items?itemName=mechatroner.rainbow-csv).

A good use of them is to align columns... and hover the mouse to see what column it is.

![rainbow-csv](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/file-formats/csv-rainbow-palette.png){:style="max-width:66%;margin:auto;"}

<div class="row">
    <div class="col-2">
        <img src="https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/file-formats/csv-rainbow-align.png" alt="before rainbow-csv" loading="lazy">
        <em>from this</em>
    </div>
 <div class="col-2">
        <img src='https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/file-formats/csv-rainbow-hover.png' alt="after rainbow-csv" loading="lazy">
        <em>to this</em>
    </div>
</div>

Besides, this is an example Python code when we want to write a `dict` into a CSV file. The easiest way is to use module `csv`.

<script src="https://gist.github.com/bluebirz/f5efdd35f392cfe93faa9db39e452e26.js?file=write-csv.py"></script>

And when I read a CSV file, I prefer module `pandas`.

<script src="https://gist.github.com/bluebirz/f5efdd35f392cfe93faa9db39e452e26.js?file=read-csv.py"></script>

---

## JSON

JSON stands for "**J**ava**S**cript **O**bject **N**otation" ([json.org](https://www.json.org/json-en.html)). This format is popular for any purposes from its pattern which is intuitive and self-described.

JSON requires a single object and the object can contain any sub-objects in a key-value pair. Like this sample below.

<script src="https://gist.github.com/bluebirz/f5efdd35f392cfe93faa9db39e452e26.js?file=sample-json.json"></script>

We can write a `dict` object into a JSON file using `json` module like this.

<script src="https://gist.github.com/bluebirz/f5efdd35f392cfe93faa9db39e452e26.js?file=write-json.py"></script>

When it comes to read a JSON file, I use either `json` or `pandas`.

<script src="https://gist.github.com/bluebirz/f5efdd35f392cfe93faa9db39e452e26.js?file=read-json.py"></script>

---

## JSONL

JSONL is a kind of JSON but stands for "**JSON** **L**ines". It is also supported in BigQuery integration.

Big difference between JSON and JSONL is JSONL contains a JSON object per line. This is for JSON payloads in transaction manners in order to load it to OLAP (Online Analytical Processing) databases such as BigQuery.

<script src="https://gist.github.com/bluebirz/f5efdd35f392cfe93faa9db39e452e26.js?file=sample-jsonl.jsonl"></script>

For more information, please visit the official website at <https://jsonlines.org>

And we can easily write a JSONL file using this sample.

<script src="https://gist.github.com/bluebirz/f5efdd35f392cfe93faa9db39e452e26.js?file=write-jsonl.py"></script>

Similar to JSON file, I use `json` and `pandas` to read a JSONL file as well.

<script src="https://gist.github.com/bluebirz/f5efdd35f392cfe93faa9db39e452e26.js?file=read-jsonl.py"></script>

---

## Parquet

Parquet is designed by Apache ([Apache Parquet](https://parquet.apache.org/)). I don't use this much in the past but I can recommend this when you have a super large file which wouldn't be a good idea to import/export to CSV, JSON, or even JSONL above.

The figure below shows the size of same contents in different format.

![parquet size](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/file-formats/size-compare.png)

And we can see Parquet file is just 4 MB while CSV is larger by 21 MB and JSON is 59 MB.

Parquet handles the contents into parts. This is an example of the contents when we read with Python.

![parquet read](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/file-formats/parquet-read.png)

Parquet cannot be read normally with basic text editors because it's not a text file. I recommend to code in Python or other languages to read it.

This example shows how can we write a data into a Parquet file.

<script src="https://gist.github.com/bluebirz/f5efdd35f392cfe93faa9db39e452e26.js?file=write-parquet.py"></script>

And we can read it with the same module.

<script src="https://gist.github.com/bluebirz/f5efdd35f392cfe93faa9db39e452e26.js?file=read-parquet.py"></script>

---

## YAML

YAML stands for "**Y**et **A**nother **M**arkup **L**anguage" ([wiki](https://en.wikipedia.org/wiki/YAML)). I don't use this to store data but configurations instead.

Its characteristics is key-value pairing like JSON and sometimes we can use JSON for the task but YAML works better by its flexibility and feature-rich.

YAML is outstanding far from JSON by several reasons.

1. YAML supports comments. I love this part the most.
1. YAML has no brackets unnecessarily.
1. YAML can work with variables. JSON cannot.

This is a YAML example.

<script src="https://gist.github.com/bluebirz/f5efdd35f392cfe93faa9db39e452e26.js?file=sample-yaml.yaml"></script>

One thing, a YAML file can be `.yaml` or `.yml` so we need to double-check the file name and the extension or we will encounter "File not found" error. I made it many times in the beginning.

I personally write a YAML manually due to my need for a configuration file. But we can write it using Python like this.

<script src="https://gist.github.com/bluebirz/f5efdd35f392cfe93faa9db39e452e26.js?file=write-yaml.py"></script>

And we can use `yaml` to read a YAML file so easily.

<script src="https://gist.github.com/bluebirz/f5efdd35f392cfe93faa9db39e452e26.js?file=read-yaml.py"></script>

---

## Repo

All source code put here can be found in [my repo](https://github.com/bluebirz/file-formats).

---

These are major file formats I usually work with. How about yours?
