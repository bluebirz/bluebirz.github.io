---
title: REGEX is sexy
layout: post
author: bluebirz
description: Regular Expression is a tool for processing text. It's popular in most programming languages. 
date: 2021-02-27
categories: [programming, REGEX]
tags: [REGEX, SQL, Python, Google Cloud Platform, Google BigQuery]
comment: true
image:
  path: assets/img/features/bluebirz/regex-banner.001.jpeg
  lqip: ../assets/img/features/lqip/bluebirz/regex-banner.001.webp
  alt: REGEX is sexy
  caption:
---

Regular Expression is a tool for processing text. It's popular in most programming languages. This is one of problematic works for many and yes I do think so.

However, we are learning the concepts and rules to make it familiar then we will be happy and comfortable to use it in every projects.

---

## Concept of REGEX

REGEX stands for **REG**ular **EX**pression. It is in a form of string and is built for string or text processing methods.

These are main concepts of the REGEX:

1. We need to **select** what will be in each position in a string.
1. Every character has its own **class**.
1. Define **quantifier** for number of the character series in the same class.
1. We have choices, we use **alteration**.
1. Add **anchor** for beginnings or endings of words or strings.
1. Apply **escape characters** if needed.
1. Select parts of the text with **capture groups**.

---

## Class

ASCII is the basic of characters in programming 101.

REGEX benefits this to define classes:

- Digits are `\d`. Not digits are `\D`.
- English alphabets are `\w` or word, otherwise `\W`.
- Spaces are `\s`, otherwise `\S`.
- In case of any characters, we put `.` (dot.)
- New line symbols are `\R` from "Return", otherwise `\N`.
- For other languages, it's known as unicode characters. There are `\p{language}` for example `\p{Thai}`.  
  More info, please visit [regular-expressions.info/unicode](https://www.regular-expressions.info/unicode.html).

Sometimes require a list of characters, apply `[]`.

- Select only A, B, C, or D then `[ABCD]`.
- Select anything but A, B, C, and D then `[^ABCD]`.
- Select a range such as letter 'a' to 'x' then `[a-x]`.

We can change some class with `[]`.

- `\d` can be replaced with `[0-9]`.
- `\D` can be replaced with `[^0-9]`.
- `\w` can be replaced with `[a-zA-Z]`.
- `\W` can be replaced with `[^a-zA-Z]`.

---

## Quantifier

Classes are selected, now we can define how many.

|Least|Most|Add this followed by the class|
|:-:|:-:|:-:|
|0|Any|`*`|
|1|Any|`+`|
|0|1|`?`|
|3|3|`{3}`|
|3|9|`{3,9}`|
|3|Any|`{3,}`|

For instance, a text consists of 3 digits followed by any letters at any length can be `\d{3}\w*`.

---

## Alteration

Put `|` between choices.

- `a|b` means either `a` or `b`.
- `cat|dog` means either `cat` or `dog`.

---

## Anchor

Anchor represents beginning or ending of the words or texts

- Beginning of the line would be represented by `^`.  
  `^a` is starting with `a`.
- Ending of the line is `$`.  
  `z$` means `z` is the last character of that line.
- Ending of the words can be used with `\b` from "boundary".  
  It ends the word if that position is **not a word class**.  
  For example, `x\b` will target `x.`, `x;`, `x!` but not `xa`, `xx`.
- Ending of the words **followed by any word class** can be used with `\B`.  
  For example, `x\B` will target `xa`, `xx`, `xz` but not `x.`, `x+`.

---

## Escape characters

Add backslash `\` preceding the characters.

- `*` will be `\*`.
- `.` will be `\.`.
- `$` will be `\$`

and so on.

---

## Capture group

Apply parentheses surrounding the REGEX to make a capture group then the following syntaxes will be enabled.

- Refer the capture group using `\index` as the index of that group.  
  Let's say `(a|b|c)\1` means there is a capture group selecting letter "a", "b", "c", or "d" as the 1st group, plus `\1` as the reference to that result of the 1st group. Result should be one of `aa`, `bb`, or `cc`.
- Refer the capture group using their names. We need to name the capture group before.  
  For example, `(?'x1'(a|b|c))\k'x1'` , will result as same as the above but now we're using the name x1.
- Benefit with the method for substitution and extraction.  
  For instance, substitute all digits to an "x" or extract all digit followed by letter "a" from given texts.

---

## Tools

These are my tools to check the REGEX strings before run on my jobs.

- [regex101: build, debug and test regex](https://regex101.com/)
- [RegExr: Learn, Build, & Test RegEx](https://regexr.com/)

---

## Real cases

### SQL on Google BigQuery

On Google BigQuery, it supports REGEX well as the example below.

```sql
WITH test_set AS (
  SELECT ["+66876543210", "0812345678", "9876543210987",
    "test_email@mail.go.th", "123-456@student-council.com",
    "i-have-no-life_literally@sample-server.co.th",
    "1234567890123", "9876543210987", "#iphone12mini", "#รักเธอที่สุด"
    ] AS text 
)
SELECT text, 
  regexp_contains(text, r'^0[689]\d{8}$') as is_mobile,
  regexp_contains(text, r'[\d\w\-_\.]+\@[\d\w\-_\.]+\..*') as is_email,
  regexp_contains(text, r'^\d{13}$') as is_thaiid,
  regexp_contains(text, r'#[\p{Thai}\w\d_]+') as is_hashtag
FROM test_set, unnest(text) text
```

This diagram illustrates how REGEX is translated to sample string.

![bq regex](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/regex/regex.png)
*REGEX diagrams*

This is the result of the query above. `true` here shows the `text` is which type indicated by each REGEX.

![query result](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/regex/Screen-Shot-2021-02-25-at-8.27.21-PM.png){: style="max-width:80%;margin:auto;" .apply-border}
*Result of REGEX functions in Google BigQuery*

### Python script

Second here is Python. I rather do with library [regex](https://pypi.org/project/regex/) which is more flexible than the standard library [re](https://docs.python.org/3/library/re.html). `re` doesn't support class `\p{language}` for this case.

```py
import regex
test_set = ["+66876543210", "0812345678", "9876543210987",
            "test_email@mail.go.th", "123-456@student-council.com", 
           "i-have-no-life_literally@sample-server.co.th", "1234567890123", 
            "9876543210987", "#iphone12mini", "#รักเธอที่สุด"] 

rgx_mobile = "^0[689]\d{8}$"
rgx_email = "[\d\w\-_\.]+\@[\d\w\-_\.]+\..*"
rgx_thaiid = "^\d{13}$"
rgx_hashtag = "#[\p{Thai}\w\d_]+"

for t in test_set:
    if regex.match(rgx_mobile, t) is not None:
        print(t, "is mobile")
    elif regex.match(rgx_email, t) is not None:
        print(t, "is email")
    elif regex.match(rgx_thaiid, t) is not None:
        print(t, "is thaiid")
    elif regex.match(rgx_hashtag, t) is not None:
        print(t, "is hashtag")
    else:
        print(t, "is others")
```

![python regex](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/regex/Screen-Shot-2021-02-25-at-8.34.40-PM.png){: style="max-width:80%;margin:auto;" .apply-border}
*Result of REGEX methods in Python*

---

## Be careful

As aforementioned, REGEX has solid patterns but we need to concern which REGEX engine do we use because different engines may not compatible with our REGEX strings.

Python has library `re` and `regex` while Google BigQuery functions are relied on `re2` of Golang.

For more info about REGEX engine, please read [Comparison of regular expression engines](https://en.wikipedia.org/wiki/Comparison_of_regular-expression_engines).

---

I'm quite pretty certain we the coder have times working with REGEX.
