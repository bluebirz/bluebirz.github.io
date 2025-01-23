---
title: Data Integration (EP 3 end) - clock-work
layout: post
description: So many tools can schedule tasks but this time we will use the innate programs.
date: 2019-08-17 00:00:00 +0200
categories: [data, data engineering]
tags: [ETL, ELT, Talend, task scheduler, crontab]
image: 
  path: ../assets/img/features/unsplash/fabio-sasso-lw11Pfusquw-unsplash.jpg
  alt: Unsplash / Fabio Sasso
  caption: <a href="https://unsplash.com/photos/green-and-white-metal-pipe-lw11Pfusquw">Unsplash / Fabio Sasso</a>
---

[expand-series]

  1. [Data Integration (EP 1) – Give me your data]({% post_url 2019-07-11-data-integration-ep-1 %})
  1. [Data Integration (EP 2) - Take it out]({% post_url 2019-08-10-data-integration-ep-2 %})
  1. Data Integration (EP 3 end) - clock-work

[/expand-series]

Hello guys and myself!

We have created a simple program from Talend on the latest episode, right? Now we go setup the program. So many tools can schedule tasks but this time we will use the innate programs that are:

- Task Scheduler of Windows OS or
- Crontab of Unix-based OS e.g. OSX and Linux

Firstly, we need to export our program to be the executable files.

---

## How can we export our program?

Start from saving our program after test it without any errors then right-click at the job in Repository and select Build Job.

![talend build menu](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/Screen-Shot-2562-08-13-at-23.23.17.png)

Choose the path of the export. It will be a zip file that is able to be unzip after export by tick "Extract zip file".

Don't forget to click <kbd>Override parameter's values</kbd> > <kbd>Values from selected context</kbd> in case we set contexts in the program.

![talend override params](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/Screen-Shot-2562-08-13-at-23.29.09.png)

Once finished, Talend takes some time to build a program. We will find it at the destination path. As the figure below, `bat` and `sh` files are in the place. `bat` is for running on Windows while `sh` one is for Unix.

![check executable files](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/Screen-Shot-2562-08-13-at-23.37.31.png)

Inside those files, we can find the context in the format `--context_param fpath="..."` and we can modify it as we desire.

![executable params](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/Screen-Shot-2562-08-13-at-23.42.00.png)

And yeah we got the program then we go setup the schedule time to run it.

---

## Task Scheduler (Windows OS)

Find this on start button as below.

![task scheduler](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/task-scheduler.jpg)

The main interface.

![task scheduler interface](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/task-scheduler-02.jpg)

Click <kbd>Task Scheduler Library</kbd> to view all schedule and create a new one by click <kbd>Create Task</kbd> at the right-hand side.

![task scheduler create task](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/task-scheduler-03.png)

We can set the values as the figures below:

![create task](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/task-scheduler-04.png)
*name a task*

![set time](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/task-scheduler-05.jpg)
*set time of schedule*

![set path](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/task-scheduler-06.jpg)
*set program path and context*

![set conditions](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/task-scheduler-07.jpg)
*set condition based on machine status*

![set failure conditions](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/task-scheduler-08.jpg)
*set condition in case of failure*

This is the history of running a sample task on schedule. I had set it to be run every hour as we can view its changes easily.

![task scheduler history](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/task-scheduler-09.png)

The sample output files.

![outputs](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/task-scheduler-10.jpg)

---

## Crontab (Unix)

Other than task scheduler, Crontab is an innate tool of Unix that is quite easy to use. It's concept is to define a format of schedule time plus a command. That format is below:

`[minute] [hour] [day_of_week] [date_of_month] [month] [command]`

For example, the schedule is midnight of every single night then we can write as this:

`0 0 * * * bash Talend_program.sh`

The meaning is, Talend_program.sh will be run at 00:00. The asterisk (*) means whatever values – it is written as `[day_of_week] [date_of_month] [month]` means every day of every month.

You can play around the crontab syntax by visit <https://crontab.guru>

We shall set this command by open Terminal and type `crontab -e`

Hit <kbd>i</kbd> for insertion mode ( `--INSERT--` should be shown at the bottom-left of the screen) then type the command as below:

![crontab vi](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/Screen-Shot-2562-08-14-at-22.09.18.png)

After that, hit <kbd>Esc</kbd> to exit the insertion mode then <kbd>:wq</kbd> (write then quit) + <kbd>enter</kbd> to save it. When we don't want this command to be run, just edit this file by removing that line or insert `#` at the front of that line to make it a comment as the program doesn't run comments.

Use `crontab -l` to list all of our schedules

![crontab list](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/Screen-Shot-2562-08-14-at-22.17.52.png)

Here is the result of the crontab.

![sample outputs](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/Screen-Shot-2562-08-16-at-21.06.09.png)

And … this is just a tiny ability Talend can do. You can design and apply it more than what I've shown. Let's play with it and feel fun.

---

## References

- [Understanding Crontab in Linux with 20 Useful Examples for Scheduling Tasks](https://tecadmin.net/crontab-in-linux-with-20-examples-of-cron-schedule/)
- [crontab guru](https://crontab.guru/)
