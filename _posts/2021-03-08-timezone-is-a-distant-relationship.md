---
title: Time zone is a distant relationship
layout: post
description: We can freely store date, time, and timestamp data but we need to aware its timezone.
date: 2021-03-08 00:00:00 +0200
categories: [programming, tools]
tags: [timezone, Python, Shell script]
image:
  path: ../assets/img/features/unsplash/christine-roy-ir5MHI6rPg0-unsplash.jpg
  alt: Unsplash / Christine Roy
  caption: <a href="https://unsplash.com/photos/us-dollar-banknote-with-map-ir5MHI6rPg0">Unsplash / Christine Roy</a>
---

Time is one of big problems for us programmers.

Not to mention about our work-life balance or something along those lines even it's true. This blog will describe how can we manage date and time data in our databases e.g. flight tables, user transactions, etc.

---

## Programmatic problems about the time

We can freely store date, time, and timestamp data but we need to aware its **timezone**. It can affect our dashboards and other dependent tasks if we overlook this.

Another is **formatting**. Some database brands support date and time in different format to others. We also need to check this but it will be later blog.

---

## Coordinated Universal Time

Coordinated Universal Time or **UTC** is a time standard. This is defined at 0° latitude.

Introducing **GMT** stands for **Greenwich Mean Time**. This is a timezone. Greenwich is a city in London England and it locates in latitude 0°. Therefore, GMT has same value as UTC and we also call it UTC + 0.

Now I'm in Thailand and the timezone is **ICT** which stands for **Indochina Time**. It is UTC + 7 means it is after UTC by 7 hours.

Not only ICT timezone that is UTC + 7 but there still is **CXT** or **Christmas Island Time** of a place around Australia.

---

## Epoch time

We now are talking about Epoch time. This is a long number indicating seconds since the new year of 1970 in UTC time (1970-01-01 00:00:00 UTC). It's also known as "Unix time", "Unix epoch", "Unix timestamp", and "POSIX time".

Epoch time refers seconds yet many system can support it in milliseconds, microseconds, or even nanoseconds. Normally 3600 is 1 hour after reference time or 1970-01-01 01:00:00 UTC.

> Epoch time always in GMT timezone or UTC time.
{: .prompt-warning}

If we have to deal with Epoch time, an interesting tool is [Epoch Converter – Unix Timestamp Converter](https://www.epochconverter.com/). This website helps us convert the Epoch time into our local timezone as well.

---

## A time to code

We are able to work with timezones using programs like these.

### Bash script

```sh
# generate epoch time of current time
date +%s
# convert epoch time to UTC date time
date -d @1609459200
# convert epoch time to UTC date time in format YYYY-mm-dd HH:MM:SS 
date -d @1609459200 +"%Y-%m-%d %H:%M:%S"
```

![bash date](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/timezone/Screen-Shot-2021-03-07-at-3.52.42-PM.png)
*Result of the Bash commands*

Running this command below to convert time in different timezones. The value of timezone can be found in the path `/usr/share/zoneinfo`.

```sh
TZ=":timezone" date
```

![bash tz](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/timezone/Screen-Shot-2021-03-07-at-4.54.04-PM.png)
*List of available timezone in Bash*

### Python

The library `datetime` can do this job.

```py
from datetime import datetime

# print current timestamp
print(datetime.now())

# print epoch time of current timestamp
print(datetime.now().timestamp())

# convert epoch time to LOCAL date time
print(datetime.fromtimestamp(1609459200))

# convert epoch time to LOCAL date time in format YYYY-mm-dd HH:MM:SS 
datetime.fromtimestamp(1609459200).strftime("%Y-%m-%d %H:%M:%S")
```

![python date](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/timezone/Screen-Shot-2021-03-07-at-5.04.37-PM.png)
*Result of the Python script*

When it comes to convert timezones, the library `pytz` is great at it.

```py
import pytz
from datetime import datetime

# convert current time to specific timezone: Asia/Bangkok
target_timezone = "Asia/Bangkok"
datetime.now().astimezone(pytz.timezone(target_timezone))

# convert current time to specific timezone: Australia/Melbourne
target_timezone = "Australia/Melbourne"
datetime.now().astimezone(pytz.timezone(target_timezone))

# convert time across timezones
source_timezone = "Asia/Bangkok"
target_timezone = "Australia/Melbourne"
quest_datetime = datetime(2021, 3, 1, 0, 0, 0)

pytz.timezone(source_timezone) \
    .localize(quest_datetime) \
    .astimezone(pytz.timezone(target_timezone))
```

![python tz](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/timezone/Screen-Shot-2021-03-07-at-8.01.50-PM.png)
*Result of `pytz`*

---

Hope this is useful for your works.

---

## References

- [The Difference Between GMT and UTC](https://www.timeanddate.com/time/gmt-utc-time.html)
- [Time Zone Abbreviations – Worldwide List](https://www.timeanddate.com/time/zones/)
- [Epoch & Unix Timestamp Conversion Tools](https://www.epochconverter.com/)
- [How can I have `date` output the time from a different time zone?](https://unix.stackexchange.com/questions/48101/how-can-i-have-date-output-the-time-from-a-different-time-zone)
