---
title: ignore and keep in Git
layout: post
author: bluebirz
description:
# date:
categories: []
tags: []
comment: true
# series:
#   key: asd
#   index: 1
image:
  path: https://images.unsplash.com/photo-1627399270231-7d36245355a9?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1627399270231-7d36245355a9?q=10&w=490&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Gabriel Heinzer
  caption: <a href="https://unsplash.com/photos/a-close-up-of-a-computer-screen-with-a-bunch-of-words-on-it-EUzk9BIEq6M">Unsplash / Gabriel Heinzer</a>
---

{% include bbz_custom/tabs.html %}

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

{% tabs igfile %}

{% tab igfile folder tree %}

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

{% endtab %}

{% tab igfile .gitignore %}

We ignore 2 secret files under `secret-folder/`{: .filepath} so they won't take place in the commit.

{: file='.gitignore' icon='devicon-git-plain'}

```
secret-folder/super-secret-file.txt
secret-folder/confidential.txt
```

{% endtab %}

{% tab igfile result %}

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

{% endtab %}

{% endtabs %}

### Ignore by a directory name

We can also put the directory name to ignore every files inside. It could end with a slash (`/`) or not, either way works.

{% tabs igdir %}

{% tab igdir folder tree %}

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

{% endtab %}

{% tab igdir .gitignore %}

{: file='.gitignore' icon='devicon-git-plain'}

```
secret-folder # or secret-folder/
```

{% endtab %}

{% tab igdir result %}

```sh
$ git status -u 

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        .gitignore
        normal-file2.txt
        normal-file3.txt
        normal-folder/normal-file1.txt
```

{% endtab %}

{% endtabs %}

### Ignore by patterns

We can also ignore files with `glob` patterns.

{% tabs igglob %}

{% tab igglob folder tree %}

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

{% endtab %}

{% tab igglob .gitignore %}

This will ignore every files in every directories where the file name starts with any characters (`*`), followed by `-file`, followed by any characters (`*`), and ends with `.txt`.

{: file='.gitignore' icon='devicon-git-plain'}

```
*-file*.txt  # or **/*-file*.txt
```

{% endtab %}

{% tab igglob result %}

```sh
$ git status -u 

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        .gitignore
        secret-folder/confidential.txt
        secret-folder/public.txt
```

{% endtab %}

{% endtabs %}

### Ignore but include a specific one

After we ignore some directories but just realize that we still need some files inside. We can use `!` like this.

{% tabs iginc %}

{% tab iginc folder tree %}

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

{% endtab %}

{% tab iginc .gitignore %}

First we ignore every files inside the directory by `directory/*` to claim the file level, not directory level. Then add files we want to include by having `!` in front. Now we can see that file is going to be committed.

{: file='.gitignore' icon='devicon-git-plain'}

```
secret-folder/*
!secret-folder/public.txt
```

{% endtab %}

{% tab iginc result %}

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

{% endtab %}

{% endtabs %}

### Personal `.gitignore`

We can maintain the ignore file at `.git/info/exclude`{: .filepath}. This file works like `.gitignore`{: .filepath} but it won't be recognized by Git so it won't be store in the remote repository.

The benefit from this is that we can make new files in our local repository and will be **ignored to Git without changing `.gitignore`{: .filepath}** so that it won't affect our teammates' working environments.

For example:

{% tabs exclude %}

{% tab exclude folder tree %}

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

{% endtab %}

{% tab exclude .gitignore %}

Here we just ignore only the directory `secret-folder/`{: .filepath}.

{: file='.gitignore' icon='devicon-git-plain' %}

```
secret-folder/
```

{% endtab %}

{% tab exclude exclude %}

But in here we also want to ignore `normal-file2.txt`{: .filepath} as well.

{: file='.git/info/exclude' %}

```
# git ls-files --others --exclude-from=.git/info/exclude
# Lines that start with '#' are comments.
# For a project mostly in C, the following would be a good set of
# exclude patterns (uncomment them if you want to use them):
# *.[oa]
# *~

normal-file2.txt
```

{% endtab %}

{% tab exclude result %}

```
$ git status -u

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        .gitignore
        normal-file3.txt
        normal-folder/normal-file1.txt
```

{% endtab %}

{% endtabs %}

### Easy creation

---

## `.gitkeep`

Git basically doesn't include empty directories. For example, if I have

```
.
├── current-write
│   └── sample.txt
└── will-write
```

Then I can't commit the directory `will-write/`{: .filepath} because it is empty.

```sh
$ git status -u

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        current-write/sample.txt
```

So I just create an empty file named `.gitkeep`{: .filepath} inside `will-write/`{: .filepath} to make Git recognize it.

```
.
├── current-write
│   └── sample.txt
└── will-write
    └── .gitkeep      # <-- newly created
```

Then the dictory `will-write/`{: .filepath} can be committed  there.

```sh
$ git status -u

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        current-write/sample.txt
        will-write/.gitkeep
```

However, `.gitkeep`{: .filepath} is not one of special files at all. In fact, we can create **any** name to the file because we just want the directory to be not empty and Git can recognize. And the name `.gitkeep`{: .filepath} is just a convention name to see that the file is keeping the directory in Git.

---

## References

- [Ignoring files - GitHub Docs](https://docs.github.com/en/get-started/git-basics/ignoring-files)
- [Git - gitignore Documentation](https://git-scm.com/docs/gitignore)
- [glob (programming) - Wikipedia](https://en.wikipedia.org/wiki/Glob_(programming))
