---
title: 3 ways for Python string template
layout: post
author: bluebirz
description: Here are 3 ways we can make a string template in Python.
date: 2024-07-22 00:00:00 +0200
categories: [programming, Python]
tags: [Python, string, Jinja2]
comment: true
image:
  path: https://images.unsplash.com/photo-1682953745453-c537d3248028?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Anya Chernik
  caption: <a href="https://unsplash.com/photos/a-bag-filled-with-lots-of-different-colored-needles-jyTY8dz3qk8">Unsplash / Anya Chernik</a>
---

String is one of basic variable types with capabilities to customize and manipulate its value.

Here are 3 ways we can make a string template in Python.

---

## 1. f-string

A super basic. Just start the string value with `f` and write `{}` around the value we want to place inside the string and done.

For example,

<script src="https://gist.github.com/bluebirz/cea29aa42042cf34785aeac4a4ecc6da.js?file=01-f-string.py"></script>

Start with `f` followed by any types of quote pairs; single-quotes `''`, double-quotes  `""`, triple single-quotes `''''''`, or even triple double-quotes `""""""`, depends on whether we need to have any escaped quote characters inside the string.

- If we have multiple lines of the string, consider triple single-quotes or triple double-quotes.
- If we have single-quotes in the string, consider double-quotes for f-string or vice-versa.

And specify variables inside `{}` in the f-string.

Even though it looks so simple yet there are plenty formats we can apply. Read more here.

{% include bbz_custom/link_preview.html url='<https://docs.python.org/3/tutorial/inputoutput.html>' %}

---

## 2. String template

There is an innate library we can use to format a string in a more flexible way without installing any third-party libraries. It is a string template.

Just `from String import Template` and it's ready.

<script src="https://gist.github.com/bluebirz/cea29aa42042cf34785aeac4a4ecc6da.js?file=02-string-template.py"></script>

Specify variables using `$` and the variable name. Then substitute using `.substitute()` to format the string with variables or `.safe_substitute()` to avoid errors if some specified variables in the string are not supplied in parameters.

Parameters can be either keywords (`key=value`) or dict of key-value pairs (`{"key":"value"}`).

Read more here.

{% include bbz_custom/link_preview.html url='<https://docs.python.org/3/library/string.html#string.Template>' %}

---

## 3. Jinja

It must be a case we need more advance formatting and there always be an external library for us.

It's `Jinja2` library.

{% include bbz_custom/link_preview.html url='<https://jinja.palletsprojects.com/en/3.1.x/>' %}

In short, we can use this library to design string formatting with more complex conditions. But for this blog we make just an intro for this.

Start from install this library, `pip install jinja2`. And use it like this.

<script src="https://gist.github.com/bluebirz/cea29aa42042cf34785aeac4a4ecc6da.js?file=03-jinja.py"></script>

{% raw %}
With `.render()` we supply the parameter variables specified in `{{}}` in the template.
{% endraw %}

Parameters can be either keywords or dict of key-value pairs.
