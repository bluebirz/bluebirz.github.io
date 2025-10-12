---
title: "Let's try: uv for faster Python packages"
layout: post
author: bluebirz
description: "uv accommodates the Python project to be faster than ever"
date: 2025-03-25
categories: [programming, Python]
tags: [let's try, Python, uv]
comment: true
image:
  path: https://images.unsplash.com/photo-1507445761851-c6c3c69b4512?q=80&w=1786&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1507445761851-c6c3c69b4512?q=10&w=490&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Malhar Garud
  caption: <a href="https://unsplash.com/photos/white-patio-umbrella-near-body-of-water-Zj8JwP3M3Do">Unsplash / Malhar Garud</a>
media-path: 
---

{% include bbz_custom/tabs.html %}

These days, I have been using `uv` and here I would like to share about this.

---

## What is uv

`uv` is an alternative to `pip` for Python with the tag line saying that `uv` is super fast than `pip`. As far as I have tried, it's very fast to install packages, for example, `pyspark` that takes around 3 minutes with `pip` but several seconds with `uv`.

I like how quick it performs for installing packages, plus the template files I don't have to write from scratch, especially "pyproject.toml" that is necessary for building packages.

For the official repo, it's here.

{% include bbz_custom/link_preview.html url='<https://github.com/astral-sh/uv>' %}

---

## Alternatives to uv

- [`pip`](https://github.com/pypa/pip): A package installer for Python.
- [`conda`](https://www.anaconda.com/download): Open-source package and environment management. Well-known for data science.
- [`poetry`](https://python-poetry.org/): A tool for dependency management and packaging in Python.

---

## Install uv

According to the repo, there are many ways to install `uv` such as homebrew, `curl`, `pip`. I prefer to use `devbox`.

{% tabs uv-install %}

{% tab uv-install devbox %}

Start from initializing `devbox` and generating `direnv` then add `uv`.

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

{% tab uv-install others %}

We can install via `curl` or `pip`.

```sh
# On macOS and Linux.
curl -LsSf https://astral.sh/uv/install.sh | sh

# With pip.
pip install uv
```

Other solutions can be found below.

{% include bbz_custom/link_preview.html url='<https://docs.astral.sh/uv/getting-started/installation/>' %}

{% endtab %}

{% endtabs %}

---

## Initialize a project

After installation, we need to initialize a project with `uv`.

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

{% tabs uv-venv %}

{% tab uv-venv devbox %}

If we install `uv` through `devbox` and have `direnv`, we don't have to do it manually.

`direnv` should activate it automatically or we would run `devbox shell` and `direnv allow` if needed.

{% endtab %}

{% tab uv-venv others %}

Run the commands.

```sh
# activate
source .venv/bin/activate

# deactivate
deactivate
```

{% endtab %}

{% endtabs %}

---

## add/remove packages

Run this command to install dependencies, or the packages, into "pyproject.toml". It's equivalent to `pip install`.

```sh
# command
uv add <packages>

# example
uv add pandas

# add from requirements.txt
uv add -r requirements.txt

# remove packages
uv remove <packages>
```

---

## run a script

Execute it by this command.

```sh
# command
uv run <script>

# example
uv run main.py # equivalent to `python3 -m main.py`
```

---

## update uv

In order to update `uv` itself, we can follow this.

{% tabs uv-update %}

{% tab uv-update devbox %}

For `devbox` users, we can update through `devbox`.

```sh
devbox update uv
```

{% endtab %}

{% tab uv-update others %}

If we install `uv` via the standalone installer, we can do this.

```sh
uv self update
```

{% endtab %}

{% endtabs %}

---

These are basic commands I currently use a lot with `uv`.

Hope this helps you guys not to wait for so long in development.
