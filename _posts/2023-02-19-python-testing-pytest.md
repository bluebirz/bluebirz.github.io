---
title: Python testing - module pytest
layout: post
author: bluebirz
description: Now we are going to discuss about pytest.
date: 2023-02-19
categories: [programming, Python]
tags: [Python, testing, Pytest]
comment: true
image:
  path: https://images.unsplash.com/photo-1581677641984-cf14ca58c5ee?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1581677641984-cf14ca58c5ee?q=10&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Tsvetoslav Hristov
  caption: <a href="https://unsplash.com/photos/black-traffic-light-turned-on-during-night-time-iJ-uantQb9I">Unsplash / Tsvetoslav Hristov</a>
---

We talked about unittest in the recent blog, and you would have known that there are other modules for testing in Python.

{% include bbz_custom/link_preview.html post='2023-02-10-python-testing-unittest' %}

Now we are going to discuss about an alternative, `pytest` module.

---

## How good is `pytest`?

`pytest` is one of python testing module. I prefer this over `unittest` because of its ease to use and message highlighting, yet its test scripts can be written shorter compared with `unittest`.

The official document of pytest is [here](https://docs.pytest.org/en/latest/).

---

## Make a first baby step

Let's start a simple thing up.

### install module

First thing first, install the module into our environment using this command. This is the [module document on PyPI](https://pypi.org/project/pytest/).

```sh
pip install pytest
```

### Prepare a simple function

Similar to the `unittest` blog, we have the simple adder function.

<script src="https://gist.github.com/bluebirz/be5558693b4de93eb1f7e1c5f81eda9a.js?file=adder-simple.py"></script>

### Prepare a  pytest script

We're gonna write a simple pytest script to test our function. Like this
<script src="https://gist.github.com/bluebirz/18ccaabb6d7293a369c6bfa5cd222a9f.js?file=test-one.py"></script>

Make sure we don't name the file as `pytest.py` or it will be an importing error. The reason is similar to what we found with `unittest` that `pytest` is also a command.

Then we can test the function with the script, run the command.

```sh
pytest <pytest-script>
```

![test one](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/pytest/test-one.png)

See? It adds colors. Looking nice and easier to spot our test results.

### Add more test cases

Say we add more two cases

<script src="https://gist.github.com/bluebirz/18ccaabb6d7293a369c6bfa5cd222a9f.js?file=test-multiple.py"></script>

And run test to find all 3 test cases passed

![test multiple](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/pytest/test-multiple.png)

### What if it failed?

Let's see what will happen if we intentionally make a test case failed.

<script src="https://gist.github.com/bluebirz/18ccaabb6d7293a369c6bfa5cd222a9f.js?file=test-multiple-fail.py"></script>

Run and find red lines.

![test multiple failed](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/pytest/test-multiple-fail.png)

It shows failures, the lines of the failures, and debug values.

Also we can see at the bottom. It is summary info that shows there is one failed test case but other 2 passed.

### Show all results

We can use the command to show all results, even failed or passed.

```sh
pytest -rA <pytest-script>
```

`-rA` flag will display all test cases with results per case. More than that, it also displays test function names too. Help us spot the error test cases a lot faster.

![test multiple failed extra all](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/pytest/test-multiple-fail-extra-all.png)

As above, there are passed cases in green and failed one in red.

### More flags for test

`pytest` offers many useful flags for decorating and adding productivity when run. For example, `-rA` above shows all results.

```sh
pytest -h
```

The command will display help dialogs that we can adapt to our needs.

![pytest help](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/pytest/pytest-h.png)

---

## Error handling

Now look at the function with error handling as below.

<script src="https://gist.github.com/bluebirz/be5558693b4de93eb1f7e1c5f81eda9a.js?file=adder-error-handling.py"></script>

There are 2 basic choices we can compare as below.

<script src="https://gist.github.com/bluebirz/18ccaabb6d7293a369c6bfa5cd222a9f.js?file=test-error-handling.py"></script>

1. error type  
  Just compare its .type with the expected error type
1. error message  
  Can use re module to compare with the error's .value attribute.

The result of the test would be like this.

![err handling](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/pytest/test-error-handling.png)

---

## Parametrize

Talking about many test cases, instead of writing all test functions per each, we can use `parametrize` feature to write less by just one test function and supply a list of parameters.

We need to add pytest decorator on top of the test function like this.

```py
@pytest.mark.parametrize("arguments, expect", test_cases)
def test_functions(arguments, expect):
  # code stubs
```

<script src="https://gist.github.com/bluebirz/18ccaabb6d7293a369c6bfa5cd222a9f.js?file=test-multiple-param.py"></script>

I added 2 test functions, one is unpacking dict by assignment and another is doing so by using *.

For more info regarding unpacking can be found at this link.

{% include bbz_custom/link_preview.html url='<https://stackabuse.com/unpacking-in-python-beyond-parallel-assignment/>' %}

When run test, it would be like this.

![test multiple param](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/pytest/test-multiple-param.png)

---

## Show program outputs

Say our program outputs some messages, run just `pytest`won't dislay them.

<script src="https://gist.github.com/bluebirz/18ccaabb6d7293a369c6bfa5cd222a9f.js?file=adder-simple-print.py"></script>

We can add `-rA` or `-ra` flag to show extra summary and it will display program outputs as well. The difference is `-rA` shows all test case results while `-ra` shows all non-passed results

![test multiple capture](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/pytest/test-multiple-capture.png)

Alternatively, we can use flag `-s` as "no capture" and outputs will be piled up in one place. However, I prefer `-rA` which is more prettier and cleaner.

![test multiple no capture](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/pytest/test-multiple-no-capture.png)

---

This is for explaining a basic info of `pytest` module.

I like this and I hope this can be useful for you reader when you need to write a python test, as your favor.

---

## Repo

Below is my repo of source code in this blog.

{% include bbz_custom/link_preview.html url='<https://github.com/bluebirz/python-test-module>' %}
