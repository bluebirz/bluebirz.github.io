---
title: "Let's try: Apache Airflow 2"
layout: post
author: bluebirz
description: Airflow 2 comes with lots of improvements. Why not spend some times to get know this for easier batch job development?
date: 2022-12-29 00:00:00 +0200
categories: [data, data engineering]
tags: [let's try, Apache Airflow, Python]
image:
  path: ../assets/img/features/external/theodo_com_apache_airflow.png
  alt: Theodo Data & AI  | Data & AI experts
  caption: <a href="https://data-ai.theodo.com/en/technical-blog/getting-started-airflow-master-workflows">Theodo Data & AI  | Data & AI experts</a>
---

[expand-series]

1. [Let's try: Apache Airflow]({% post_url 2020-10-14-try-apache-airflow %})
1. Let's try: Apache Airflow 2

[/expand-series]

This is a new version of Airflow. You can go back read the tutorial I made about Airflow 1 above.

---

## What's new?

As far as I read the changelog, I can summarize the big points that we can reach and use it as a consumer here.

---

## New UI

Of course, it comes with new cleaner user interface, more understandable history page.

![airflow 2 ui](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-airflow-2/airflow-2.0-ui.gif)
*source: <https://airflow.apache.org/blog/airflow-two-point-oh-is-here/>*

---

## TaskFlow API

Now we can add the decorator `@task` on top of a method and assign them as a python operator. This feature is new to me as well in order to make code cleaner and easier to read. I will write this later.

and et cetera.

A little gimmick here. Twisting fan.

![fan gif](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-airflow-2/winding-airflow.gif)

Can visit the official page [here](https://airflow.apache.org/blog/airflow-two-point-oh-is-here/) to read all changes.

---

## Installation in docker

I do have time back then to build a container of Airflow 1 in my macbook but found the official image at that time isn't good enough. Kind of information is lacking in the website and configurations are lots to go. So I ended up using [Puckel's image](https://hub.docker.com/r/puckel/docker-airflow/) instead.

Now the official docker compose for Airflow 2 has been launched here so I have no need to find out an other more reliable one.

I have assembled the steps defined at the [Airflow documentation page](https://airflow.apache.org/docs/apache-airflow/stable/howto/docker-compose/index.html) into a repo below. You can clone and try yourself.

{% include bbz_custom/link_preview.html url='<https://github.com/bluebirz/airflow-docker>' %}

---

## Details in the repo

- The installation starts from docker-compose.yaml. If you want to get more familiar with this, can visit my [latest blog]({% post_url 2022-12-10-try-docker-compose %}).
- The original docker-compose.yaml relies on default image but I want ability to add additional  python packages, so that I create a simple dockerfile. You can add yours at requirements.txt and constraint.txt if needed.
- Disable sample DAGs at line 59 of docker-compose.yaml

```yaml
AIRFLOW__CORE__LOAD_EXAMPLES: 'false'
```

- Prepare all necessary directory: `/dags`, `/logs`, `/plugins`. Mostly use `/dags` for works.

---

## Let's hands-on

### 0. Prepare all dependencies

Make sure all dependencies of our works are listed in requirements.txt and constraints.txt (if any) before go next.

For example, I put the package `pysftp` in the file so when we build an image up, the following packages will be installed in the worker instance and be ready to use.

Also find the available packages via <https://pypi.org>.

![requirements.txt](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-airflow-2/dep-requirements.png)

### 1. docker-compose up

Now it is ready to go. Run this to roll the ball.

```sh
docker-compose up
```

Seconds after this will show the necessary images are downloading.

![compose up](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-airflow-2/compose-up.png)

Next are to create the scheduler which is for scheduling our jobs, and the worker that execute them.

![compose up 2](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-airflow-2/airflow-01-worker.png)

And the last one is webserver. We see this means we are ready to view the airflow webpage now.

![compose up 3](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-airflow-2/airflow-02-webserver.png)

### 2. Logging in

Open a browser then go to <http://localhost:8080>. Use the username/password as `airflow`/`airflow` to login this page.

![login](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-airflow-2/airflow-03-login.png)

It should be successful and now we can see the first page of Airflow here.

![login success](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-airflow-2/airflow-04-dags.png)

### 3. Try add a DAG

Back to the editor. I example the DAG from <https://airflow.apache.org/docs/apache-airflow/stable/tutorial/fundamentals.html> and save it in the folder `/dags` like this.

![dag](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-airflow-2/airflow-05-daglist.png)

It wouldn't show in the DAGs list instantly. We can trigger them by

1. Access the worker instance with the command.  

      ```sh
      docker exec -it <airflow-worker-container-name> /bin/bash
      ```

      The "airflow-worker-container-name" can be retrieved by `docker ps -a` and choose one with "worker" in its name.

2. List the DAGs with command.  

      ```sh
      airflow dags list
      ```

      It will automatically compile DAGs files and display on the web if all is successful.

![dag run](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-airflow-2/airflow-06-dagshow.png)

### 4. Break a DAG to see errors

In some cases, the web show some errors, for example we programmatically put wrong syntaxes or imports.

We can check the failed one by this command.

```sh
airflow dags list-import-errors
```

There will be a table showing all error messages in every DAGs files.

![dag err](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-airflow-2/airflow-07-dagerror.png)

### 5. Let the DAG runs

Say every DAGs are good. When we click one and go see the UI of DAG history is improved. It's more modern, clearer, and neater.

![dag grid](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-airflow-2/airflow-08-history.png)

DAG history is quite easier to read. It shows some basic stats about the DAGs at a side.

![dag history](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-airflow-2/airflow-09-run.png)

And the graph is not much differ, yet better, right?

![dag graph](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-airflow-2/airflow-10-graph.png)

### 6. docker-compose down

Stop the running terminal ( <kbd>ctrl</kbd> + <kbd>C</kbd> on Mac) and put down them using this command.

```sh
# stop all containers
docker-compose down

# stop all containers and remove everything
docker-compose down --volumes --rmi all
```

![down](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-airflow-2/compose-down.png)

This is just an introduction of Airflow 2 developing on Docker technology. I don't recommend this for Production but it is great for local development.

---

If you are looking for the best way to deal with Airflow job, you can try this way and hope it will be useful for you.
