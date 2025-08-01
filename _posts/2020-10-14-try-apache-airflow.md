---
title: "Let's try: Apache Airflow" 
layout: post
author: bluebirz
description: Apache Airflow allows us to create each step to run in arbitrary sequences and conditions like a flow.
date: 2020-10-14
categories: [data, data engineering]
tags: [let's try, Apache Airflow, Python]
series:
  key: airflow
  index: 1 
comment: true
image:
  path: assets/img/features/external/theodo_com_apache_airflow.png
  lqip: ../assets/img/features/lqip/external/theodo_com_apache_airflow.webp
  alt: Theodo Data & AI  | Data & AI experts
  caption: <a href="https://data-ai.theodo.com/en/technical-blog/getting-started-airflow-master-workflows">Theodo Data & AI  | Data & AI experts</a>
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

We have talked about 3 tools for integrating data with scheduling

- Task scheduler for Windows ([Data Integration (EP 3 end) - clock-work]({% post_url 2019-08-17-data-integration-ep-3 %}))
- Crontab for UNIX ([Data Integration (EP 3 end) - clock-work]({% post_url 2019-08-17-data-integration-ep-3 %}))
- Rundeck for UNIX ([Try Rundeck for automated deployment]({% post_url 2019-10-31-try-rundeck %}))

Here we go again with this, Apache Airflow. It is the main tools of us right now.

---

## Prologue

Apache Airflow is an open-source program under Apache foundation. It allows us to create each step to run in arbitrary sequences and conditions like a flow. The flow is called "DAG" in which stands for "Directed Acyclic Graph".

![airflow logo](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-airflow/feature-image.png)
*Credit: <https://airflow.apache.org>*

Apache Airflow is one of popular tools for Data Engineers like us as it is easy to use and yes, it's free. We can deploy either Bash or Python scripts on it from day one.

Time to go!

---

## Build an Airflow Docker

We use a Docker image of Airflow this time.

```sh
docker pull puckel/docker-airflow
docker run -d -p 8080:8080 – name airflow -v /path/in/my/machine/:/usr/local/airflow/dags puckel/docker-airflow webserver
```

Commands above is to download an image of [Puckel/docker-airflow](https://hub.docker.com/r/puckel/docker-airflow) (It's unofficial one before [an official image](https://hub.docker.com/r/apache/airflow)). Then we use `docker run` to build a container with the following parameters:

- `-d` (detach) execute it as a background process
- `-p 8080:8080` (publish) to forward a port of the container to our machine.  
  The first 8080 is a port of our machine and the last 8080 is the container's.
- `--name airflow` to name the container as "airflow"
- `-v /path/in/my/machine/:/usr/local/airflow/dags` (volume) to mount path of machine to the container.  
  Here we mount the path to /airflow/dags that is the main folder to run scripts on Airflow
- `puckel/docker-airflow` is the name of the image
- `webserver` specify a service name.  
  It is a web service because Apache Airflow works as a web-based application.

---

## Start a web of Airflow

We need to verify the container is running by this command:

```sh
docker ps -a
```

![run container](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-airflow/Screen-Shot-2020-10-11-at-18.42.22.png)
*Container is running*

That is running as we saw "Up" not "Exited".

We now can open a web of Airflow at <http://localhost:8080/admin/> with the default username/password that is "airflow"/"airflow".

![airflow ui](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-airflow/Screen-Shot-2020-10-11-at-18.53.12.png)

---

## Run a sample DAG

We are going to use the sample script from [the official doc](https://airflow.apache.org/docs/stable/tutorial.html). Save it as a new Python file named "tutorial.py" in the mounted path.

![prep dag file](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-airflow/Screen-Shot-2020-10-11-at-18.53.51.png)

Refresh the page and it will be a new row in the table. We can see it is "tutorial" DAG.

![update dag](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-airflow/Screen-Shot-2020-10-11-at-18.48.36.png)

Click on it to show <kbd>Tree view</kbd>, the hierarchy and history of this DAG.

![dag tree](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-airflow/Screen-Shot-2020-10-12-at-00.01.43.png)

When click on <kbd>Code</kbd>, the source code of the DAG will be shown.

![dag code](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-airflow/Screen-Shot-2020-10-11-at-23.04.50.png)

---

## Run the DAG

There are 2 ways to run the DAG – manual run by click the first play button located in the column "Link" and schedule run. Enable the DAG at the first of all via the switch at the left of DAG's name.

![dag on](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-airflow/Screen-Shot-2020-10-11-at-23.12.32.png)

When it started to run, the `DAG()` will be initiated at the first place.

```py
dag = DAG(
    'tutorial',
    default_args=default_args,
    description='A simple tutorial DAG',
    schedule_interval=timedelta(days=1),
)
```

`'tutorial'` is the DAG's name as we saw in the table. The name must be alphabets, numbers and underscores.

---

## Operators

Each steps in the DAG is operators. Here is one of operators in the "tutorial.py". It is `BashOperator` means it can run Bash script.

```py
t1 = BashOperator(
    task_id='print_date',
    bash_command='date',
    dag=dag,
)
```

The `t1` is `BashOperator` to run a command `date` to print the current date on the screen.

The `task_id` is the name of the step (only contains numbers, alphabets, and underscores as well). And the `dag=` is for mapping the operator to the `DAG()` variable.

Let's say we have declared all operators then this is the sample flow.

```py
t1 >> [t2, t3]
```

It says, when `t1` is done, do `t2` and `t3` in parallel. The Graph View becomes this.

![dag graph](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-airflow/Screen-Shot-2020-10-11-at-23.05.03.png)

If we want to run all three in a straight sequence, here is the example.

```py
t1 >> t2 >> t3
```

For more operators, check it out [here](https://airflow.apache.org/docs/stable/howto/operator/index.html).

---

## Schedule

Scheduling is a main feature of Airflow.

Airflow uses crontab (try this: <https://crontab.guru/>) to control the schedule time.

In Airflow, **all schedule time is the past by one cycle**.

Here are the samples:

### Example 1

**Run every day at 8:29 PM**

Each run will always be stamped as the day before. The image below shows the actual time is on 27th (*Started: 2020-09-27*) but Airflow specifies run date as of 26th (*Run: 2020-09-26*).

![dag run ex1](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-airflow/Screen-Shot-2020-10-11-at-23.15.52.png)

### Example 2

**Run every 19th minute**

It represents the time by last hour. This actual time is 10:19 PM (*Started: 2020-10-10T23:19:20*) but the run timestamp was a hour ago (*Run: 2020-10-10T22:19:00*).

![dag run ex2](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-airflow/Screen-Shot-2020-10-11-at-23.16.11.png)

Here is the reason. Airflow sets the time of schedule by data date as the ETL (Extract-Load-Transform) batching is for a dataset with the past timestamps.

For example, our scheduled job is now processing the data as of yesterday, Airflow treats the schedule time is as of yesterday.

For manual run, the run timestamp is the current time as it is supposed to be. The `run_id` of this case contains `manual_` as a prefix.

---

## System variables

Airflow also provides the system variables. For my own experiences, have only chances to use `{{ds}}` that is the current date.

Here is the sample code. It is to print the current date.

```py
t4 = BashOperator(
    task_id="test_t4",
    depends_on_past=False,
    bash_command="echo {{ds}}",
    dag=dag
)
```

![dag log](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-airflow/Screen-Shot-2020-10-13-at-16.00.17.png)

---

They are just an example of the usage for Apache Airflow. Hope this is useful for ya

See ya~

---

## Reference

- [airflow trigger_dag execution_date is the next day, why?](https://stackoverflow.com/questions/39612488/airflow-trigger-dag-execution-date-is-the-next-day-why)
- [Templates reference](https://airflow.apache.org/docs/stable/macros-ref)
