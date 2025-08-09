---
title: "Let's try: pre-commit before you commit"
layout: post
author: bluebirz
description: Make sure the change is clean and ready to push to Git
date: 2025-08-09 
categories: [devops, integration]
tags: [pre-commit, git, Github, Github Actions, Python, unittest, pytest, Trivy, YAML, YML]
mermaid: true
comment: true
image:
  path: https://images.unsplash.com/photo-1580795478762-1f6b61f2fae7?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1580795478762-1f6b61f2fae7?q=10&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / CDC
  caption: <a href="https://unsplash.com/photos/woman-in-black-crew-neck-t-shirt-standing-beside-woman-in-white-t-shirt-CMhVRKI6vSY">Unsplash / CDC</a>
media_subpath: 
---

Git is a must for developers. It is easy to store our source code, track, and review, but have you been ensure that you pushed clean code and aligned with your team's standards to the repo?

---

## Introduce "pre-commit"

`pre-commit` is a tool to automatically run scripts to **lint**, **check**, **validate**, and much more for our source code. Once setup it lets us know before committing unclean code. That's why it's called `pre-commit`.

The concept is to have a configuration with desired hooks. Each hook will trigger a script to check our code, and all hooks in the configuration **must be run before** we commit the code to repo. If any hook fails, we can see and fix it then commit and push again.

```mermaid
flowchart 
    subgraph local["git:local repo"]
        pc["pre-commit"]

        subgraph conf["config file"]
            hr1["hook repo 1"] --> h1["hook 1"] --> chk1["check format"]
            hr1 --> h2["hook 2"] --> chk2["check syntax"]

            hr2["hook repo 2"] --> h3["hook 3"] --> chk3["check paths"]
            hr2 --> h4["hook 1"] --> chk4["check files"]
        end
    end

    subgraph remote["git:remote repo"]
        repo
    end

    developer --"will commit"--> pc --> conf
    conf --"all passed ✔︎"--> committed --"push"--> remote
```

Simple right?

Here is the webpage of `pre-commit`.

{% include bbz_custom/link_preview.html url='<https://pre-commit.com/>' %}

---

## Setup

We can setup `pre-commit` with just 1-2-3 like this.

### 1. Install pre-commit

We can install `pre-commit` in many ways. I prefer installing it via [homebrew](https://formulae.brew.sh/formula/pre-commit), and there is `pip` way as well.

```sh
# install via homebrew
brew install pre-commit

# install via pip
pip install pre-commit

# verify pre-commit
pre-commit --version
pre-commit -V 
```

### 2. Install pre-commit hooks

After installing `pre-commit`, we have to install its hooks into our Git local repo.

```sh
pre-commit install

# output should be:
# pre-commit installed at .git/hooks/pre-commit
```

### 3. Create a config file

Last, tell `pre-commit` what to do. It needs a configuration file named ".pre-commit-config.yaml". We can create an empty file then add contents ourselves or create from sample like this.

```sh
# create an empty config file
touch .pre-commit-config.yaml

# create a config file from sample
pre-commit sample-config > .pre-commit-config.yaml
```

This is the sample configuration from `pre-commit sample-config`.

```yaml
# See https://pre-commit.com for more information
# See https://pre-commit.com/hooks.html for more hooks
repos:
-   repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v3.2.0
    hooks:
    -   id: trailing-whitespace
    -   id: end-of-file-fixer
    -   id: check-yaml
    -   id: check-added-large-files
```

We can add yaml schema from [schema store](https://www.schemastore.org/pre-commit-config.json) like this to validate the configurations ([old blog: yaml]({% post_url 2025-06-28-yaml-configs-them-all %})).

```yaml
# yaml-language-server: $schema=https://www.schemastore.org/pre-commit-config.json
repos:
- repo: ...
  hooks:
    - ...
```

---

## Run it

Let's say I left a trailing space in the Python file and I use the sample configuration from `pre-commit sample-config`.

When I try to commit it, the error should be shown like this.

![precommit fails](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/pre-commit/01-precommit-fails.png){: style="max-width:85%;margin:auto;" }

> `pre-commit` can only execute on staged files. We have to `git add <file>` or it may be skipped.
{: .prompt-warning }

However, we can run it manually without committing first. So the commands are here.

```sh
# stage files
git add .

# pre-commit on changed files
pre-commit run

# pre-commit on all files (recommended) 
pre-commit run --all-files
pre-commit run -a
```

---

## Syntax

Here is the basic syntax of `.pre-commit-config.yaml` file. The completed documentation can be found at the link at the top of this blog.

```yaml
repos:
  - repo: <url | local | meta>  # [required] url of the hook repo or local or meta (for debugging)
    rev: <version>              # version of the hook repo
    hooks:
      - id: <id>                # [required] unique id for the hook
        name: <name>            # name of the hook
        entry: <entry command>  # entry command to run the hook
        language: <language>    # language of the hook, e.g. system, python, nodejs
        files: <filepath regex> # regex to match files
        types:                  # hook types, e.g. [python, text, yaml, json]
          - "<type>"
        pass_filenames: <bool>  # whether to pass filenames to the hook
        args:                   # arguments to pass to the hook
          - "<argument 1>"
          - "<argument 2>"
        additional_dependencies: # additional dependencies to install
          - "<dependency 1>"
          - "<dependency 2>"
```

---

## Integrated with Github Actions

We can add`pre-commit` step into Github Actions ([old blog: Github Actions]({% post_url 2025-07-20-try-github-actions %})) like this.

```yaml
name: <name>

on:

jobs:
  pre-commit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v4
        with:
          python-version: 3.x
      - uses: pre-commit/actions@v3.0.1
```

At the last line #13 is the step we execute `pre-commit`. There are many ways to run in Github Actions:

- use [pre-commit/actions](https://github.com/pre-commit/action) like above.
- use [pre-commit.ci](https://pre-commit.ci/)
- call `pre-commit run -a` directly in the step.

Choose the one you like.

---

## Hook types

We usually set a repo to be Github repo or `local` while `meta` is for debugging purposes.

### Repo hooks

We just add the config based on the community hooks and it's ready to work for us.

This is the simple template for repo hooks.

``` yaml
repos:
  - repo: <hook repo url> 
    rev: <branch>
    hooks:
      - id: <hook id>
```

For example, I want to check for any vulnerabilities in my Python code. I can use these:

```yaml
repos:
  - repo: https://github.com/mxab/pre-commit-trivy.git
    rev: v0.15.0
    hooks:
      - id: trivyfs-docker
        args:
          - --skip-dirs
          - ./tests
          - . # last arg indicates the path/file to scan
      - id: trivyconfig-docker
        args:
          - --skip-dirs
          - ./tests
          - . # last arg indicates the path/file to scan
```

The example above is [Trivy](https://trivy.dev/), the security scanner tool and the hook repo is from community.

### Local hooks

`local` is great and flexible when we want to run our own scripts. However, we need to have those tools in our environment such as we want to run `unittest` or `pytest` so we have to make sure that we have it installed in the local machine or the virtual environment.

```yaml
repos:
  - repo: local
    hooks:
      - id: <hook id>
        name: <hook name>
        entry: <entry command>
        language: <language e.g. system, python, nodejs>
        types: [<hook type>]
        pass_filenames: <true | false>
        additional_dependencies: [<dependency 1>, <dependency 2>]
```

For example, I want to test with `unittest` ([old blog: unittest]({% post_url 2023-02-10-python-testing-unittest %})) and also `pytest` ([old blog: pytest]({% post_url 2023-02-19-python-testing-pytest %})) on my Python code so I would add two local hooks with the relevant `entry`. Like this.

```yaml
repos:
  - repo: local
    hooks:
      - id: unit-test
        name: unit-test
        entry: python3 -m unittest discover
        language: python
        types: [python]
        pass_filenames: false
      - id: pytest
        name: pytest
        entry: python3 -m pytest
        language: python
        types: [python]
        additional_dependencies:
          - "pytest"
```

There I can run check if everything is good.

```sh
git add .
pre-commit run -a 
```

![run local hook](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/pre-commit/02-run-all.png){: style="max-width:80%;margin:auto;" .apply-border }

Or let it show everything that executes and logs.

```sh
git add .
pre-commit run -a --verbose
```

![run local hook verbose](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/pre-commit/03-run-all-verbose.png){: style="max-width:80%;margin:auto;" .apply-border }

---

## Command list

Here is the compilation of command I use frequently.

```sh
# install 
homebrew install pre-commit
pip install pre-commit

# install hooks
pre-commit install

# create sample config file
pre-commit sample-config > .pre-commit-config.yaml

# run manually
git add .
pre-commit run
# run all files manually
pre-commit run -a 
pre-commit run --all-files
# run all files manually with verbose
pre-commit run -a --verbose

# clean cache from the run
pre-commit clean

# update `rev` in `.pre-commit-config.yaml` to the latest
pre-commit autoupdate
```

---

## Interesting hook sites

These links are `pre-commit` hook repos I think they're useful for developing our checks before deployment in various situations.

- [pre-commit-hooks](https://github.com/pre-commit/pre-commit-hooks): basic hooks for Python,
- [pre-commit-trivy](https://github.com/mxab/pre-commit-trivy): hooks for scanning vulnerabilities, secrets, and misconfigurations.
- [Collection of git hooks for Terraform to be used with pre-commit framework](https://github.com/antonbabenko/pre-commit-terraform)
- [Github topic: pre-commit](https://github.com/pre-commit/pre-commit-hooks)
- [Github topic: precommit](https://github.com/topics/precommit)

---

## Repo

I created a repo for `pre-commit` samples here. This repo also includes `.pre-commit-config.yaml` in some applications.

{% include bbz_custom/link_preview.html url='<https://github.com/bluebirz/sample-pre-commit>' %}
