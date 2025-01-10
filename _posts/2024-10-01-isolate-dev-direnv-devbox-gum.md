---
title: isolated development with direnv & devbox (& gum)
layout: post
description: this is what included tabs in a post could look like
date: 2024-10-01 00:00:00 +0200
categories: [devops]
tags: [direnv, devbox, gum]
---
![https://unsplash.com/photos/a-small-glass-bowl-with-a-plant-inside-vuszIoUBjMA](https://images.unsplash.com/photo-1665411418278-fbfdfca1bdcb?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D){:class="img-fluid rounded z-depth-1"}
*[Unsplash/Mamun Srizon](https://unsplash.com/photos/a-small-glass-bowl-with-a-plant-inside-vuszIoUBjMA)*

In real world development, we have to maintain environment variables e.g. target urls, service port number, database table name, etc. It would sound messy if we have to declare those variables every time we open an IDE, and would be more pain if we need to switch to another environment.

In this blog we will talk about 3 tools to make a deal with multiple environments easier.

1. `direnv` to get folder ready for environment variables.
1. `devbox` to make a folder isolated like a container for packages installed.
1. `gum` to switch environment easily.

Plus a big advantage for team collaboration because they are file-based that we can push to the repo (with proper security management).

---

# direnv for env

`direnv` is a tool to setup environment when access a prepared folder. For example, we enter a folder of Python and it automatically activates `venv` for us.

## direnv setup

1. We need to install `direnv`. In my setup, I installed it through homebrew.
1. Once it's installed, add the hook into your shell file. In my setup that uses zsh, I just add this line into my `~/.zshrc`.

```sh
eval "$(direnv hook zsh)"
```

And that's it. We are ready to initial my folder.

## direnv usage

### auto-scripts

Say we want to develop a Python app. Once we created `venv`, we have to `activate` it first, and `deactivate` at last, right?

With `direnv` we don't have to do so. Just enter the folder and it will `activate` and `deactivate` when leave the folder for us. Follow this.

1. Create `venv`
![venv](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/direnv-devbox-gum/dir01-venv.png){:class="img-fluid rounded z-depth-1"}
2. Create `.envrc` to activate `venv`. End with `layout python`

<script src="https://gist.github.com/bluebirz/b3ae7f0d6f621fed566f9c39305b8763.js?file=.envrc"></script>

3. Make sure we are in the folder and `direnv allow` to execute `.envrc`
![allow](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/direnv-devbox-gum/dir02-allow.png){:class="img-fluid rounded z-depth-1"}
4. Leave the folder and see `direnv` deactivate the environment.
![leave](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/direnv-devbox-gum/dir03-leave.png){:class="img-fluid rounded z-depth-1"}

We can check Python `venv` with command `which pip`. The figure above represent my prompt showing `venv` from Oh-my-posh installed. Learn more about it from my [dotfiles](https://github.com/bluebirz/dotfiles) or <https://ohmyposh.dev.>

### embedded env vars

Beside of that auto-script, the another main objective of `direnv` is to embed variables into the environment.

Let's say we embed a variable `env` into this folder. `.envrc` would look like this.

<script src="https://gist.github.com/bluebirz/b3ae7f0d6f621fed566f9c39305b8763.js?file=.envrc-export"></script>

When we `direnv allow` and enter the folder, we will access the variable `env`. And get nothing when leave the folder.

!img

Now we don't have to create and remove variables we declared over and over again.

Our lives go easier by +1 step.

---

# devbox for packages

Move to another tool. `devbox` enables a directory installs packages locally

## devbox setup

```sh
curl -fsSL https://get.jetify.com/devbox | bash
```

If that is the error `Error: Unable to find nix startup file`, please try installing Nix package manager.

```sh
sh <(curl -L https://nixos.org/nix/install) # for macos
```

## devbox usage

First, init it.

```sh
devbox init
```

then we can see a file "devbox.json".
<script src="https://gist.github.com/bluebirz/b3ae7f0d6f621fed566f9c39305b8763.js?file=devbox.json"></script>
