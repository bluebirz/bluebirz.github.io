---
title: argparse - next level Python parameterization
layout: post
author: bluebirz
description: argparse is a module to help us dealing with inputs and flags. Besides, it helps handling tooltips and alerts.
date: 2023-02-26
categories: [programming, Python]
tags: [Python, Argparse]
comment: true
image:
  path: https://images.unsplash.com/photo-1516031190212-da133013de50?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1516031190212-da133013de50?q=10&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Pankaj Patel
  caption: <a href="https://unsplash.com/photos/a-computer-screen-with-a-program-running-on-it-eygpU6KfOBk">Unsplash / Pankaj Patel</a>
---

You may experience command line like bash (in UNIX) or powershell (in Windows). A command line to execute a given script with given parameters. We can also make Python to work like that, ya know?

There are several reasons we want to run a Python script with parameters added.

For instance, we already have a simple Python script and we want to connect it with another system to do some jobs and it requires some parameters in the streamline.

Or just another complex example. We want to dynamically calculate somethings with our existing Python files and the parameters must be varied based on environment variables, totally it should be run in CI/CD process. Like that.

Interesting? Let's see how can we do.

---

## Old-school method

Because we run it like Bash, parameters will be a list of string there. We can retrieve them using `sys.argv` then manipulate each element in the program.

This is an example.

<script src="https://gist.github.com/bluebirz/572c2877da1def2ac27e204347a1c154.js?file=argv1.py"></script>

The program calculates sum of 2 input numbers. Let's try call this and add small numbers.

```sh
python3 src/argv/argv01_simple.py 1 2
```

It treats "1 2" as a list of string. All we need is to access each of them and cast to an integer then sum them up. You can see at the method `get_params()`.

Output like this.

![sys argv](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/argparse/a01.png)

In case we want to get all parameters. Easy peasy. We make that input list and cast to integers then do `sum` them all. Like this.

<script src="https://gist.github.com/bluebirz/572c2877da1def2ac27e204347a1c154.js?file=argv2.py"></script>

Try call it and see.

![sys argv 2](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/argparse/a02.png)

But if we want to deal with "flags" or something more complex, for example.

```sh
python3 my-script.py 1 2 3 --flag1 ABC --flag2 XYZ
```

We may end up writing funtions to process input to sort out whether this value is an input or a flag.

Any ways simpler?

---

Good news. We are introduced to see a module to do this job.

## `argparse` module

`argparse` is a module to help us dealing with inputs and flags. Besides, it helps handling tooltips and alerts for us. Link below is the official document of `argparse`.

{% include bbz_custom/link_preview.html url='<https://docs.python.org/3/library/argparse.html>' %}

Let's see some examples.

---

## create a simple adder

<script src="https://gist.github.com/bluebirz/572c2877da1def2ac27e204347a1c154.js?file=argparse1.py"></script>

The main part are these lines.

```py
parser = argparse.ArgumentParser()
parser.add_argument(...)
parsed_params = parser.parse_args(sys.argv[1:])
```

We parse the `sys.argv[1:]` as same as the old-school solution. Then create a parser and `.add_argument()` to manipulate the parameters.

There are 3 parts shown above:

1. A string. This is a name of each parameter.
1. `type` is the type of the parameter.
1. `help` is a help message when user open help with `-h` flag. Example below.

![argparse help](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/argparse/p01-h.png)

Once argparse processed the parameters, it returns to an object and we can access each by using obj.name.

The program can be run like this.

![argparse run](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/argparse/p01.png)

---

## create a sum of list

<script src="https://gist.github.com/bluebirz/572c2877da1def2ac27e204347a1c154.js?file=argparse2.py"></script>

Look at line #9. there is `nargs="+"` which means the number of arguments can be any at least one. See the example run below.

![argparse list](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/argparse/p02.png)

---

## create a sum of list with choices

<script src="https://gist.github.com/bluebirz/572c2877da1def2ac27e204347a1c154.js?file=argparse3.py"></script>

We can define multiple flags to a single parameter at line 17-18, `-o` and `--ops`, which means this parameter can be assigned by any of them. However, we can access this parameter by the first flag name with double dashes, in this case it is `ops`.

`choices` at line #20 requires a list of choices. And it will raise an error if the given value on run is not a member of the choices.

Try the choice `add` to compute a sum.

![argparse sum](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/argparse/p03-a.png)

And try `mult` to compute a product.

![argparse mult](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/argparse/p03-m.png)

---

## create a web scraper with overwriting handler

The last example is a program to download a website into a file. If the file is already exist and not allow overwriting, it would return an error.

<script src="https://gist.github.com/bluebirz/572c2877da1def2ac27e204347a1c154.js?file=argparse4.py"></script>

We define the flag `--overwrite` or `-w` as `action="store_true"`. This mean the parameter `overwrite` will be true by adding this flag on given, and it's false by default.

Let's say we already have a file and we don't put `-w` on a run. It will be an error there.

![argparse scraper no write-over](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/argparse/p04-f.png)

And here we add -w then the file will be overwritten.

![argparse scraper write-over](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/argparse/p04-p.png)

---

There are plenty possibilities to design our program to deal with business problems and hope this be helpful for your effective Python to do your jobs.

---

## Repo

Here is my repo containing all scripts above with sample run commands.

{% include bbz_custom/link_preview.html url='<https://github.com/bluebirz/sample-argparse.git>' %}
