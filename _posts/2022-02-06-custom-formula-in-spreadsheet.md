---
title: Conditional formatting with custom formula in spreadsheet
layout: post
author: bluebirz
description: We can use conditional formatting in the spreadsheet to highlight some cells stand out and hook the viewers.
date: 2022-02-06
categories: [tips & tricks]
tags: [spreadsheet]
comment: true
image:
  path: https://images.unsplash.com/photo-1562259949-e8e7689d7828?q=80&w=2031&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1562259949-e8e7689d7828?q=10&w=2031&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Theme Photos
  caption: <a href="https://unsplash.com/photos/blue-paint-brush-Cl-OpYWFFm0">Unsplash / Theme Photos</a>
---

We can use conditional formatting in the spreadsheet to highlight some cells stand out and hook the viewers. Generally we can go to submenu <kbd>conditional formatting</kbd> under menu <kbd>format</kbd> to enable it.

Additionally, we can apply a formula to format the way we desire. This time we want to color the whole rows based on our formula.

---

## dollar sign for cells

First of all, recall how to use dollar sign in the formula. `$` is used for **fixing** the line of rows if it's put before the number of the reference or of columns I'd put before the letter.

See the example below.

![dollar sign](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/condition_format_sheet/dollar_sign.png)

Look at the orange cells. We **fix** the column `A` means only the rows will dynamically run. It means we have to put `$` at the column `A`.

In the same way. The blues-green cells **fix** the row `8` and the columns will do so. It must be `$` at that row.

In case we **fix** both, the output will be fixed at only one cell like the purple one. Therefore, `$` must be at both.

---

## Conditional formatting for a line

Now we go to conditional formatting with our custom formula. See below.

### Row-based formatting

![row-based](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/condition_format_sheet/highlight_rows.png)

Let's say we're gonna highlight IT employees in green.

In order to do so we can create a simple formula which is `=$C2="IT"`, right? But why I put `=$C1="IT"`? It's because the selected range is from row number 1, `A1:D31`, which means we have to adjust the starting row to 1 not 2 otherwise the color will be shifted.

In case you select the range to starting from row 2, like `A2:D31`, the formula must be `=$C2="IT"` to highlight it correctly.

### Columns-based formatting

![column-based](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/condition_format_sheet/highlight_col.png)

Similar to the above, we can paint whole columns with the custom formula. Make sure that we put the correct column letter into the formula. It must be the first one of the selected range.

Hope this helps your works to be done at ease.
