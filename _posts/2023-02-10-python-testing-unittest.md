---
title: Python testing - module unittest
layout: post
author: bluebirz
description: Without testing, how do we certain if our program works best and has no critical bugs?
date: 2023-02-10 00:00:00 +0200
categories: [programming, Python]
tags: [Python, testing, unittest]
comment: true
image:
  path: https://images.unsplash.com/photo-1576444356170-66073046b1bc?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Ferenc Almasi
  caption: <a href="https://unsplash.com/photos/a-close-up-of-a-computer-screen-with-code-numbers-EWLHA4T-mso">Unsplash / Ferenc Almasi</a>
---

## what is unittest

Testing is an essential stage in development lifecycle. Without testing, how do we certain if our program works best and has no critical bugs?

![sw dev cycle](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/unittest/dev-proc.drawio.png)

In Python, there are several modules that we can use to test our program at ease. Now we are talking about unittest.

---

## Start from basic

### writing functions

Say we are writing an **adder function** like this.

<script src="https://gist.github.com/bluebirz/be5558693b4de93eb1f7e1c5f81eda9a.js?file=adder-simple.py"></script>

And we wanna prove the function is working perfectly.

We begin with creating a new Python file as a `unittest` script. Say name it "test-one.py". We will run this to test our adder function by a test case.

<script src="https://gist.github.com/bluebirz/be5558693b4de93eb1f7e1c5f81eda9a.js?file=test-one.py"></script>

> Do not name a file as "unittest.py" to avoid circular referencing because Python uses that name as a command.
{: .prompt-danger }

### naming a test function

Unlike operational functions, the adder for example, we should put a **long clear name** for test functions to tell what purpose the test function is. We are not calling them directly in the program so don't worry to name it such a long one.

Basically we name the test function **what and how it test**. For example, "test_get_student_name_boy_only" to test getting student names by focusing male student only, or like above "test_adder_simple_by_both_positive" to test the function `adder_simple` by input 2 positive numbers.

### run test

Run the test by runing the python test file.

```sh
python3 <unittest.py-filepath>
```

The result should output a dot (`.`) as a successful test case.

![test one](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/unittest/test-one.png)

### add more test cases

One test case is defined by One test function. If we want more test cases, we can write as many test functions as we want.

<script src="https://gist.github.com/bluebirz/be5558693b4de93eb1f7e1c5f81eda9a.js?file=test-multiple.py"></script>

When run it, we will see more dots means more successful test cases.

![test multiple](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/unittest/test-multiple.png)

### what if test cases failed?

Let's write a test case that expects to be failed.

<script src="https://gist.github.com/bluebirz/be5558693b4de93eb1f7e1c5f81eda9a.js?file=test-multiple-fail.py"></script>

You would notice at line 15 that -2 + 2 ≠ 1 for sure. When run it, it would display `F` means an error with a failed statement. Next is to sort out the root causes whether the test case is wrong or the program has a bug somewhere.

![test multiple failed](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/unittest/test-multiple-fail.png)

---

## Dealing with error handlings

When it comes with error handlings, Python uses `try-except` structure. We would have to design our unit testing to capture those behaviors, of course.

Let's see how.

### adder function with error handling

This example is a function that raise an error when any argument `a` or `b` is less than zero or equal.

<script src="https://gist.github.com/bluebirz/be5558693b4de93eb1f7e1c5f81eda9a.js?file=adder-error-handling.py"></script>

### how to test

`unittest` has a method to capture the error raised like below, `assertRaisesRegex()`. This method helps capture a **certain error type with patterned message** in a regular expression string.

<script src="https://gist.github.com/bluebirz/be5558693b4de93eb1f7e1c5f81eda9a.js?file=test-error-handling.py"></script>

For more info about regular expressions, please visit this article.

{% include bbz_custom/link_preview.html post='2021-02-27-regex-is-sexy' %}

In case the test case wants to capture only a certain error type, we can use `assertRaises()`.

You can follow the link below to the official document of the module unittest.

{% include bbz_custom/link_preview.html url='<https://docs.python.org/3/library/unittest.html>' %}

---

## Show logs in test functions

Showing pure dots may be too plain to visualize. We can print out what and where we are testing. Try these.

### simply print

Yes, we just use `print()` to print out any texts as we want.

<script src="https://gist.github.com/bluebirz/be5558693b4de93eb1f7e1c5f81eda9a.js?file=test-multiple-print.py"></script>

The command `print(self._testMethodName)` means we are printing the name of the testing method. The result would be like this below.

![test multiple print](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/unittest/test-multiple-print.png)

### logging module

We could know the module `logging`. This module is great to print out logs with severity levels (`DEBUG`, `INFO`, `ERROR`, etc.) helps us easily notice the messages and sort out to actions.

<script src="https://gist.github.com/bluebirz/be5558693b4de93eb1f7e1c5f81eda9a.js?file=test-multiple-logging.py"></script>

We need to `import logging` then setup the logger instance. After all, we can call `debug()` method to log the messages there in `DEBUG` level.

Output would be like this.

![test multiple logging](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/unittest/test-multiple-logging.png)

I would credit this idea of logging module by this comment at [Outputting data from unit test in Python](https://stackoverflow.com/questions/284043/outputting-data-from-unit-test-in-python).

---

Testing is essential.

Don't forget to test your code before deploying on Production.
