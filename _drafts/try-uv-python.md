---
title: "Let' try: UV for faster Python installing"
layout: post
author: bluebirz
description:
# date: 
categories: []
tags: [let's try, Python, UV]
mermaid: false
comment: true
image:
  path: https://images.unsplash.com/photo-1567361824561-4da92b4faafd?q=80&w=1746&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Valerie Blanchett
  caption: <a href="https://unsplash.com/photos/the-sun-is-shining-through-the-trees-in-the-distance-5pDJmIKGb5c">Unsplash / Valerie Blanchett</a>
media-path: ../assets/img/features/bluebirz/
---

{% include bbz_custom/tabs.html %}

Recently, I have been using `UV` for some time and here I would like to share about this.

---

## What is UV

`UV` is an alternative to `pip` for Python with the tag line saying that `UV` is super fast than `pip`. As far as I have tried, it's very fast to install packages, for example, `pyspark` that takes around 3 minutes with `pip` but several seconds with `UV`.

1. install uv
1. using devbox
1. get start uv

## h2

{% include bbz_custom/link_preview.html url='<https://github.com/astral-sh/uv>' %}

---

## Install UV

According to the repo, there are many ways to install `UV` such as homebrew, `curl`, `pip`. But I prefer to use `devbox`.

{% tabs install %}

{% tab install devbox %}

Start from initializing `devbox` and generating `direnv` then add `UV`.

```sh
# init devbox and direnv
devbox init
devbox generate direnv --force

# add uv into devbox
devbox add uv
```

Then edit "devbox.json" to activate Python venv when entering the directory by adding row #7.

```json
{
  "$schema":  "https://raw.githubusercontent.com/jetify-com/devbox/0.14.0/.schema/devbox.schema.json",
  "packages": ["uv@latest"],
  "shell": {
    "init_hook": [
      "echo 'Welcome to devbox!' > /dev/null",
      "source .venv/bin/activate"
    ],
    "scripts": {
      "test": [
        "echo \"Error: no test specified\" && exit 1"
      ]
    }
  }
}
```
  
Read more about `devbox` and `direnv` by following the link below.

{% include bbz_custom/link_preview.html post='2024-10-01-isolate-dev-direnv-devbox-gum.md' %}

{% endtab %}

{% tab install others %}

We can install via `curl` or `pip`.

```sh
# On macOS and Linux.
curl -LsSf https://astral.sh/uv/install.sh | sh

# With pip.
pip install uv
```

Or other methods in the link below.

{% include bbz_custom/link_preview.html url='<https://docs.astral.sh/uv/getting-started/installation/>' %}

{% endtab %}

{% endtabs %}

---

## Initialize a project

After installation, we need to initialize a project with `UV`.

```sh
# format
uv init <flags> <path>

# example
uv init
uv init .
uv init test # create folder `test`
```

Then we can see new files generated.

```md
.
├── .git
├── .gitignore
├── .python-version
├── README.md
├── main.py
└── pyproject.toml
```

and setup Python with this command.

```sh
uv python install <version>

# example
uv python install 3.12
```

Then create `venv`.

```sh
uv venv
```

And we can activate and deactivate the `venv`.

{% tabs venv %}

{% tab venv devbox %}

If we install `UV` through `devbox`, we don't have to do it manually.  
`devbox` should activate it automatically or we would run `devbox shell` if needed.

{% endtab %}

{% tab venv others %}

Run the commands.

```sh
# activate
source .venv/bin/activate

# deactivate
deactivate
```

{% endtab %}

{% endtabs %}

## update

## add/remove packages

## sync and lock

```sh
devbox init
devbox add uv
devbox generate direnv --force

uv python install 3.12
uv venv
source .venv/bin/activate

devbox update
```

---

#### h4
