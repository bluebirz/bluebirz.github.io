---
title: jq - just Bash to travel over JSON
layout: post
description: When call jq and supply a valid JSON data with a JSON path we want, we will obtain the expected result at ease.
date: 2023-06-24 00:00:00 +0200
categories: []
tags: []
image:
  path: ../assets/img/features/jq.svg
  alt: jqlang.github.io
  caption: <a href="https://jqlang.github.io/jq/">jqlang.github.io</a>
---

JSON is a very popular file format and I have a blog for this ([here]({% post_url 2023-03-12-file-formats-ive-worked-with %})). I pretty sure you readers know it so well. We have many tools and methods to work with this. This time I would like to introduce a **super basic yet effective tool** we can use **just our command line** and get a job done for JSON files, "jq".

In case you want to read more about Bash script on command line interface, you can visit [this blog]({% post_url 2019-11-18-try-bash %}).

---

## What is jq?

`jq` is a package for command line to access and process JSON contents. When call `jq` and supply a valid JSON data with a JSON path we want, we will obtain the expected result at ease.

[Here](https://jqlang.github.io/jq/) is the website of `jq`.

We can install `jq` via homebrew which [I wrote about recently]({% post_url 2023-06-20-homebrew-one-place-for-all %}).

---

## Syntax

```sh
cat <json_file> | jq '<jq_statement>'
jq '<jq_statement>' <json_file>
```

First command means read a JSON file, then pipe (`|`) to parse contents of the file to `jq` command to do something. Second one is to execute `jq` directly on the file without reading beforehand.

In case of wanting to replace `jq` output back to the same file, we could try [sponge](https://linux.die.net/man/1/sponge). Sponge is a package to handle file writing in Linux. Also available on Homebrew [here](https://formulae.brew.sh/formula/sponge).

When sponge is ready in the machine, we can apply this command.

```sh
cat <json_file> | jq '<jq_statement>' | sponge <json_file>
jq '<jq_statement>' <json_file> | sponge <json_file>
```

Now the output is written to the output file described after `sponge`.

---

## `jq` applications

Assume we have this JSON.

<script src="https://gist.github.com/bluebirz/fd930c201afdff023d9e7270cb301df5.js?file=contents.json"></script>

We have many ways to compute and generate outputs using jq functions.

Here are 9 examples for this blog.

### 1. direct access

```sh
cat contents.json | jq '.id'
cat contents.json | jq '.id, .name'
cat contents.json | jq '.id, .name, .items'
```

We can output a value of a key directly with **a single dot in front**. This implies we are accessing "inside" from root level.

![direct access](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/jq/01-scalar.png){:style="max-width:75%;margin:auto;"}

### 2. inside an array

```sh
cat contents.json | jq '.classes[0]'
cat contents.json | jq '.classes[0].town'
```

If it's an array, we can access by **giving an index**.

![array](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/jq/02-array.png){:style="max-width:75%;margin:auto;"}

### 3. simple select

```sh
cat contents.json | jq '.classes[] | select(.level==50)'
cat contents.json | jq '.classes[] | select(.level==50) | .job'
```

With `select()`, we can **filter** an array by this function and supplying a boolean expression.

`.classes[]` means treating from a single array to a set of elements, then `select (.level==50)` in order to filter with the key "level" inside each element if that equals 50.

![select](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/jq/03-select.png){:style="max-width:75%;margin:auto;"}

### 4. regex

```sh
cat contents.json | jq '.items[] | match("^st.*")'
cat contents.json | jq '.items[] | match("^st.*") | .string'
```

Regex is available as well. `match()` is one of functions using with Regex. The `match()` **returns an object** of matching products.

Example above is to find out words in "items" which starts (`^`) with `st` and followed by anything (`.*`).

Wanna read more about regex? I have my blog for this [here]({% post_url 2021-02-27-regex-is-sexy %}).

![regex](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/jq/04-regex.png){:style="max-width:75%;margin:auto;"}

### 5. regex with select

```sh
cat contents.json | jq '.classes[] | select(.job|match("ma"))'
```

We can combine `select()` and `match()` together to filter on a specific key in objects array.

First we extract an array using `[]` then `select()`. Inside `select` we will supply a boolean statement by choosing a key and do regex on the key with pipe `|`.

This example is to find elements inside `classes`, where the key `job` is matched with string `ma`.

![regex select](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/jq/05-select-regex.png){:style="max-width:75%;margin:auto;"}

### 6. basic altering

```sh
cat contents.json | jq '.cash | map(.amount |= .+200)'
```

`map` is also a useful function. This **iterates through an iterator**, you can see that "cash" is an array but we don't add `[]` unlike above functions.

As the example, we choose the key "amount" of the array "cash" then apply `|= .+200` which means **update its value** (`|=`) by  adding itself (`.`) with 200.

`map` function returns an array.

![alter](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/jq/06-map.png){:style="max-width:75%;margin:auto;"}

### 7. alter and direct access

```sh
cat contents.json | jq '.cash | map(.amount |= .+200) | map(.)[]'
cat contents.json | jq '.cash | map(.amount |= .+200) | map(.)[] | .id,.amount'
```

As `map` returns an array, we are able to add next pipe and apply `map` again, supply themselves with a dot and `[]` to extract. Now it's ready for accessing a key inside.

![alter and direct access](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/jq/07-map-to-scalar.png){:style="max-width:75%;margin:auto;"}

### 8. alter and make a new JSON

```sh
cat contents.json | jq '.cash | map(.amount |= .+200) | map(.)[] | {id:.id, amount:.amount}' | jq -s
```

Outputs are ready to be a new object using `{...}`.

After that, pack them all together into a new JSON using `jq -s` where `-s` is "slurp" flag for "read entire input into a large array".

![make new json](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/jq/08-map-to-object.png){:style="max-width:75%;margin:auto;"}

### 9. Replace file using Sponge

`sponge` package we discussed in the topic "Syntax" has a scene here.

```sh
cat contents.json | jq '...' | sponge contents.json
```

Read a file, process with `jq`, and `sponge` back to the same file. Easy.

![sponge](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/jq/09-sponge.png){:style="max-width:75%;margin:auto;"}

---

## References

- [Use jq to filter objects list with regex](https://til.hashrocket.com/posts/uv0bjiokwk-use-jq-to-filter-objects-list-with-regex)
- [jq modify value based on existing value of the attribute](https://stackoverflow.com/questions/66324817/jq-modify-value-based-on-existing-value-of-the-attribute)
- [jq: output array of json objects [duplicate]](https://stackoverflow.com/questions/38061346/jq-output-array-of-json-objects)
