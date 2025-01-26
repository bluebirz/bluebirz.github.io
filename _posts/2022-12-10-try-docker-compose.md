---
title: "Let's try: Docker-compose"
layout: post
description: Dockerfile and docker-compose are tools to create an image or a cluster of images by ourselves.
date: 2022-12-10 00:00:00 +0200
categories: [devops]
tags: [Docker, container, docker-compose]
image:
  path: https://images.unsplash.com/photo-1606964212858-c215029db704?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Barrett Ward
  caption: <a href="https://unsplash.com/photos/red-and-blue-cargo-containers-5WQJ_ejZ7y8">Unsplash / Barrett Ward</a>
---

We once have talked about [Docker]({% post_url 2019-09-19-try-docker %}) and <https://hub.docker.com>, where we can find millions of images we can start from.

But that is just an image where we can **get and build** a single container. How about we want to create one ourselves and then a cluster of many different containers?

The answer is Dockerfile and Docker-compose.

---

## Dockerfile vs Docker-compose

**Dockerfile** is a file named "Dockerfile" where we can start creating a base image to put our programs or scripts inside to do one task.

For example, we can create a Dockerfile to **build** an image then a single container for a simple "Hello World" webpage using NodeJS as a base image.

While **Docker-compose** is a file named "docker-compose" as well but with extension "yaml" to be "docker-compose.yaml". This is for creating an environment of **one or many** containers.

For example, we want a simple website using NodeJS that can show a table of goods inventory where is storing in PostgreSQL database. This means we will have 1 container of NodeJS and 1 container of PostgreSQL.

---

## Sample Docker-compose file

This blog we can start from a simple one. Creating 2 Debian containers. One with `curl` package installed will be **created after** another without it.

So we start from here.

### 1. create a dockerfile

We expect a Debian image with `curl`. It is a custom image so we need to create it ourselves as below. Simple.

<script src="https://gist.github.com/bluebirz/872b0a3fe27c342d1864fde1001fd14c.js"></script>

We defined this image to install `curl` at line #3 there.

At this step, we now are able to create a container using the command.

```sh
docker build . -t <image_name>:<image_version>
docker run -it <image_name>:<image_version>
```

### 2. create a docker-compose.yaml

Now we can start writing a "docker-compose.yaml".

In case you are new, YAML is a file popular at defining configuration with similarity as JSON but no brackets to frustrate our eyes and a bunch of features such as anchoring a node to use later.

We can design its behaviors. How many containers? How they connect? Where are shared volumes? etc. they are built on our wants.

<script src="https://gist.githubusercontent.com/bluebirz/4c95b53f9478d2be398d891add000880.js"></script>

For this example, we put only 2 containers; "debian1" & "debian2". You can see it is `stdin_open` and `tty` to allow the container can run interactively.

For more information about the configurations, please visit [Compose file reference](https://docs.docker.com/reference/compose-file/)

### 3. up

When the configuration files are ready, next is to start up the machine. Make sure that we put both in same directory and Docker app is online.

```sh
docker-compose up -d
```

`-d` flag means detached mode or run in background.

The terminal will run and build images then containers like this.

![build](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/docker-compose/Screenshot+2565-12-06+at+20.34.05.png)

and there are 2 containers as planned.

![2 containers](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/docker-compose/Screenshot+2565-12-06+at+20.34.16.png)

### 4. down

When everything is done, run this command to stop the container.

```sh
docker-compose down
```

or this command to wash away all resources including mounted volumes if any.

```sh
docker-compose down --volumes --rmi all
```

---

## Repo

Here is my github of this sample dockerfile and docker-compose.yaml

<https://github.com/bluebirz/sample-docker-compose>
