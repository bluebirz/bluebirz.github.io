---
title: Paint Terminal with Shell color codes
layout: post
description: Yes we just add a code to command Terminal to display mapped colors from the code.
date: 2023-08-18 00:00:00 +0200
categories: [programming, Shell script]
tags: [Python, Shell script]
image:
  path: https://images.unsplash.com/photo-1436918898788-ebce04d38e46?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMTc3M3wwfDF8c2VhcmNofDF8fHR5cG9ncmFwaHklMjBjb2xvciUyMHN0YW1wfGVufDB8fHx8MTY5MjI5ODI5MXww&ixlib=rb-4.0.3&q=80&w=2000
  alt: Unsplash / Bruno Martins
  caption: <a href="https://unsplash.com/photos/assorted-wood-stamps-OhJmwB4XWLE">Unsplash / Bruno Martins</a>
---

We as programmers are definitely familiar with Terminal. But printing on console would be boring in colors as black and white. So we will talk how to make console more colorful.

Here is an example.

![colored](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/bash-colors/sample_mix_colors.png){:style="max-width:75%;margin:auto;"}

---

## Shell color codes

Terminal console works with texts. You can figure we now add some texts to decorate, Yes we just add a code to command Terminal to display mapped colors from the code.

The code is in the format `\033[...m`.

In this blog we will see how to use it because I have already prepared the code for both Python and Shell scripts.

---

## Running in Python

### module

In the repo, I have created a class of constants of shell color codes. It looks as below.

<script src="https://gist.github.com/bluebirz/900f11ea6baddbd9c5c470763ddf345f.js?file=bash_colors.py"></script>

This code stub is just showing a part of the module in the repo.

### usage

To utilize the class is to import and add in the string as you want. Please note that the color code will affect until the end of string or applying default color code as this name is "RESET" (`\033[0m`).

Example code is this.

<script src="https://gist.github.com/bluebirz/900f11ea6baddbd9c5c470763ddf345f.js?file=py-colored.py"></script>

In case you want to read more about regex, feel free to follow [this link]({% post_url 2021-02-27-regex-is-sexy %}).

### clear

Let's say we want to remove all color codes here, I also prepared a function for that.

<script src="https://gist.github.com/bluebirz/900f11ea6baddbd9c5c470763ddf345f.js?file=py-remove-colors.py"></script>

We use `re` library and replace with `.sub()`. In here we apply regex `r"\033\[[\d;]+m"` which means starting with `\033[` followed by digits or commas and ends with `m`.

### output

See sample output of colored and color-removed text.

![python](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/bash-colors/sample_run_python.png){:style="max-width:75%;margin:auto;"}

---

## Running in Shell

Similar to Python but have some details different.

### module

This code stub below is just showing a part of the module in the repo.

<script src="https://gist.github.com/bluebirz/900f11ea6baddbd9c5c470763ddf345f.js?file=bash_colors.sh"></script>

### usage

We can `source` the file then it's ready. Also add "RESET" (`\033[0m`) to reset the color.

<script src="https://gist.github.com/bluebirz/900f11ea6baddbd9c5c470763ddf345f.js?file=sh-colored.sh"></script>

### clear

We use regex like Python but we can't use the same regex string.

Because `\033` is non-printable character so we need to change a bit. The regex string for this case is `[^[:print:]]\[[0-9;]+m`.

The regex string means not starting with printable characters, then be followed by `[`, digits or commas, and ends with `m`.

We use `sed` to execute it with `-r` flag means extended regex.

Here is the function for removing all color codes in Shell.

<script src="https://gist.github.com/bluebirz/900f11ea6baddbd9c5c470763ddf345f.js?file=sh-remove-colors.sh"></script>

### output

See sample output here.

![shell](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/bash-colors/sample_run_bash.png){:style="max-width:75%;margin:auto;"}

---

## Repo

You can reach out to my repo here.

{% include bbz_custom/link_preview.html url='<https://github.com/bluebirz/shell-color-codes>' %}

---

## References

- [How do I print colored text to the terminal?](https://stackoverflow.com/questions/287871/how-do-i-print-colored-text-to-the-terminal)
- [Replace non-printable characters in perl and sed](https://unix.stackexchange.com/questions/201751/replace-non-printable-characters-in-perl-and-sed/201753#201753)

---

## Edits

2023-08-19: Update from "Bash" to "Shell" as this is not only available on Bash scripts but Shell scripts.
