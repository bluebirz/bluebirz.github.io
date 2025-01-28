---
title: "Let's try: Docker"
layout: post
author: bluebirz
description: We can manage to build an environment with less resources than Virtual Machine.
date: 2019-09-19 00:00:00 +0200
categories: [devops, container]
tags: [Docker, container, let's try]
image: 
  path: https://images.unsplash.com/photo-1605745341075-1b7460b99df8?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Ian Taylor
  caption: <a href="https://unsplash.com/photos/red-and-blue-cargo-ship-on-sea-during-daytime-HjBOmBPbi9k">Unsplash / Ian Taylor</a>
---

Hello all guys~

This time is for programming contents after short period of psychology in those couple of episodes.

I have been involving coding in various languages such as Bash, JAVA, Python, and NodeJS. Therefore, I need one tool to accommodate me for them.

---

![docker logo](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-docker/horizontal-logo-monochromatic-white.png)
*Source: <https://www.docker.com/company/newsroom/media-resources>*

Docker is one of elementary tools of all developers, I guess. We can manage to build an environment with less resources than Virtual Machine and need more command line skill to deal with.

---

## What is this for?

For example, we need to develop a program with tens dependencies. Only that operation can spend whole day. And the target OS is Unix but our laptops are Windows. At last, there are 3 Unix machines for production, means whole day for installing those dependencies again.

Today, we have this, **Docker**.

Docker is as a ready-to-use box. It contains dependencies and OS as we desire for our development.

---

## What is in the Docker box?

Docker is a program. We need **image** of Docker as a definition of works. An image consists of necessary components. Once we have the image, we can build a container based on that image and open the container to work on it.

![docker flow](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-docker/docker01.png)

---

## Install Docker

Firstly, we have to visit <https://hub.docker.com/> and register. Then download the installer and install it.

![docker icon](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-docker/Screen-Shot-2562-09-15-at-21.23.59.png)

We can find this icon at the Taskbar as the left-handed figure when we finished installing Docker.

Try this command on Terminal (cmd in case of Windows).

```sh
docker -v
```

![docker version](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-docker/Screen-Shot-2562-09-15-at-21.40.54.png)

If it shows a version number like above, we completely installed Docker. Yeah.

---

## Try an image

Let's try "Hello world" image.

### 1. Download the image

At Docker Hub, we can find the command to download this ([link](https://hub.docker.com/_/hello-world)) and its description.

The command to download is:

```sh
docker pull hello-world
```

![docker pull hello-world](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-docker/Screen-Shot-2562-09-15-at-22.10.16.png)

### 2. Verify the image

The command to list all images is:

```sh
docker images
# or
docker image ls
```

![docker ls](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-docker/Screen-Shot-2562-09-15-at-22.15.46.png)

### 3. Build a container from the image

Run this

```sh
docker run hello-world
```

![docker run hello-world](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-docker/Screen-Shot-2562-09-15-at-22.24.19.png)

Each image will generate different output when build a container. This example just shows a welcome message.

---

## Try Other image: Jupyter

These days, I often code in Python using Jupyter. This is how I use docker for Jupyter.

### 1. Build a container

```sh
# download image
docker pull jupyter/minimal-notebook
# build container + open port 1880 + named "jupyter"
docker run -it -p 8888:8888 – name jupyter jupyter/minimal-notebook
```

![docker pull jupyter](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-docker/Screen-Shot-2562-09-15-at-23.01.15.png)

After run, we can put options as below:

- `-it` from `-i` (interactive) to enable typing commands in Terminal and `-t` (pseudo-TTY) means display result of the commands.
- `-p` from `--port` means connect ports of container to ones of the computer. As you see, command connects port 8888:8888 that is port 8888 of Jupyter container to port 8888 of this computer. In real case we should check the ports from image documents.
- `--name` to give a name for this container to comfort us in next uses. If we don't give its name, a random name will be created.

All options can be found [here](https://docs.docker.com/engine/reference/run/).

### 2. Work on the container

The link to Jupyter browser will be created after run the container.

![docker jupyter first page](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-docker/Screen-Shot-2562-09-15-at-23.03.55.png)

![docker jupyter workspace](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-docker/Screen-Shot-2562-09-15-at-23.05.16.png)

### 3. Restart the container

Let say, we need to pause working this time. Use this command:

```sh
docker stop jupyter
```

![docker stop](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-docker/Screen-Shot-2562-09-17-at-20.14.20.png)

Then if we have time and start working again.

```sh
docker start jupyter && docker attach jupyter
```

![docker attach](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-docker/Screen-Shot-2562-09-17-at-20.17.19.png)

---

## Frequently used commands

- Check if the port 8888 is unused

```sh
# cmd on Windows
netstat -na | find "8888"
# terminal on Unix
netstat -na | grep "8888"
```

- List all images

```sh
docker images
docker image ls
```

- Remove an image

```sh
# remove one image
docker image rm {image_id}
# remove unused images
docker images prune
# remove all images
docker image rm $(docker images -q)
```

- Run a container from the image

```sh
docker run [-i=interaction] [-t=pseudo-tty] [-d=background] [-p=port {container_port}:{host_port}] [--name {name}] [-v=mount_volume {host_path}:{container_path}] [--link=connect_containers {container_name_or_id}:{link_alias} image [entry_point]
```

- start/stop a container

```sh
docker start {container_name}
docker stop {container_name}
docker restart {container_name}
```

- Run a command to a started container

```sh
# make sure the container is started
docker restart {container_name}
# execute command
docker exec [-i=interaction] [-t=pseudo-tty] [-u=user {username}] container_name {entry_point}
```

- Show console of a started container

```sh
docker attach {container_name}
```

- Remove a container

```sh
# remove one container
docker rm {container_name}
# remove all containers
docker rm $(docker ps -a -q)
```

All command is documented this [link](https://docs.docker.com/engine/reference/run/).

---

## Real world usages

Based on my own projects, I used docker containers on both development servers and production. Also use Git to transfer source code.

---

Hope soon I can have a chance to talk about it.

Bye~
