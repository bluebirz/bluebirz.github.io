---
title: Well-documented with variable type annotation & Docstring
layout: post
author: bluebirz
description: 2 simple stuff we can improve our source code to become a good self-explained source code.
date: 2023-07-27
categories: [programming, Python]
tags: [Python, docstring, PEP, VSCode, annotation]
comment: true
image:
  path: https://images.unsplash.com/photo-1517036723957-e2891b1b32ae?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMTc3M3wwfDF8c2VhcmNofDJ8fHRvbmdzJTIwYm93bHxlbnwwfHx8fDE2ODk5NzEyNTV8MA&ixlib=rb-4.0.3&q=80&w=2000
  lqip: https://images.unsplash.com/photo-1517036723957-e2891b1b32ae?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMTc3M3wwfDF8c2VhcmNofDJ8fHRvbmdzJTIwYm93bHxlbnwwfHx8fDE2ODk5NzEyNTV8MA&ixlib=rb-4.0.3&q=10&w=2000
  alt: Unsplash / Soraya Irving
  caption: <a href="https://unsplash.com/photos/round-assorted-color-plastic-cases-AGtksbL8z2c">Unsplash / Soraya Irving</a>
---

{% include bbz_custom/styling-columns.html %}

A good source code does not only works as smooth as silk on production, but should be well-documented and appropriately readable. This will be useful for all contributors including the creators themselves.

This blog we're gonna discuss about 2 simple stuff we can improve our source code to become a good self-explained source code.

---

## Variable type annotation

This is for writing functions or program structures so that we can confidently control the variables flow. It's also called "Type hints", yes it's a hint for what type the variables there should be.

Type annotation is described on [PEP Python Enhancement Proposals) which is guideline to write Python in efficient ways.

{% include bbz_custom/link_preview.html url='<https://peps.python.org/pep-0526/#id11>' %}

Type annotation takes no effects on running a program but helps developers communicate to each other better on how to write good source code.

---

## Examples

Let's say we are writing a function with arguments: `num` & `text`, those of them is easily recognized as an integer and a string, right? But what if there is an argument named `unit`? What type should it be? Probably an integer like `unit` means a number of unit, or it's possibly a string like "centimetre" or "boxes".

More example, we have an encryption function like this.

<script src="https://gist.github.com/bluebirz/197267d81c40baf8d0ba9e94d6e53502.js?file=func-no-hint.py"></script>

You can see arguments; `text` is definitely a string but what is `offset`? And what does this function return? Hmm, we need to declare something to make this function more readable. Like this.

<script src="https://gist.github.com/bluebirz/197267d81c40baf8d0ba9e94d6e53502.js?file=func-with-hint.py"></script>

When we start writing the function, IDE would show arguments needed and types like this.‌

<div class="row">
    <div class="col-2">
        <img src="https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/type-hint-docstring/01-tooltip-no-hint.png" alt="no type annotation" loading="lazy">
        <em>Without type annotation</em>
    </div>
 <div class="col-2">
        <img src="https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/type-hint-docstring/02-tooltip-with-hint.png" alt="with type annotation" loading="lazy">
        <em>With type annotation</em>
    </div>
</div>

And here are examples of annotating variable types.

### Primitive types

Primitive types that is `int`, `float`, `bool`, and `str` are basic yet frequently used in daily life.

We add colon `:` after a variable followed by its types. Return type is defined after `->`.

<script src="https://gist.github.com/bluebirz/197267d81c40baf8d0ba9e94d6e53502.js?file=hint_primitive.py"></script>

### Default values

In some cases, we want to leave some arguments with default values. We give its value after `=`.

<script src="https://gist.github.com/bluebirz/197267d81c40baf8d0ba9e94d6e53502.js?file=hint_default.py"></script>

### Choices of type

If we are using python 3.10 or newer, we can use pipe (`|`)  express types that a argument could be.

With lower version of Python, we could use `typing.Union` module.

<script src="https://gist.github.com/bluebirz/197267d81c40baf8d0ba9e94d6e53502.js?file=hint_union.py"></script>

For more info about `typing` module, please follow the link below.

{% include bbz_custom/link_preview.html url='<https://docs.python.org/3/library/typing.html>' %}

### Collection types

When an argument is `list`, `tuple`, `set`, or other, we can define the collection type followed by bracket with its element type.

<script src="https://gist.github.com/bluebirz/197267d81c40baf8d0ba9e94d6e53502.js?file=hint_collection.py"></script>

Control flow variables

Let's say we are adding a loop and we want to annotate a type to the iterator variable. We can't use `:` directly at the declaration. We need to declare it **before** the loop. After that we are now able to auto-complete attributes of the variable type.

In the same manner, unpacking is an easy shorthand method to extract a collection to individual variables. Yet we can't annotate at unpacking step, we need to do so beforehand.

<script src="https://gist.github.com/bluebirz/197267d81c40baf8d0ba9e94d6e53502.js?file=hint_loop_unpack.py"></script>

---

## Docstring

Now comes to docstring. This docstring is like a helper we added to each function describing what this function does, what is its arguments, what does it return.

This is also defined in PEP5 257.

{% include bbz_custom/link_preview.html url='<https://peps.python.org/pep-0257/>' %}

I certained most of us are using modern IDEs such as my VSCode. Its [intellisense](https://code.visualstudio.com/docs/editor/intellisense) greatly comforts coding time with auto-completion. So I would introduce a simple plugin for VSCode to generate a docstring and we are just filling the template, and it's done. This plugin is named "Docstring" straightforwardedly.

{% include bbz_custom/link_preview.html url='<https://marketplace.visualstudio.com/items?itemName=njpwerner.autodocstring>' %}

This plugin is easy to use. Just start typing `"""` and the submenu will popup.

![docstring](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/type-hint-docstring/03-docstring-prompt.png){:style="max-width:75%;margin:auto;"}

Or using palette (<kbd>cmd</kbd> + <kbd>shift</kbd> + <kbd>P</kbd>) also works.

![palette](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/type-hint-docstring/04-docstring-palette.png){:style="max-width:75%;margin:auto;"}

When we're writing the function name, IDE would show this docstring and we will see the description of the function. Like this.

![show doc](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/type-hint-docstring/07-docstring-tooltip.png){:style="max-width:75%;margin:auto;"}

There are configurations for this plugin in Settings.

![settings](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/type-hint-docstring/05-docstring-setting.png){:style="max-width:75%;margin:auto;"}

And there are also number of docstring formats we can pick.

![docstring format](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/type-hint-docstring/06-docstring-format.png){:style="max-width:50%;margin:auto;"}

All possible formats is exampled below:

<script src="https://gist.github.com/bluebirz/197267d81c40baf8d0ba9e94d6e53502.js?file=docstring-all-options.py"></script>

---

## References

- [How do I annotate types in a for-loop?](https://stackoverflow.com/questions/41641449/how-do-i-annotate-types-in-a-for-loop/41641489#41641489)
