---
title: "Pre-commit before you commit"
layout: post
author: bluebirz
description:
# date: 
categories: []
tags: []
mermaid: true
comment: true
image:
  path: https://images.unsplash.com/photo-1580795478762-1f6b61f2fae7?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1580795478762-1f6b61f2fae7?q=10&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / CDC
  caption: <a href="https://unsplash.com/photos/woman-in-black-crew-neck-t-shirt-standing-beside-woman-in-white-t-shirt-CMhVRKI6vSY">Unsplash / CDC</a>
media_subpath: 
---

Git is a must for developers. It is easy to store our source code, track, and review, but have you been ensure that you pushed clean code aligned with your team's standards to the repo?

---

## Introduce "pre-commit"

`pre-commit` is a tool to automatically run scripts to **lint**, **check**, **validate** our source code. Once setup it works so well with **Git** and let us know before committing unclean code. That's why it's called `pre-commit`.

The concept is to have a configuration with desired hooks. Each hook will trigger a script to check our code, and all hooks in the configuration **must be run before** we commit the code to repo. If any hook fails, we can see and fix it then commit and push again.

```mermaid
flowchart 
    subgraph local["git:local repo"]
        pc["pre-commit"]

        subgraph conf["config file"]
            hr1["hooks repo 1"] --> h1["hook 1"] --> chk1["check format"]
            hr1 --> h2["hook 2"] --> chk2["check syntax"]

            hr2["hooks repo 2"] --> h3["hook 3"] --> chk3["check paths"]
            hr2 --> h4["hook 1"] --> chk4["check files"]
        end
    end

    subgraph remote["git:remote repo"]
        repo
    end

    developer --"will commit"--> pc --> conf
    conf --"all passed"--> committed --"push"--> remote
```

Simple right?

Here is the webpage of `pre-commit`.

{% include bbz_custom/link_preview.html url='<https://pre-commit.com/>' %}

---

## Setup

### install pre-commit

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

### install pre-commit hooks

After installing `pre-commit`, we have to install its hooks into our Git local repo.

```sh
pre-commit install

# it should output:
# pre-commit installed at .git/hooks/pre-commit
```

### create a config file

`pre-commit` needs a configuration file named ".pre-commit-config.yaml". We can create an empty file then add contents ourselves or create from sample like this.

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

- Run pre-commit hooks on all staged files:
    pre-commit run

- Run pre-commit hooks on all files, staged or unstaged:
    pre-commit run --all-files

- Clean pre-commit cache:
    pre-commit clean

- Update pre-commit configuration file to the latest repos' versions:
    pre-commit autoupdate

### Config

### Github Actions

---

## Git hooks

---

{% include bbz_custom/link_preview.html url='<https://github.com/pre-commit/pre-commit-hooks>' %}

{% include bbz_custom/link_preview.html url='<https://github.com/topics/pre-commit>' %}

---

- [pre-commit-hooks](https://github.com/pre-commit/pre-commit-hooks)
- [pre-commit-trivy](https://github.com/mxab/pre-commit-trivy)
- [Collection of git hooks for Terraform to be used with pre-commit framework](https://github.com/antonbabenko/pre-commit-terraform)

[Github topic: pre-commit](https://github.com/pre-commit/pre-commit-hooks) [Github topic: precommit](https://github.com/topics/precommit)
