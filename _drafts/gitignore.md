---
title: ignore and keep in Git
layout: post
author: bluebirz
description:
# date:
categories: []
tags: []
pin: true
math: true 
mermaid: true
comment: true
# series:
#   key: asd
#   index: 1
image:
  # path: assets/img/features/
  path: https://images.unsplash.com/photo-1627399270231-7d36245355a9?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1627399270231-7d36245355a9?q=10&w=490&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Gabriel Heinzer
  caption: <a href="https://unsplash.com/photos/a-close-up-of-a-computer-screen-with-a-bunch-of-words-on-it-EUzk9BIEq6M">Unsplash / Gabriel Heinzer</a>
---

We can control what files or directories to be stored or not to be stored in Git remote repositories.

They are `.gitignore`{: .filepath} and `.gitkeep`{: .filepath}.

---

## `.gitignore`

There are many unnecessary files that we don't want to store in Git for example, `.venv/`{: .filepath} in Python projects, `node_modules/`{: .filepath} in Node.js projects, or `.terraform`{: .filepath} in Terraform projects. Or some data files or even a credential files in the project directory that we need to keep them in only our local machine and not in remote repositories.

`.gitignore`{: .filepath} is a file that Git uses to check and ignore them. It could be an exact file name or directory or a pattern.

### example

Let's say we have a project structure like this:

```
.
├── normal-file2.txt
├── normal-file3.txt
├── normal-folder
│   └── normal-file1.txt
└── secret-folder
    ├── confidential.txt
    ├── public.txt
    └── super-secret-file.txt

3 directories, 6 files
```

### Ignore by a file name

We can directly put the name of files. It can be just file names to ignore them in any directories, or an absolute path in case we need to store the same name in other directories.

{: file='.gitignore' icon='devicon-git-plain'}

```
secret-folder/super-secret-file.txt
secret-folder/confidential.txt
```

Then we should see what files are going to be committed like this.

```sh
$ git status -u 

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        .gitignore
        normal-file2.txt
        normal-file3.txt
        normal-folder/normal-file1.txt
        secret-folder/public.txt
```

We ignore 2 secret files under `secret-folder/`{: .filepath} so they won't take place in the commit.

### Ignore by a directory name

We can also put the directory name to ignore every files inside. It could end with a slash (`/`) or not, either way works.

{: file='.gitignore' icon='devicon-git-plain'}

```
secret-folder
```

```sh
$ git status -u 

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        .gitignore
        normal-file2.txt
        normal-file3.txt
        normal-folder/normal-file1.txt
```

### Ignore by patterns

{: file='.gitignore' icon='devicon-git-plain'}

```
*-file*.txt
```

```sh
$ git status -u 

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        .gitignore
        secret-folder/confidential.txt
        secret-folder/public.txt
```

### Ignore but include a specific file or directory

{: file='.gitignore' icon='devicon-git-plain'}

```
secret-folder/*
!secret-folder/public.txt
```

```sh
$ git status -u 

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        .gitignore
        normal-file2.txt
        normal-file3.txt
        normal-folder/normal-file1.txt
        secret-folder/public.txt
```

### Easy creation

---

## `.gitkeep`

Git basically doesn't include empty directories. For example, if I have

---

## References

<https://docs.github.com/en/get-started/git-basics/ignoring-files>
