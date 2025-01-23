---
title: File is too big? Make it chunks.
layout: post
description: Dealing with large files may cause insufficient resource during an operation.
date: 2022-01-17 00:00:00 +0200
categories: [programming, algorithm]
tags: [chunk, Python, file operations]
image:
  path: ../assets/img/features/unsplash/mae-mu-BqJAbXk2Fuw-unsplash.jpg
  alt: Unsplash / Mae Mu
  caption: <a href="https://unsplash.com/photos/flat-lay-photography-of-chocolate-bars-BqJAbXk2Fuw">Unsplash / Mae Mu</a>
---

Working in data pipelines sometimes are with very large files and we need a solution to ensure the process must be done with less frustrations like lack of resources or glitches in files.

Then how?

---

## Typically we write files

Here is a sample Python script. Open a target file in w (write) mode then put some contents in it.

<script src="https://gist.github.com/bluebirz/505ebfd15e63040ac2f660b266ab4d28.js"></script>

---

## Then we meet chunks

Let's say we want to read a large file and write it to the destination but we can't read all at once. Here is an example of chunk processing we can use.

Chunk means a small piece of something big so we are trying to split that big thing into pieces and transfer them one-by-one until finished.

Example below shows that we can read (`r`) from a file at a specific size then write into another file.

<script src="https://gist.github.com/bluebirz/5a5c06c7a2c320b87f8ff649d9551e13.js"></script>

---

## chunk and decompression

In case we need some extra operation, we are able to execute it to each chunk. For example, this is how we can do to decompress a gzip file with chunk processing.

We, this time, use `rb` to read as binary from the gzip source file and `wb` to write as binary into the target text file. Decompression can be completed thanks to `zlib` library.

<script src="https://gist.github.com/bluebirz/6b88dde9f8eb8505d6701b3b5ecf139f.js"></script>

---

## Chunk from database connectors

Simply dumping database data. First, we need to connect to the database and execute a query then `fetchmany()` to get each chunk so you can process the chunk as you desire.

This time we append each chunk into the file with `a` mode and use `csv` library for csv formatting.

<script src="https://gist.github.com/bluebirz/6a8db8f3390b8eafb8a5fc79bfab6d3d.js"></script>

---

These are sample codes you can try and adapt to your work for performance optimization.
