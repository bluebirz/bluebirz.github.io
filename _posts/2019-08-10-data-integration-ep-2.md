---
title: Data Integration (EP 2) - Take it out
layout: post
author: bluebirz
description: Let's say, we need to sum up the data in 10 files into one. How can we do?
date: 2019-08-10
categories: [data, data engineering]
tags: [ETL, ELT, Talend]
series:
  key: data-integration
  index: 2
comment: true
image: 
  path: https://images.unsplash.com/photo-1585413912691-77d3a4469e40?q=80&w=1073&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1585413912691-77d3a4469e40?q=10&w=1073&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Fabio Sasso
  caption: <a href="https://unsplash.com/photos/green-and-white-metal-pipe-lw11Pfusquw">Unsplash / Fabio Sasso</a>
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

Hello myself and around the world!!

As we talked in the last episode, here now we go build a simple workflow to integrate data on Talend.

Let's say, we need to sum up the data in 10 files into one. How can we do?

---

## Talend's interface

![talend workspace parts](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/Screen-Shot-2562-07-24-at-23.19.44_update01.png)

Left panel is called **Repository**. It is a bank of all our jobs and their compositions e.g. custom source code and metadata.

And the right one is **Palette** which displays a list of available components

Below one is **Property**:

- Property – Job for job description: creation date and version
- Property – Context or job variables
- Property – Component displays settings and configurations depend on selected component
- Property – Run for manually run the program

---

## Let's do the exercise

![talend exercise](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/bbznet-talend01.png)

There are 2 boxes of the operations. It means we need at least 2 components that are for reading 10 files and for writing 1 file.

![talend add components](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/Screen-Shot-2562-07-29-at-18.15.13.png)

Those are `tFileInputDelimited` for reading one CSV file and `tFileOutputDelimited` for writing one CSV file.

![talend add row](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/Screen-Shot-2562-07-29-at-18.18.44.png)

Next, we connected both by Right-click and select <kbd>Row</kbd> > <kbd>Main</kbd>. therefore, a row from `tFileInputDelimited` will be a row in `tFileOutputDelimited`.

Right now we have a design for a single file. Then we check if it is needed to transform data and luckily no.

Next, we have to define the schema. For example, the file contain 2 columns; first name and last name.

![talend schema](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/Screen-Shot-2562-07-29-at-18.29.13.png)

Click <kbd>...</kbd> and a schema box will be appeared.

- `first_name` as String (text)
- `last_name` also as String

Don't forget to set the exact schema on both `tFileInputDelimited` and `tFileOutputDelimited` (we can click <kbd>Sync Columns</kbd> to immediately copy schema.)

`tFileInputDelimited` supports only a single file so we need another component that is `tFileList` for retrieving a list of files in a specific folder.

![talend row linked](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/Screen-Shot-2562-08-04-at-21.17.10.png)

On `tFileList`, we fill the folder path that contains those 10 files in the "Directory" box. The figure below is my 10 files prepared in the place.

![prepare files](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/Screen-Shot-2562-08-08-at-20.10.00.png)

After that, we connect `tFileList` and `tFileInputDelimited` with <kbd>Row</kbd> > <kbd>Iterate</kbd> for read each file in the folder.

![talend row iterate](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/Screen-Shot-2562-08-08-at-20.11.21.png)

`tFileList` will list all files that meet our conditions and expose as the variable `CURRENT_FILEPATH` so we will read them one by one on `tFileInputDelimited`.

One thing, CSV files use comma as a separator by default. Don't forget to check it.

![talend iterate filename](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/Screen-Shot-2562-08-08-at-20.25.42.png)

On `tFileOutputDelimited`, we want a destination file store all data of 10 source file so check "Append" to allow program add data at the end. Checking "Include Header" when we need headers.

![talend check append](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/Screen-Shot-2562-08-09-at-00.35.38.png)

Putting destination filename at our desire and finally we go run the program as below.

![talend test run](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/Screen-Shot-2562-08-09-at-00.37.28.png)

And here is the result.

![file outputs](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/data_integration_eps/Screen-Shot-2562-08-09-at-00.39.40.png)

See, the program works properly. Next time we will find the way how to schedule the program at a time of clock we want.

---

See you again
