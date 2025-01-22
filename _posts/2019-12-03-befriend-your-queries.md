---
title: How to befriend your queries
layout: post
description: Here are my suggestions if we need to write SQL scripts.
date: 2019-12-03 00:00:00 +0200
categories: [programming, SQL]
tags: [queries, optimization, best practices]
image:
  path: ../assets/img/features/caspar-camille-rubin-fPkvU7RDmCo-unsplash.jpg
  alt: Unsplash / Caspar Camille Rubin
  caption: <a href="https://unsplash.com/photos/macbook-pro-with-images-of-computer-language-codes-fPkvU7RDmCo">Unsplash / Caspar Camille Rubin</a>
---

{% include bbz_custom/styling-columns.html %}
{% include bbz_custom/tabs.html %}

Hi all guys.

This is a blog for telling about my SQL writing. I know you who are coders may well know this syntax:

```sql
SELECT [something]
FROM [somewhere]
WHERE [some conditions]
GROUP BY [some points]
ORDER BY [some points]
```

It's pretty ok when you try to query something with some straightforward conditions. But not for some situations.

For real world problems, we have to face complicated questions and here are my suggestions if we need to write SQL scripts.

---

## 1. do less often for `SELECT *`

"I want everything inside this table" and hit enter for `SELECT *`.

I would say It's ok to do that but just once is enough to browse our data. To select all columns takes unnecessary usage to database server's memory and it also prolongs your waiting time until you meet the results.

---

## 2. When do we JOIN?

Let me recall the basic.

1. `a INNER JOIN b ON (a.id = b.id)`  
  compare id of 'a' and 'b'. If **both are matched**, join those rows together.
1. `a LEFT JOIN b ON (a.id = b.id)`  
  compare id of 'a' and 'b'. If **both are matched**, join those rows.  
  If there is **only left side**, 'a', apply the right side as null.
1. `a RIGHT JOIN b ON (a.id = b.id)`  
  compare id of 'a' and 'b'. If **both are matched**, join those rows.  
  If there is **only right side**, 'b', apply the left side as null.
1. `a FULL JOIN b ON (a.id = b.id)`  
  compare id of 'a' and 'b'. If **both are matched**, join those rows.  
  If there is **only one side**, 'a' or 'b', apply the rest as null.

For example, I created 2 tables. `students` stores id and name of students and `sport_members` stores sport names and student's ids who join it.

<div class="row">
    <div class="col-2">
        <img src="https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/befriend-sql/Screen-Shot-2019-12-01-at-18.55.13.png" alt="table students" loading="lazy">
        <em>table <code>students</code></em>
    </div>
 <div class="col-2">
        <img src="https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/befriend-sql/Screen-Shot-2019-12-01-at-18.55.30.png" alt="table sport_members" loading="lazy">
        <em>table <code>sport_members</code></em>
    </div>
</div>

Here are sample `JOIN` statements

{% tabs join %}

{% tab join INNER JOIN %}

```sql
select * 
from students INNER JOIN sport_members 
  on (students.id = sport_members.student_id);
```

![inner join](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/befriend-sql/Screen-Shot-2019-12-01-at-18.55.44.png){:style="max-width:50%;margin:auto;"}

{% endtab %}

{% tab join LEFT JOIN %}

```sql
select * 
from students LEFT JOIN sport_members 
  on (students.id = sport_members.student_id);
```

![left join](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/befriend-sql/Screen-Shot-2019-12-01-at-18.56.03.png){:style="max-width:50%;margin:auto;"}

{% endtab %}

{% tab join RIGHT JOIN %}

```sql
select * 
from students RIGHT JOIN sport_members 
  on (students.id = sport_members.student_id);
```

![right join](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/befriend-sql/Screen-Shot-2019-12-01-at-18.56.27.png){:style="max-width:50%;margin:auto;"}

{% endtab %}

{% tab join FULL JOIN / FULL OUTER JOIN %}

```sql
select * 
from students FULL JOIN sport_members 
  on (students.id = sport_members.student_id);
```

![full join](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/befriend-sql/Screen-Shot-2019-12-01-at-18.56.48.png){:style="max-width:50%;margin:auto;"}

{% endtab %}

{% endtabs %}

After that, when should we use which?

- `inner join` for completely matchings such as list of students who join sports.
- `left join` and `right join` for completely matchings and one-side matchings such as list of students filled with their sports, even some do not join any sport.
- `full join` for all possible matching. I can say I rarely use this. For example, a list of students matching with sports showing them all even some students do not join any sports or some sports have no student joined.

---

## 3. IN and JOIN

`IN` is an operator to apply membership condition.

```sql
SELECT name
FROM students
WHERE id IN (1,2,4,5)
```

or

```sql
SELECT name
FROM students
WHERE id IN (
    SELECT student_id
    FROM sports
    WHERE sport_id = 2
)
```

It's easier and more figuratively to write compared with `JOIN` but I suggest to use it for less members, about 10 values or fewer.

`IN` proceeds from parenthesis first (or subquery) then outside or parent query. And `JOIN` proceeds logical conditions from `ON` statement. It means `JOIN` can do better job than `IN` when data is huge as `JOIN` need not to proceed that huge data in subqueries.

---

## 4. WITH, the alternative way of subquery

We can use subqueries for complex conditions. What if the conditions are too complex?

Let say, we need id and name of students plus their sports where the students are in class 6 and their sports are opened and those sports must have more than 10 members.

Here is the example of subqueries.

```sql
SELECT students.id, students.name, filter_sports.name
FROM students INNER JOIN (
  SELECT name, student_id
  FROM sport_members INNER JOIN (
    SELECT id
    FROM sport_members
    WHERE is_open = true
    GROUP BY id
    HAVING count(distinct student_id) > 10
  ) AS more_ten_members_sports ON (sport_member.id = more_ten_members_sports.id)
) AS filter_sports ON (students.id = filter_sports.student_id)
WHERE students.class = 6
```

and here is an example of `with`.

```sql
WITH more_ten_members_sports AS (
  SELECT id
  FROM sport_members
  WHERE is_open = true
  GROUP BY id
  HAVING count(distinct student_id) > 10
), filter_sports AS (
  SELECT name, student_id
  FROM sport_members INNER JOIN more_ten_members_sports
  ON (sport_member.id = more_ten_members_sports.id)
)
SELECT students.id, students.name, filter_sports.name
FROM students INNER JOIN filter_sports ON (students.id = filter_sports.student_id)
WHERE students.class = 6
```

`with` allow to created an alias table like a variable. We can proceed them anywhere as we want.

I recommend this.

---

## 5. PARTITION to optimization

Partition is like chronological ordered folders. When we want to find something, we are able to do so easily if we have ranges of time of expected data. Query with partition conditions apply a specific period of time for proceeding the data.

The partition fields must be defined for the tables in order to query with it.

Here is the example of partition query on Google BigQuery.

**Not use partition field**

![non-partition](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/befriend-sql/Screen-Shot-2019-12-01-at-21.42.39.png)

**Use partition field**

![partitioned](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/befriend-sql/Screen-Shot-2019-12-01-at-21.43.48.png)

It does apparently reduce the processed data from 15.8 KB to 3.6 KB. Nice, isn't it?

---

## 6. ORDER BY a little

From my experience, `ORDER BY` causes the incidents of insufficient memory. This is mostly found when we try to sort a huge result. I suggest to use this at the very last step to ensure the result is as small as possible before sorting it.

---

Hope you guy happy to deal with SQL.

See ya next time.

Bye~

---

## References

- <https://www.sqlshack.com/design-sql-queries-better-performance-select-exists-vs-vs-joins/>
- <https://www.ibm.com/support/knowledgecenter/en/SSZLC2_9.0.0/com.ibm.commerce.developer.doc/refs/rsdperformanceworkspaces.htm>
- <https://social.msdn.microsoft.com/Forums/sqlserver/en-US/7990e55a-4b31-47c2-8f47-f7dbfc38f621/inexists-or-inner-join-which-one-is-the-best-performance-wise?forum=transactsql>
