---
title: Isolated development with direnv & devbox (& gum)
layout: post
author: bluebirz
description: In this blog we will talk about 3 tools to make a deal with multiple environments easier.
date: 2024-10-01
categories: [programming, tools]
tags: [direnv, devbox, gum]
comment: true
image:
  path: https://images.unsplash.com/photo-1665411418278-fbfdfca1bdcb?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1665411418278-fbfdfca1bdcb?q=10&w=490&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Mamun Srizon
  caption: <a href="https://unsplash.com/photos/a-small-glass-bowl-with-a-plant-inside-vuszIoUBjMA">Unsplash / Mamun Srizon</a>
---

In real world development, we have to maintain environment variables e.g. target urls, service port number, database table name, etc. It would sound messy if we have to declare those variables every time we open an IDE, and would be more pain if we need to switch to another environment.

In this blog we will talk about 3 tools to make a deal with multiple environments easier.

1. `direnv` to get folder ready for environment variables.
1. `devbox` to make a folder isolated like a container for packages installed.
1. `gum` to switch environment easily.

plus a big advantage for team collaboration because they are file-based that we can push to the repo (with proper security management).

---

## direnv for env

`direnv` is a tool to setup environment when access a prepared folder. for example, we enter a folder of python and it automatically activates `venv` for us.

### direnv setup

1. we need to install `direnv`. in my setup, i installed it through homebrew.
1. once it's installed, add the hook into your shell file. in my setup that uses zsh, i just add this line into my `~/.zshrc`.

```sh
eval "$(direnv hook zsh)"
```

and that's it. we are ready to initial my folder.

### direnv usage

#### auto-scripts

say we want to develop a python app. once we created `venv`, we have to `activate` it first, and `deactivate` at last, right?

with `direnv` we don't have to do so. just enter the folder and it will `activate` and `deactivate` when leave the folder for us. follow this.

1. create `venv`
![venv](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/direnv-devbox-gum/dir01-venv.png){:style="max-width:80%;margin:auto;" .apply-border}
2. create `.envrc` to activate `venv`. end with `layout python`

<script src="https://gist.github.com/bluebirz/b3ae7f0d6f621fed566f9c39305b8763.js?file=.envrc"></script>

3. Make sure we are in the folder and `direnv allow` to execute `.envrc`
![allow](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/direnv-devbox-gum/dir02-allow.png){:style="max-width:80%;margin:auto;" .apply-border}
4. Leave the folder and see `direnv` deactivate the environment.
![leave](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/direnv-devbox-gum/dir03-leave.png){:style="max-width:80%;margin:auto;" .apply-border}

We can check Python `venv` with command `which pip`. The figure above represent my prompt showing `venv` from Oh-my-posh installed. Learn more about it from my [dotfiles](https://github.com/bluebirz/dotfiles) or <https://ohmyposh.dev.>

#### embedded env vars

Beside of that auto-script, the another main objective of `direnv` is to embed variables into the environment.

Let's say we embed a variable `env` into this folder. `.envrc` would look like this.

<script src="https://gist.github.com/bluebirz/b3ae7f0d6f621fed566f9c39305b8763.js?file=.envrc-export"></script>

When we `direnv allow` and enter the folder, we will access the variable `env`. And get nothing when leave the folder.

![env](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/direnv-devbox-gum/dir04-env.png){:style="max-width:80%;margin:auto;" .apply-border}

Now we don't have to create and remove variables we declared over and over again.

Our lives go easier by +1 step.

---

## devbox for packages

Move to another tool. `devbox` enables a directory installs packages locally

### devbox setup

```sh
curl -fsSL https://get.jetify.com/devbox | bash
```

If that is the error `Error: Unable to find nix startup file`, please try installing Nix package manager.

```sh
sh <(curl -L https://nixos.org/nix/install) # for macos
```

### devbox usage

First, init it.

```sh
devbox init
```

then we can see a file "devbox.json".
<script src="https://gist.github.com/bluebirz/b3ae7f0d6f621fed566f9c39305b8763.js?file=devbox.json"></script>

Now we need to find the packages we want to install using `devbox` search like this.  

```sh
devbox search package
devbox search package@version
```

![search](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/direnv-devbox-gum/db01-search.png){:style="max-width:80%;margin:auto;" .apply-border}

Okay, we are gonna add Python 3.10 via  

```sh
devbox add python@3.10
```

If this is a first time, `devbox` will install nix package manager if it's not installed yet.  

![devbox first time](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/direnv-devbox-gum/db02-add-first.png){:style="max-width:80%;margin:auto;" .apply-border}

Next time we can see the package has been being installed.  

![devbox add after](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/direnv-devbox-gum/db03-add-next.png){:style="max-width:80%;margin:auto;" .apply-border}

Then we should see the updated "devbox.json" like this.
<script src="https://gist.github.com/bluebirz/b3ae7f0d6f621fed566f9c39305b8763.js?file=devbox-1.json"></script>

The `packages` shows "python@3.10" (line 4) right there.  

Next we start with the command below.

```sh
devbox shell # start shell
```

And we can see the python environment has been created. Basically `venv` folder named ".venv".  

And exit at the end.

```sh
exit # exit shell
```

![devbox shell](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/direnv-devbox-gum/db04-shell.png){:style="max-width:80%;margin:auto;" .apply-border}

However the env is in `.venv`. We can custom the folder name by adding `env` (line 17-19) and apply it in `init_hook` (line 9) like this.

<script src="https://gist.github.com/bluebirz/b3ae7f0d6f621fed566f9c39305b8763.js?file=devbox-2.json"></script>

### combo direnv & devbox

With `devbox`, we have no need to create `venv` beforehand because `devbox` will do it for us but we have to run shell and activate every time.

We can combo `devbox` with `direnv` to  run shell automatically with this command.

```sh
devbox generate direnv
```

![devbox gen direnv](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/direnv-devbox-gum/db05-gendirenv.png){:style="max-width:80%;margin:auto;" .apply-border}

`.envrc` generated this way will be like this.

<script src="https://gist.github.com/bluebirz/b3ae7f0d6f621fed566f9c39305b8763.js?file=.envrc-devbox"></script>

At this step, we now control packages and access the environment at ease.

---

## gum for multiple env

Okay we now are able to build an isolated workspace. How about maintaining multiple environment such as `dev` & `prod`?  

Of course we have to prepare multiple files for each environment. And it will be good if we can switch from an environment to another.  

We are talking about `gum`.  

`gum` is a tiny tool to represent designated prompt for a specific task. It works great and flexible in operations using shell scripts. Here we will see how can we utilize `gum` to work with multiple environment.  

### gum setup

Install via homebrew.  

```sh
brew install gum
```

 or others by your preferences by visiting the link in references below.

### gum usage

With `gum` alone, we can create a simple shell prompt like this.

![gum choose](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/direnv-devbox-gum/gum01-choose.png){:style="max-width:80%;margin:auto;" .apply-border}

And we will adapt with our setup earlier.

Say we have 2 environments; `dev` & `prod`. Also there are 2 `env` files like this.

![gum env](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/direnv-devbox-gum/gum02-env.png){:style="max-width:80%;margin:auto;" .apply-border}

And the structure becomes as below.

<script src="https://gist.github.com/bluebirz/b3ae7f0d6f621fed566f9c39305b8763.js?file=setup.md"></script>

We will use a flag of `devbox` for `direnv` to select each of both files like this. That flag is `--env-file` followed by a target env filepath. It will turn out like this in `.envrc`.

<script src="https://gist.github.com/bluebirz/b3ae7f0d6f621fed566f9c39305b8763.js?file=.envrc-devbox-gum"></script>

- `ls .envs` to list all files in `.envs` folder.
- `gum choose` to prompt choosing files from `ls` above.
- `--env-file` to input chosen files from `gum` prompt.

And we run `direnv allow`. Finally we can select any `env` file to start an environment to work with.

![gum select](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/direnv-devbox-gum/gum03-select.png){:style="max-width:80%;margin:auto;" .apply-border}
*select an env file*

![gum show](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/direnv-devbox-gum/gum04-show.png){:style="max-width:80%;margin:auto;" .apply-border}
*activate selected env*

---

## Repo

{% include bbz_custom/link_preview.html url='<https://github.com/bluebirz/sample-env>' %}

---

## References

- `direnv` <https://direnv.net>
- `direnv` wiki <https://github.com/direnv/direnv/wiki>
- `homebrew` <{{ site.url }}{{ site.baseurl }}{% post_url 2023-06-20-homebrew-one-place-for-all %}>
- `devbox` by jetify <https://www.jetify.com/devbox/>
- Nix package manager <https://nixos.org/download/>
- `gum` <https://github.com/charmbracelet/gum>
