---
title: "Let's try: Rundeck"
layout: post
description: Rundeck has capability for managing job orchestration.
date: 2019-10-31 00:00:00 +0200
categories: [devops, integration]
tags: [direnv, devbox, gum, let's try]
image:
  path: https://images.unsplash.com/photo-1517263975512-e1e9172f466b?q=80&w=2069&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Fidel Fernando
  caption: <a href="https://unsplash.com/photos/grayscale-photo-of-bicycle-derailleur-ppe3kHC1RsE">Unsplash / Fidel Fernando</a>
---

Hi Hi all guys~

Long time ago, we were playing around Talend ([Data Integration (EP 3 end)]({% post_url 2019-08-17-data-integration-ep-3 %})) to make data integration. And we found we can set schedule on the jobs with crontab and Task scheduler but they might not be comfortable sometimes.

Therefore, here is one of automated job tools.

---

![rundeck logo](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/maxresdefault-e1572194337473.jpg)
*Ref: <https://www.rundeck.com>*

Rundeck has capability for managing job orchestration. In other words, it is for automatic job scenarios.

Rundeck's features are scheduling jobs, plus:

- Job logs and history
- Error handling
- Webhook supports (apply to send notifications to Slack)
- etc.

This time, we will use Docker ([Try Docker]({% post_url 2019-09-19-try-docker %})) and Git ([Try Git]({% post_url 2019-10-04-try-git %})) together to build a simple job deployment.

All steps we need to do is:

1. Build a Talend job and upload to Git repo
1. Build a Rundeck container
1. Create a job in Rundeck

Let's go!

---

## 1. Prepare job

Build a Talend job and upload to Git repo

### 1.1 Build a job

For example, I gonna create a job displaying 10 names as below:

![Talend gen row](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/talend-gen-name.png)
*Use `tRowGeneratator` and apply function `getFirstname()` for 10 names*

![Talend test](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/talend-test.png)
*Test and get the correct results*

![talend build](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/talend-build.png)
*build it*

### 1.2 Push to repo

After that, we push the source code to Git repo. Done for first step.

![repo](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/git-rundeck.png)

### 1.3 App passwords

Because Rundeck operates job with user "Rundeck" not "Root" of the container, we need an app password to allow other user to access the repo.

![github dev setting](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/git-dev-setting.png)
*Click on profile picture then Setting to access this page and select Developer settings*

![github gen token](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/git-token.png)
*Personal access token > <kbd>Generate new token</kbd>*

![github config token](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/git-token-set.png)
*Add Note and select scope by ticking repo*

![github review password](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/git-token-ready.png)
*Got app password as this token*

For more information, please visit <https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line>

---

## 2. Prepare Rundeck

At this step, we download Docker image from this link <https://hub.docker.com/r/rundeck/rundeck>. Then connect Git repo from this container.

### 2.1 Access Container

with Root user and install Git.

```sh
docker exec -it -u root [docker_container_name]
root@docker $ apt-get update
root@docker $ apt-get install git-core
```

![prep container](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/bash-apt-update.png)

### 2.2 Prepare folder

Create a local Git repo folder. Let's say we are going to use folder "test"

```sh
mkdir test
cd test/
```

### 2.3 Clone

Clone remote repo to the folder. After run this command, the app password must be input here.

```sh
git clone [https://github.com/username/git.git]
```

![git clone](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/bash-git-clone.png)

### 2.4 Update privileges

We have to change the owner, or we will get the error about permission denial.

```sh
chown -R rundeck [git_folder]
```

![list](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/bash-list.png)

![change owner](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/bash-chown.png)

### 2.5 Update remote origin

This is for connecting remote repo with the app password.

```sh
git remote set-url origin [https://username:app_password@github.com/username/git.git]
git remote show origin
```

![git remote](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/bash-git-remote.png)

Trying `git fetch` and get no errors means completed connection.

```sh
git fetch --all
```

![git fetch](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/bash-git-fetch.png)

---

## 3. Create Rundeck job

### 3.1 Login to Rundeck

Rundeck provides default accounts defined in the file `/home/rundeck/server/config/realm.properties` as the folllowings:

```
- username = admin
  password = admin
  role = admin, user
- username = user
  password = user
  role = user
```

These roles are mapped with Access Control in another configuration file.

![realm.properties](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/bash-config-user.png)

When the Rundeck container started, open the browser and access <http://localhost:4440>. If we find this page below, login with admin account.

![rundeck login](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/rundeck-login.png)

### 3.2 create project

![new project](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/rundeck-home.png)
*click <kbd>New Project+</kbd>*

![fill project name](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/rundeck-project.png)
*Name it and other descriptions*

### 3.3 create job

![menu job](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/rundeck-job.png)
*click <kbd>Job</kbd>*

![job details](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/rundeck-job-detail.png)
*At page "Details", fill in job name and description*

![job workflow](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/rundeck-job-workflow-step.png)
*At page "Workflow", we are setting commands here*

![job steps](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/rundeck-job-workflow-create.png)
*Add steps here*

### 3.4 Fetch into local

We are going to add steps as scripts.

We put the commands below to update local repo and the job will be fresh to run every time.

```sh
cd /home/rundeck/test/test_rundeck/
git fetch – all
git reset – hard origin/master
```

![rundeck exec git](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/rundeck-exec-git-fetch.png)

`git fetch --all` is for retrieving all source code and `git reset --hard origin/master` is for cancelling all changes in local repo and keep only source code from remote repo.

Finally, we add step to run Talend source code.

```sh
sh /home/rundeck/test/test_rundeck/sample_job01_0.1/sample_job01/sample_job01_run.sh
```

![rundeck exec job](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/rundeck-exec-sh.png)

### 3.5 Config

Set schedules, notification, and save it.

![rundeck add steps](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/rundeck-job-workflow-list.png)
*Done adding workflow steps*

![rundeck schedule](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/rundeck-job-schedule.png)
*set schedule*

![rundeck notification](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/rundeck-job-notif.png)
*set notifications*

![rundeck test run](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/rundeck-run-now.png)
*Saved. Try <kbd>Run Job Now</kbd>*

![rundeck result](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/rundeck-run-result.png)
*Got 10 names as expected*

---

## Job definitions

Additionally, we can import job definition files as the following figures. The files can be obtained by export via action button at right-handed side of the specific jobs.

![rundeck job def](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/rundeck-definition-upload.png)
*<kbd>Job Actions</kbd> > <kbd>Upload Definitions</kbd> to enter import page*

![rundeck upload job def](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/try-rundeck/rundeck-definition-file.png)
*Select a file and operations*

---

This is an obvious example and I would say I am currently taking care of this sort of processes. I just build a job and place it on Git repo then the flow will automatically do the rest.

That's all for this story. Stay tuned for the next.

Bye~
