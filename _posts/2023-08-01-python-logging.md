---
title: Python logging - better than just print
layout: post
author: bluebirz
description: In every single software development, there is a chance the program runs into an error.
date: 2023-08-01
categories: [programming, Python]
tags: [Python, logging]
comment: true
image:
  path: https://images.unsplash.com/photo-1507415492521-917f60c93bfe?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMTc3M3wwfDF8c2VhcmNofDF8fG5vdGUlMjBmdXJuaXR1cmUlMjBmcmFuY2V8ZW58MHx8fHwxNjkwNDA0MDkxfDA&ixlib=rb-4.0.3&q=80&w=2000
  alt: Unsplash / Brandon Lopez
  caption: <a href="https://unsplash.com/photos/woman-wearing-white-shirt-standing-inside-library-3E_8XgqRSps">Unsplash / Brandon Lopez</a>
---

`Logging` module is one of most useful modules out of the box. In every single software development, there is a chance the program runs into an error. And that's a reason we should prevent the case with this.

All programmers are familiar with `print` function. We use it to debug some values. However, it would be greatly better to understand how to effectively utilize `Logging` module because we may need to debug from somewhere more persistent than console log.

For more info please follow the link to read the module's detail, but we're gonna see some basic use cases of this module through this blog.

{% include bbz_custom/link_preview.html url='<https://docs.python.org/3/library/logging.html>' %}

---

## Simple use

Just a baby step. We can start from this.

<script src="https://gist.github.com/bluebirz/a64a349117f89ffec487bc537812a698.js?file=01_sample.py"></script>

There are 5 levels of log there + 1 "NOTSET" which I never use it as there is no use cases for me. Learn more about levels by [this link](https://docs.python.org/3/library/logging.html#logging-levels).

The result will be messages from `Logging`.

![log](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/python-logging/01-sample.png)

And what if we want more info of the message such as time or formatting level? We can add argument `format` into the object like this.

<script src="https://gist.github.com/bluebirz/a64a349117f89ffec487bc537812a698.js?file=02_sample_with_format.py"></script>

And it will produce the message based on the given format.

![log time](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/python-logging/02-sample-with-format.png)

---

## Handlers

Wanna try more advance? Let's make a logger that perform logging on both console and file writing.

For this requirement, we are going to review two main handlers for injecting log records to these displays.

### console

Other than using `basicConfig()` as above, we will use `StreamHandler()`. The example is below:

<script src="https://gist.github.com/bluebirz/a64a349117f89ffec487bc537812a698.js?file=03_sample_handler_console.py"></script>

And let's see what happen when we run it.

![StreamHandler](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/python-logging/03-sample-handler-console.png)

### file

We can parse the log outputs to a file via `FileHandler`.

<script src="https://gist.github.com/bluebirz/a64a349117f89ffec487bc537812a698.js?file=04_sample_handler_file.py"></script>

See the output file here.

![FileHandler](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/python-logging/04-sample-handler-file.png)

### Combine together

Of course, we can mix both handlers together to inject logs through console and file at the same time. Try this:

<script src="https://gist.github.com/bluebirz/a64a349117f89ffec487bc537812a698.js?file=05_sample_handler_mix.py"></script>

Now run it and there are console log along with file log. Yes!

![both handlers](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/python-logging/05-sample-handler-mix.png)

---

## More fancy examples

### dynamic level per message

We can supply the message level by calling `.log()` instead of `.info()` or other level-specific methods.

<script src="https://gist.github.com/bluebirz/a64a349117f89ffec487bc537812a698.js?file=06_logging_dynamic_level.py"></script>

### Date time format

We would add argument `datefmt` to `logging.Formatter()`. Visit [this link](https://docs.python.org/3/library/datetime.html#strftime-and-strptime-format-codes) to learn more about format codes.

<script src="https://gist.github.com/bluebirz/a64a349117f89ffec487bc537812a698.js?file=07_sample_with_datetimeformat.py"></script>

![datetimeformat](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/python-logging/07-sample-with-datetimeformat.png)

### Multiple loggers

How to manage multiple loggers?

We can create many loggers as we want but we need  to make sure we named each logger distinguishly. Let's see the case.

<script src="https://gist.github.com/bluebirz/a64a349117f89ffec487bc537812a698.js?file=08_logging_multiple_error.py"></script>

- Firstly, program calls `outer`.
- `outer` create a logger name "outer" to write logs in file "outer.log". The messages are "[outer] start" and "[outer] done".
- Between both messages from `outer`, `outer` also call `inner` through a loop.
- There are 2 items and it will call `inner` 2 times.
- First item is a text "abc" that `inner` will log in the filepath "msg1/inner.log" with "[inner]" beginning the line.
- Second is a text "def" that `inner` will log in the filepath "msg2/inner.log" with "[inner]" beginning the line as well.
- `inner` has a logger name "inner".

Looking good but the result was not as expected. The log file "msg1/inner.log" should have only "[inner] abc" but it inproperly has "[inner] def".

![multiple loggers](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/python-logging/08a-logging-multiple-error.png)

What we missed? We had given the same log name for `inner` so that the first `inner` call receive the consequent logs.

We have to fix by giving different name. One solution is to use `UUID` to generate a random UUID (line 27) for each `inner` call.

<script src="https://gist.github.com/bluebirz/a64a349117f89ffec487bc537812a698.js?file=08_logging_multiple_fixed.py"></script>

And this time we got the correct logs.

![multiple loggers fix](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/python-logging/08b-logging-multiple-fixed.png)

---

## Repo

All examples is in my repo here.

{% include bbz_custom/link_preview.html url='<https://github.com/bluebirz/sample-python-logging>' %}
