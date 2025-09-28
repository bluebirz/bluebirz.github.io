---
title:
layout: post
author: bluebirz
description:
# date:
categories: []
tags: []
pin: true
math: true 
mermaid: true
comment: true
# series:
#   key: asd
#   index: 1
image:
  # path: assets/img/features/
  path: https://images.unsplash.com/photo-1695313129813-6a10cdcbb2f4?q=80&w=1631&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1695313129813-6a10cdcbb2f4?q=10&w=490&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Natalia Gasiorowska
  caption: <a href="https://unsplash.com/photos/a-pencil-drawing-of-a-ball-and-a-pencil-rOVY9FD4G_Q">Unsplash / Natalia Gasiorowska</a>
---

{% include bbz_custom/expand_series.html key=page.series.key index=page.series.index %}

{% include bbz_custom/tabs.html %}

---

{% include bbz_custom/link_preview.html post='2021-02-27-regex-is-sexy' %}

{% include bbz_custom/link_preview.html url='<https://www.duckduckgo.com>' %}

{% include bbz_custom/link_preview.html url='<https://developer.hashicorp.com/terraform/language/values/variables>' %}

{% include bbz_custom/link_preview.html url='<https://marketplace.visualstudio.com/items?itemName=njpwerner.autodocstring>' %}

{% include bbz_custom/link_preview.html url='<https://developer.hashicorp.com/terraform/language/settings/backends/gcs>' %}

{% include bbz_custom/link_preview.html url='<https://ajv.js.org/>' %}

---

{% tabs demo %}

{% tab demo code block %}

```python
inmport this
```

{% endtab %}

{% tab demo text %}

Quisque egestas convallis ipsum, ut sollicitudin risus tincidunt a. Maecenas interdum malesuada egestas. Duis consectetur porta risus, sit amet vulputate urna facilisis ac. Phasellus semper dui non purus ultrices sodales. Aliquam ante lorem, ornare a feugiat ac, finibus nec mauris. Vivamus ut tristique nisi. Sed vel leo vulputate, efficitur risus non, posuere mi. Nullam tincidunt bibendum rutrum. Proin commodo ornare sapien. Vivamus interdum diam sed sapien blandit, sit amet aliquam risus mattis. Nullam arcu turpis, mollis quis laoreet at, placerat id nibh. Suspendisse venenatis eros eros.

{% endtab %}

{% tab demo image %}

![image](../assets/img/features/bluebirz/IMG_6642-are.jpg){:style="max-width:75%;margin:auto;" .apply-border}

{% endtab %}

{% tab demo list %}

- lorem ipsum
- lorem ipsum
  - lorem ipsum
  - lorem ipsum
- lorem ipsum

{% endtab %}

{% endtabs %}

---

## Headings

<!-- markdownlint-capture -->
<!-- markdownlint-disable -->
# H1 — heading
{: .mt-4 .mb-0 }

## H2 — heading
{: data-toc-skip='' .mt-4 .mb-0 }

### H3 — heading
{: data-toc-skip='' .mt-4 .mb-0 }

#### H4 — heading
{: data-toc-skip='' .mt-4 }
<!-- markdownlint-restore -->

## Paragraph

Quisque egestas convallis ipsum, ut sollicitudin risus tincidunt a. Maecenas interdum malesuada egestas. Duis consectetur porta risus, sit amet vulputate urna facilisis ac. Phasellus semper dui non purus ultrices sodales. Aliquam ante lorem, ornare a feugiat ac, finibus nec mauris. Vivamus ut tristique nisi. Sed vel leo vulputate, efficitur risus non, posuere mi. Nullam tincidunt bibendum rutrum. Proin commodo ornare sapien. Vivamus interdum diam sed sapien blandit, sit amet aliquam risus mattis. Nullam arcu turpis, mollis quis laoreet at, placerat id nibh. Suspendisse venenatis eros eros.

## Lists

### Ordered list

1. Firstly
2. Secondly
3. Thirdly

### Unordered list

- Chapter
  - Section
    - Paragraph

### ToDo list

- [ ] Job
  - [x] Step 1
  - [x] Step 2
  - [ ] Step 3

### Description list

Sun
: the star around which the earth orbits

Moon
: the natural satellite of the earth, visible by reflected light from the sun

## Block Quote

> This line shows the _block quote_.

## Prompts

<!-- markdownlint-capture -->
<!-- markdownlint-disable -->
> An example showing the `tip` type prompt.
{: .prompt-tip }

> An example showing the `info` type prompt.
{: .prompt-info }

> An example showing the `warning` type prompt.
{: .prompt-warning }

> An example showing the `danger` type prompt.
{: .prompt-danger }
<!-- markdownlint-restore -->

## Tables

| Company                      | Contact          | Country |
| :--------------------------- | :--------------- | ------: |
| Alfreds Futterkiste          | Maria Anders     | Germany |
| Island Trading               | Helen Bennett    |      UK |
| Magazzini Alimentari Riuniti | Giovanni Rovelli |   Italy |

## Links

<http://127.0.0.1:4000>

## Footnote

Click the hook will locate the footnote[^footnote], and here is another footnote[^fn-nth-2].

## Inline code

This is an example of `Inline Code`.

## Filepath

Here is the `/path/to/the/file.extend`{: .filepath}.

## Code blocks

### Common

```text
This is a common code snippet, without syntax highlight and line number.
```

### Specific Language

```bash
if [ $? -ne 0 ]; then
  echo "The command was not successful.";
  #do the needful / exit
fi;
```

### Specific filename

{: file='_sass/jekyll-theme-chirpy.scss' icon='devicon-sass-original'}

```sass
@import
  "colors/light-typography",
  "colors/dark-typography";
```

{: file='test.yml'}

```yaml
a: 2
```

```py
Test = "This is a Python code block"
```

```js
const test = "This is a JavaScript code block"
```

```tf
test = "This is a Terraform code block"
```

```c#
test = "This is a C# code block"
```

```html
<p>test</p>
```

```css
.test {
  color: red;
}
```

```go
test := "This is a Go code block"
```

```rust
test := "This is a Rust code block"
```

```markdown
test 
```

```sql
select * from test;
```

```txt
test 
```

```sh
test="This is a Shell code block"
```

```yaml
test: "This is a YAML code block"
```

```json
{
  "test": "This is a JSON code block"
}
```

```
test
```

## Mathematics

<!-- BUG: refresh path cause mathjax error -->

The mathematics powered by [**MathJax**](https://www.mathjax.org/):

$$
\begin{equation}
  \sum_{n=1}^\infty 1/n^2 = \frac{\pi^2}{6}
  \label{eq:series}
\end{equation}
$$

We can reference the equation as \eqref{eq:series}.

$$
\begin{align}
D_{KL}(P^{*}(y|x_i) \vert \vert P(y|x_i; \Theta))
    &= \sum_{y} P^*(y|x_i) log \frac{P^*(y|x_i)}{P(y|x_i; \Theta)} \\
    &= \sum_{y} P^*[y|x_i](logP^*(y|x_i) - logP(y|x_i; \Theta)) \nonumber\\
    &= \sum_{y} P^*(y|x_i)logP^*(y|x_i) - \sum_{y} P^{*}(y|x_i)logP(y|x_i; \Theta)
\end{align}
$$

When $a \ne 0$, there are two solutions to $ax^2 + bx + c = 0$ and they are

When $$a \ne 0$$, there are two solutions to $$ax^2 + bx + c = 0$$ and they are

$$ x = {-b \pm \sqrt{b^2-4ac} \over 2a} $$

$$
\begin{equation}
   e^{\pi i} + 1 = 0
\end{equation}
$$

## Mermaid SVG

```mermaid
 gantt
  title  Adding GANTT diagram functionality to mermaid
  apple :a, 2017-07-20, 1w
  banana :crit, b, 2017-07-23, 1d
  cherry :active, c, after b a, 1d
```

## Images

### Default (with caption)

![image](../assets/img/features/bluebirz/IMG_6642-are.jpg){:style="max-width:75%;margin:auto;" .apply-border}
_Full screen width and center alignment_

### Left aligned

![Desktop View](../assets/img/features/bluebirz/IMG_6642-are.jpg){: width="972" height="589" .w-75 .normal}

### Float to left

![Desktop View](../assets/img/features/bluebirz/IMG_6642-are.jpg){: width="972" height="589" .w-50 .left}
Praesent maximus aliquam sapien. Sed vel neque in dolor pulvinar auctor. Maecenas pharetra, sem sit amet interdum posuere, tellus lacus eleifend magna, ac lobortis felis ipsum id sapien. Proin ornare rutrum metus, ac convallis diam volutpat sit amet. Phasellus volutpat, elit sit amet tincidunt mollis, felis mi scelerisque mauris, ut facilisis leo magna accumsan sapien. In rutrum vehicula nisl eget tempor. Nullam maximus ullamcorper libero non maximus. Integer ultricies velit id convallis varius. Praesent eu nisl eu urna finibus ultrices id nec ex. Mauris ac mattis quam. Fusce aliquam est nec sapien bibendum, vitae malesuada ligula condimentum.

### Float to right

![Desktop View](../assets/img/features/bluebirz/IMG_6642-are.jpg){: width="972" height="589" .w-50 .right}
Praesent maximus aliquam sapien. Sed vel neque in dolor pulvinar auctor. Maecenas pharetra, sem sit amet interdum posuere, tellus lacus eleifend magna, ac lobortis felis ipsum id sapien. Proin ornare rutrum metus, ac convallis diam volutpat sit amet. Phasellus volutpat, elit sit amet tincidunt mollis, felis mi scelerisque mauris, ut facilisis leo magna accumsan sapien. In rutrum vehicula nisl eget tempor. Nullam maximus ullamcorper libero non maximus. Integer ultricies velit id convallis varius. Praesent eu nisl eu urna finibus ultrices id nec ex. Mauris ac mattis quam. Fusce aliquam est nec sapien bibendum, vitae malesuada ligula condimentum.

### Dark/Light mode & Shadow

The image below will toggle dark/light mode based on theme preference, notice it has shadows.

![light mode only](../assets/img/features/bluebirz/IMG_6642-are.jpg){: .light .w-75 .shadow .rounded-10 w='1212' h='668' }
![dark mode only](../assets/img/features/bluebirz/IMG_6642-are.jpg){: .dark .w-75 .shadow .rounded-10 w='1212' h='668' }

## Video

{% include embed/youtube.html id='Balreaj8Yqs' %}

## Reverse Footnote

[^footnote]: The footnote source
[^fn-nth-2]: The 2nd footnote source
