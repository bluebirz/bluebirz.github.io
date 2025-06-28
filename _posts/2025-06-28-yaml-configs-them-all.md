---
title: "YAML configs them all"
layout: post
author: bluebirz
description: YAML is my favorite for configurations and orchestrations.
date: 2025-06-28
categories: [programming, tools]
tags: [YAML, YML, yq]
comment: true
image:
  path: https://images.unsplash.com/photo-1593720218365-b2076cfdefee?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1593720218365-b2076cfdefee?q=10&w=2071&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Ferenc Almasi
  caption: <a href="https://unsplash.com/photos/text-An6M5zgFPj4">Unsplash / Ferenc Almasi</a>
media_subpath: 

---

I really like YAML much that I can write my work orchestration into YAML files and it's self-explaining.

---

## What is YAML?

YAML has been mentioned once in my blog here.

{% include bbz_custom/link_preview.html post="2023-03-12-file-formats-ive-worked-with.md" %}

YAML formats has been adopted and very popular in recent years from its flexibility and human-readable format. Many popular services support YAML configurations for example, Kubernetes, Docker compose, openAPI, and Github Actions.

---

## Benefits

Practically, YAML is somehow like JSON but it brings some more benefits that I like so much.

1. **Indentation**  
  YAML is indent-based like Python, so the learning curve isn't high for me.

1. **Comments** allowed  
  In JSON, we can't write comments but YAML is allowing it. I usually add comments to explain what is the purpose of this section.

1. No unnecessary **brackets**  
  In JSON, we need to wrap everything in brackets so the file would become bigger from the plenty of brackets and spaces. While YAML can be written without concerning about wrapping.

1. **Strings** in free-style  
  In JSON, we have to wrap all strings in quotes (`"string"`) but in YAML, we can write them with or without quotes, even a paragraph can be written with a symbol that is pipe (`|`) or greater than (`>`).

---

## Syntax

YAML must be written in key-value pairs to describe configurations and here is a sample YAML that would be easier to understand its syntax.

```yaml
a-key: "a value"
some-int: 1 
some-float: 0.01
some-bool: true
some-str: "sample string in a quote"
another-str: sample string without a quote
paragraph: |
  a very long string
  with new line inside
  that use | to read better
another-paragraph: >
  a very long string
  with new line inside
  that use > to read better
array: [1, 2, 3, 4]
another-array:
  - 1
  - 2
  - 3
  - 4
# some-comment: "this int-inside-nest a comment"
object:
  int-inside-object: 100 
  object-inside-object:
    some-key: some value
object-array:
  - index: 1 
    item: shirt
    dimension: 
      width: 10
      height: 20
  - index: 2
    item: pants
    dimension: 
      width: 15
      height: 30
```

YAML even has more advance features but I don't use them often such as anchor (`&`), alias (`*`), and override (`<<:`) to refer the values.

```yaml
server-a:
  - name: "computer A"
    spec: &spec-default # anchoring as `spec-default`
      ram: 8
      harddisk: 1024 
      os: windows
  - name: "computer B"
    spec: *spec-default # aliasing to `spec-default`
  - name: "computer C"
    spec:
      ram: 4
      <<: *spec-default # aliasing to `spec-default` and merge with override (`<<:`), so ram will be 8
```

And type casting.

```yaml
casting:
  str-to-int: !!int "123"           # result is 123
  str-to-float: !!float "123.456"   # result is 123.456
  int-to-str: !!str 123             # result is "123"
  float-to-str: !!str 123.456       # result is "123.456"
```

---

## Language Servers

This feature is great for me. We can setup a "language server" which help us validate the structure of YAML we are writing by giving its schema and it will show up suggestions, autocompletion, and errors, like this.

![autocomplete](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/yaml/autocomplete.png){:style="max-width:100%;margin:auto;"}

We need 2 things to make it work.

1. Language Server Protocol (LSP)  
   LSP or Language Server Protocol is a helper for IDEs to communicate with the language server to understand and detect, suggest, and validate the code that we are writing.  
   We can install the LSP for YAML in VSCode by this plugin: [YAML by Red Hat](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml). Or LSP for Neovim via Mason or nvim-lspconfig with the name "yaml-language-server".

1. Target schema  
  We have a LSP to help translate then we can tell the translator that we want this schema as a structure of what we are writing. We just add the first line telling so like this:

    ```yaml
    #yaml-language-server: $schema=<url or path/to/schema>
    yaml-content:
      ...
    ```
  
  We can refer to a URL of the schema or a path of schema file. One of the references I usually look into is this website.

  {% include bbz_custom/link_preview.html url="<https://www.schemastore.org/>" %}

---

## YAML traversal

There is an old blog I wrote about `jq` to travel over JSON files. Link below.

{% include bbz_custom/link_preview.html post='2023-06-24-jq-just-bash-to-travel-over-json.md' %}

Here we have `yq` to do the same on YAML files. Like this.

![yq](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/yaml/yq.png){:style="max-width:100%;margin:auto;"}

> `yq 'explode()'` dereferences anchors and aliases.  
> `yq -o=json` exports the object into JSON format.
{: .prompt-tip }

`yq` can be installed via homebrew or other methods. Please visit the link below to find out more information including the syntax of `yq`.

{% include bbz_custom/link_preview.html url="<https://github.com/mikefarah/yq>" %}

Besides, we can work with YAML in popular programming languages such as Python, Go, and JavaScript by using their libraries.

For example:

- Python with [`PyYAML`](https://pypi.org/project/PyYAML/)
- JavaScript with [`js-yaml`](https://www.npmjs.com/package/js-yaml)
- Go with [`gopkg.in/yaml.v3`](https://pkg.go.dev/gopkg.in/yaml.v3)

---

## References

- [YAML Anchors and Aliases \| smcleod.net](https://smcleod.net/2022/11/yaml-anchors-and-aliases/)
- [What is YAML? Understanding the Basics, Syntax, and Use Cases \| DataCamp](https://www.datacamp.com/blog/what-is-yaml)
