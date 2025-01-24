---
title: When I worked with Microsoft Excel
layout: post
description: This program can increase your productivities and let you have more leisure times.
date: 2020-07-28 00:00:00 +0200
categories: [tips & tricks]
tags: [Microsoft Excel, spreadsheet]
image:
  path: https://images.unsplash.com/photo-1529078155058-5d716f45d604?q=80&w=2069&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Mika Baumeister
  caption: <a href="https://unsplash.com/photos/white-printing-paper-with-numbers-Wpnoqo2plFA">Unsplash / Mika Baumeister</a>
---

{% include bbz_custom/styling-columns.html  %}

I was a data analyst.

The differences between data analysts and data engineers are, data analysts work with customers in business side and require short-time solutions while data engineers run the processes under technical regulations and policies that need time for implementations.

As the working style of data analyst, one of their tools is…

---

## Microsoft Excel

Please don't be afraid. This program can increase your productivities and let you have more leisure times. Promise.

---

## 1. I need a text, not in other format

Sometimes we want a simple text but the excellent Excel transform what we typed to other format. We just add <kbd>'</kbd> (single quote) at the first place and it will be treated as text.

<div class="row">
    <div class="col-2">
      <img src="https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/Screen-Shot-2020-07-27-at-18.03.09.png" alt="I want this" loading="lazy">
      <em>I want this.</em>
    </div>
 <div class="col-2">
      <img src="https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/Screen-Shot-2020-07-27-at-18.03.17.png" alt="Excel did this" loading="lazy">
      <em>but Excel did this.</em>
    </div>
</div>
<div class="row">
    <div class="col-2">
      <img src="https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/Screen-Shot-2020-07-27-at-18.03.30.png" alt="add prefix" loading="lazy">
      <em>so add a prefix <kbd>'</kbd></em>
    </div>
 <div class="col-2">
      <img src="https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/Screen-Shot-2020-07-27-at-18.03.38.png" alt="as expected" loading="lazy">
      <em>It works as expected.</em>
    </div>
</div>

---

## 2. Errors checking

There are 3 main functions to notice errors.

```
=ISERR(cell)
=ISERROR(cell)
=ISNA(cell)
```

`=ISNA()` identifies only value errors as "NA" stands for "Not Available". This means the value is not available. `=ISERROR()` catches for all errors and `=ISERR()` catches all excepts "NA".

Here is the example. column B is the result of formulas in A and D is the result of C.

![error checking](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/Screen-Shot-2020-07-26-at-21.16.15.png)

- `=8/0` gives `#DIV/0!` and this is operational error. Therefore, `=ISNA()` doesn't work.
- `=NA()` gives `#N/A` and yes `=ISNA()` just works while `=ISERR()` doesn't.
- `=ASIN(2)` gives `#NUM!` as the value must be -1 to 1. `=ISNA()` doesn't work also.
- `=TEX()` gives `#NAME?` because this function name isn't exist but there is `=TEXT()` and no, we can't check this with `=ISNA()`.
- `=VALUE("A")` gives `#VALUE!`. This function return an integer from numeric text and we try "A" so that's an error. `=ISNA()` doesn't work in this case.

---

## 3. Error replacements

We can identify errors so we can replace the errors.

```
=IFNA(cell, value)
=IFERROR(cell, value)
```

![error replacements](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/Screen-Shot-2020-07-26-at-21.19.16.png)

When we can catch errors with `=ISERROR()` and `=ISNA()`, we can run `=IFERROR()` and `=IFNA()` respectively to show the other responses.

There is no `=IFERR()`.

---

## 4. Value comparisons

There are 2 formulas to compare values.

```
=cell1=cell2
=IFERROR(VALUE(cell1),cell1)=IFERROR(VALUE(cell2),cell2)
```

Here are the examples.

![compare](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/Screen-Shot-2020-07-27-at-15.17.03.png)

Ahh, notice that `=A5=B5` gives `FALSE` but why? The value of B5 is `'1` that is text not `1` which is number and that's it. That is the table showing result from `=TYPE()`.

Therefore, we combine `=VALUE()` to transform numeric text to number if any and `=IFERROR()` to catch the error if that value cannot be transformed to a number then an original value will be used, and compare with other values in the end.

---

## 5. Single click to make a chart

![menu conditional formatting](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/Screen-Shot-2020-07-27-at-00.27.46.png)

Go to tab: Home and click "Conditional Formatting", there are many options.

![conditional formatting](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/Screen-Shot-2020-07-26-at-21.41.12.png)

- **Data bar**  
  Add bar charts. Highest value will display the longest bar.
- **Color scale**  
  Fill the cell background color. Depends on the color set we choose.
- **Icon set**  
  Add icons to the cells
- **Highlight cell rules**  
  Custom rules to apply colors to cells

---

## 6. Remove duplicated values

Here is the way we eliminate the duplicated data.

![remove duplicated](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/Screen-Shot-2020-07-27-at-14.53.45.png)

Go to tab: Data and click "Remove Duplicates". There are 2 options.

## 6.1 Expanded Selection

Select this if we want to remove duplicates for multiple columns in a single row. For the example below, there is only 1 duplicate from row 1 and 4 that is (a, 1).

<div class="row">
    <div class="col-2">
      <img src="https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/Screen-Shot-2020-07-27-at-16.12.32.png" alt="Expanded selection" loading="lazy">
      <em>Select "Expanded Selection"</em>  
    </div>
 <div class="col-2">
      <img src="https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/Screen-Shot-2020-07-27-at-16.12.40.png" alt="Expanded selection done" loading="lazy">
      <em>Expanded selection duplicates removed</em>
    </div>
</div>

## 6.2 Original selection

Select this if we want to remove duplicates in only the selections.

<div class="row">
    <div class="col-2">
      <img src="https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/Screen-Shot-2020-07-27-at-16.12.51.png" alt="Original selection" loading="lazy">
      <em>Select "Original Selection"</em>
    </div>
<div class="col-2">
      <img src="https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/Screen-Shot-2020-07-27-at-16.12.58.png" alt="Original selection" loading="lazy">
      <em>Original selection duplicates done</em>
    </div>
</div>

---

## 7. Lookup

Here are 2 formulas the I used very often there.

```
=VLOOKUP(find, table, get, approx_match)
=INDEX(get, MATCH(find, table, match_type), column_no)
```

![lookup](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/Screen-Shot-2020-07-27-at-16.03.44.png)

First, `=VLOOKUP()`. It is valid when the search column of "TABLE" is the first column. As the figure above, we need to find salary from their names. Therefore, we define "TABLE" to cover column of name through salary. And give "APPROX_MATCH" as FALSE to do exact match, otherwise it will run as approximate match.

![vlookup flow](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/vlookup.png)

Second, combination of `=INDEX()` and `=MATCH()`. This works when we cannot align the search column as the first column of "TABLE". `=MATCH()` returns the index of "FIND" that it found in "TABLE" then `=INDEX()` will return the value of "GET" at the index.

Gives "MATCH_TYPE" as 0 to do exact match and "COLUMN_NO" also 0 as the first column of "GET" .

![index match](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/index_match.png)

---

## 8. Count and Sum

The basic ones and we can use them in various situations.

![count sum](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/Screen-Shot-2020-07-27-at-17.23.40.png)

- `=SUM()`  
  Just a summation
- `=SUMIF()`  
  Summation with a single condition. From the example, find sum of Salary (D2:D11) where Department (C2:C11) is "IT"
- `=SUMIFS()`  
  Summation with multiple conditions. From the example, find sum of Salary (D2:D11) where Department (C2:C11) is "IT" and age (B2:B11) is greater than "30"
- `=COUNT()`  
  Just count a number of numbers and booleans
- `=COUNTA()`  
  Count a number of cells containing value.
- `=COUNTBLANK()`  
  Count a number of cells containing nothing.
- `=COUNTIF()`  
  Count a number of cells with a single condition. From the example, count a number of cells where Checked is "Yes"
- `=COUNTIFS()`  
  Count a number of cells with multiple conditions. From the example, count a number of cells where Checked is "Yes" and Department is "Sales"

---

## 9. Dropdown

Let's say we want to force input by a given value set. Here is the solution.

First, prepare the value sets then select cells that will be the input. Go to tab: Data and click "Data Validation".

![tab data](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/Screen-Shot-2020-07-27-at-17.36.43.png)

A dialog box will be appeared. Select "Allow" as "List" and the "Source" will be a range we can drag a mouse to select.
u
![data validation](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/Screen-Shot-2020-07-27-at-17.37.26.png)

Now we've done. There is going to be a dropdown icon after the input cells. The error will be shown when the input value isn't matched to the given list.

<div class="row">
    <div class="col-2">
      <img src="https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/Screen-Shot-2020-07-27-at-17.38.30.png" alt="Select a value" loading="lazy">
      <em>Select a value</em>
    </div>
 <div class="col-2">
      <img src="https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/Screen-Shot-2020-07-27-at-17.38.41.png" alt="Error occurred" loading="lazy">
      <em>Error when input isn't valid</em>
    </div>
</div>

---

## 10. Freeze panes

Freezing panes is a good way to view large data with headers.

Go to tab: View and click "Freeze Panes". There are many options and this time we choose "Freeze Panes". We have to select a cell before. The figure below has B6 as the point.

![menu Freeze](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/Screen-Shot-2020-07-27-at-18.21.09.png)

As a result, we have frozen the pane above and left to B6. We can scroll to other points and the header rows and columns still be there.

![pane freeze](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/Screen-Shot-2020-07-27-at-18.21.34.png)

---

## 11. Too many formulas, too long the files to open

Too Soften that I have to deal with so many functions and calculations, and found on the next time that the files are too long to open and to be prompted to work with. The reason is, the program has to process ALL calculations again once it is started.

I recommend to transform the stable result from formulas to solid values when we ensure the values have never updated. This operation is just copy then paste them as values.

<div class="row">
    <div class="col-2">
      <img src="https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/Screen-Shot-2020-07-27-at-18.30.10.png" alt="paste options" loading="lazy" style="max-width:75%;margin:auto;">
      <em>Paste options</em>
    </div>
 <div class="col-2">
      <img src="https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/Screen-Shot-2020-07-27-at-18.31.11.png" alt="Paste values" loading="lazy" style="max-width:75%;margin:auto;">
      <em>Paste Values</em>
    </div>
</div>

---

## 12. Pivot table

Pivot table is one of the best features we can find in spreadsheet programs. We can design how the data will be represented in the beautiful views. Go to tab: Insert and select "PivotTable".

![menu insert](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/Screen-Shot-2020-07-27-at-18.44.36.png){:style="max-width:50%;margin:auto;"}

Below is the sample Pivot table. Within ten clicks and we got the table to find salary of each members in a selected department. Let's try yourself.

![pivot](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/excel-tips/Screen-Shot-2020-07-27-at-18.45.09.png)

---

As I aforementioned, try this and you may improve your time with this.

---

## References

- [How to Use Excel Like a Pro](https://blog.hubspot.com/marketing/how-to-use-excel-tips)
