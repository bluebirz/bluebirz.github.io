---
title: "Scrapbook: Setup Ansible and Google Cloud SDK on Windows"
layout: post
author: bluebirz
description: Ansible isn't supported on Windows so we need to have extra steps to install it, along with Google Cloud SDK.
date: 2026-05-23
categories: [scrapbook]
tags: [WSL, Windows, Ubuntu, Ansible, Python, Google Cloud Platform]
comment: true
image:
  path: assets/img/features/bluebirz/wsl.jpg
  lqip: ../assets/img/features/lqip/bluebirz/wsl.webp
  alt: Yellow notebook page containing logos of Windows 11, Ubuntu, Python, and Ansible
  caption:
---

My company laptop is Windows and lately I want to try Ansible. It took quite a long time for me to setup and ready for my experiment so I'm writing the steps here as a memo for the future.

---

## WSL

**WSL** stands for "Windows Subsystem for Linux". Even though Windows supports Git bash but it's like bash emulator while WSL is a full Linux environment. And Ansible is not supported on Windows natively, so we need WSL for the case.

{% include bbz_custom/link_preview.html url='<https://learn.microsoft.com/en-us/windows/wsl/>' %}

---

## Ansible

**Ansible** is Infrastructure as a Code (IaaC) as well as Terraform[tag: Terraform]({{ site.url }}/tags/terraform/) with great functionalities running on Python.

Ansible by design offers tasks configuration so I find it plays well on running sequential workflows. While Terraform is best at structure provisioning.[^ansiblevstf]

{% include bbz_custom/link_preview.html url='<https://www.redhat.com/en/ansible-collaborative>' %}

---

## Setup time

### 1. WSL

On Powershell or Terminal, install WSL via the command.

```powershell
wsl --install
```

To uninstall, run this[^wsl].

```powershell
wslconfig /u Ubuntu
```

### 2. Python

Open WSL and execute the following commands to install Python and family.

```sh
sudo apt update
sudo apt install -y python3 python3-venv python3-pip
```

Now we have Python and pip installed.

### 3. venv

On WSL, create `venv`.

```sh
python3 -m venv .venv
source .venv/bin/activate
```

> If an error occurs when creating `.venv`{: .filepath}, for example `ensurepip` is not available and `/bin/activate`{: .filepath} doesn't appear like me, try creating `.venv`{: .filepath} in **Linux home** path.
>
> ```sh
> cd ~                          # go to Linux home directory
> python3 -m venv .venv
> source .venv/bin/activate
>  ```
>
{: .prompt-warning }

### 4. Ansible and Google Cloud library

Next is to install our main tools, Ansible and Google Cloud *Python library*.

```sh
python -m pip install --upgrade pip
python -m pip install ansible google-auth google-cloud-<service>
```

We also need Google Cloud *Ansible library* via `ansible-galaxy`.

[`ansible-galaxy`](https://galaxy.ansible.com/) is a community to find third-party library for Ansible. `ansible-galaxy` is included and is ready out-of-the-box when we successfully installed Ansible.

```sh
ansible-galaxy collection install google.cloud
ansible --version
```

### 5. Google Cloud SDK

And install [gcloud-sdk](https://docs.cloud.google.com/sdk/docs/install-sdk) for Ubuntu for authentication in our machine.

```sh
gcloud auth login
gcloud auth application-default login
```

### 6. Verify

Last step is to ensure our environment is ready to go.

```sh
ansible --version
ansible-galaxy --version
gcloud -v
```

---

Finally we are supposed to develop Ansible workflow (on Windows) from now on.

---

## References

[^wsl]: [bash - How to completely uninstall the subsystem for Linux on Windows 10? - Super User](https://superuser.com/a/1337814)
[^ansiblevstf]: [Difference Between Terraform Vs Ansible - GeeksforGeeks](https://www.geeksforgeeks.org/devops/difference-between-terraform-vs-ansible/)
