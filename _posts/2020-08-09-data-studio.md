---
title: Do a presentation quick with Data Studio
layout: post
description: Data Studio is free and need less time to do the job done.
date: 2020-08-09 00:00:00 +0200
categories: [data, data engineering]
tags: [Google Cloud Platform, Google Data Studio, visualization]
image:
  path: ../assets/img/features/isaac-smith-6EnTPvPPL6I-unsplash.jpg
  alt: Unsplash / Isaac Smith
  caption: <a href="https://unsplash.com/photos/pen-on-paper-6EnTPvPPL6I">Unsplash / Isaac Smith</a>
---

Now we have data that already processed and it is the time to present to our decision makers. It is dashboard consisting all interesting digested data on a single plate and is attractive to our audiences.

There are many tools in the market we can pick to do the job. I know **Tableau** which is the big player at this time and I have chances to work with it. It is quite pricy. Another is **Qlik Sense** but I have only know the name. Next is **Microsoft Power BI** and here is the _free tool_ for this blog that is–

---

## Google Data Studio

![data studio logo](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/datastudio/1_vurG5TC0Hr-9i-BQ0dzhSw.png)
_Source: ![How to Use Google Analytics and Google Data Studio to Understand Your Customer Behaviors](https://medium.com/swlh/how-to-use-google-analytics-and-google-data-studio-to-understand-your-customer-behaviors-e99200454f2)_

I have been working in Google Cloud Platform and I have played around on this tool since beta version. On its beta version, I was comfortable to deal with Tableau due to more functions and beautiful UI. Until last year I have migrate my works to this Data Studio as it has enough functions for the tasks.

Even though Data Studio has less features compared with Tableau, it is free and need less time to do the job done.

Let’s do this.

---

## 1. Only Gmail

As it is the google, we need only gmail to sign-in.

---

## 2. Enter the website

Here is the entrance, <https://datastudio.google.com/overview>. Click "USE IT FOR FREE" then login with our gmail.

---

## 3. The first dashboard

After login, we will meet this page. All of our dashboards will be listed here.

![data studio first page](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/datastudio/Screen-Shot-2020-08-02-at-19.06.07.png)

Data Studio operates the dashboards as 2 parts.

1. **Reports**  
  A plate or canvas to put charts, images, and texts.
1. **Data sources**  
  A behind-the-scene data to be calculated and aggregated in the reports

Now we just click "Create" button at the top-left and select “Report”. We have to accept the “Terms and Conditions” at the first use.

---

## 4. Prepare the Data source

![add data](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/datastudio/Screen-Shot-2020-08-02-at-19.23.06.png)

Data Studio can connect to either Google products such as Google Sheets, Google BigQuery, Google Analytics or third-parties. This time we go with Google Sheets.

It is the sample data in the sheet.

![data sheets](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/datastudio/Screen-Shot-2020-08-02-at-19.35.23.png)

Select the data source then authorize the access. It will list all sheets so we just select the sheet we want here.

![confirmed add](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/datastudio/Screen-Shot-2020-08-02-at-19.38.36.png)

Look at the "Data credentials: Owner" at the top-right corner. It means the report will use the owner’s access to run. My friends can run this report even they have no access to the sheets.

We can click on it to change to "Viewer" to tell the report to use viewer’s access to run.

Click "Add" and confirm to “Add to report”.

---

## 5. Prepare the report

Here is the first view when we "Add to report".

![report ui](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/datastudio/Screen-Shot-2020-08-02-at-19.46.35.png)

1. **pages**  
  Add more pages here.
1. **charts**  
  Add more charts here.
1. **filters**  
  Add a filter box here.
1. **others**  
  Add more figures, texts, lines, images, or links here.
1. **add data source**  
  Add more data source into this report here.
1. **theme settings**  
  Change the report theme here. We can change it to dark theme or Sepia as we desire.
1. **chart types**  
  Change chart types to a selected chart here.
1. **data settings**  
  Change data representation for a selected chart here.
    - Date range dimension  
      select a date field as a reference to the chart.
    - Dimension  
      select "Dimension" that is the data categories. For example, we are going to create a chart of salary per team, the “Dimension” should be the teams.
    - Metric  
      select "Metric" that is the data measurements. It can be salary for the example above.
    - Sort  
      select a fields to sort in the chart
    - Filter  
      define conditions to update the chart. For example, show the chart with only IT department information.
    - Interaction  
        - Apply Filter – tick to apply the selected values of this chart to update all other charts which using the same data source.
        - Enable sorting – tick to allow user to sort the data in the chart.
1. **chart style**  
  We can decorate charts here.

---

## A sample dashboard is here

### 1. Pie chart to represent a number of each department’s members

- pick "Pie chart".
- pick "Dimension" to be “department”.
- pick "Metric" to be “id” with CTD (Count Distinct) in order to count unique member’s id.
- pick Interaction: Apply filter to update all charts when click a value of "department".

![pie chart](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/datastudio/Screen-Shot-2020-08-08-at-21.29.53.png)

### 2. Table to show a list of members and salaries

- pick "Table"
- pick "Dimension" to be “id”, “name”, “department”
- pick "Metric" to be “salary” as a sum
- pick "Show summary row"

![table](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/datastudio/Screen-Shot-2020-08-08-at-21.42.16.png)

### 3. Add make-up

- update "Theme" to dark (Edge)
- update "Chart style" for their colors and move the Legend (Category labels) on top of the Pie chart
- add "Text box" on top of the charts

![decorate](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/datastudio/Screen-Shot-2020-08-08-at-21.58.57.png)

---

Honestly, this just use up to 10 minutes to build a simple dashboard.

You can try yourself and have a good time.

See you next blog.

Bye~
