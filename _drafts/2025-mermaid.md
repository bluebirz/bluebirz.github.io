---
title: "Mermaid draws diagrams"
layout: post
author: bluebirz
description:
# date: 
categories: []
tags: []
mermaid: true
comment: true
image:
  path: https://images.unsplash.com/photo-1532619187608-e5375cab36aa?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1532619187608-e5375cab36aa?q=10&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D 
  alt: Unsplash / Kaleidico
  caption: <a href="https://unsplash.com/photos/man-drawing-on-dry-erase-board-7lryofJ0H9s">Unsplash / Kaleidico</a>
media_subpath: ../../assets/img/features/bluebirz/
---

When it comes to documentation, my goal is to explain the ideas and design into something easiest way possible to comprehend. One answer is diagrams because one picture says more than thousand words.

---

## Introduce Mermaid

In case you don't know Mermaid before, Mermaid is a script in Markdown to render diagrams and flowcharts. We can write Mermaid diagram in Markdown files and Github supports it so we can include our diagrams in README page to increase readability.

Here is Mermaid's official website.

{% include bbz_custom/link_preview.html url="<https://mermaid.js.org/>" %}

In order to write and preview the diagrams, we can start writing in this site.

{% include bbz_custom/link_preview.html url="<https://mermaid.live/edit>" %}

Or install Mermaid preview plugins in your favorite IDEs, such as:

- VSCode: [Mermaid Chart by mermaidchart.com](https://marketplace.visualstudio.com/items?itemName=MermaidChart.vscode-mermaid-chart)
- VSCode: [Markdown Preview Mermaid Support by Matt Bierner](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-mermaid)
- Neovim: [markdown-preview.nvim by iamcco](https://github.com/iamcco/markdown-preview.nvim)

---

## Syntax of Mermaid

Mermaid supports many diagram types. Each type has its own pattern but we can start from this in a Markdown file.

````md
```mermaid
---
title: some title
config: ...
---
<diagram type>
  <diagram content>
```
````

Let's take a look at some sample diagrams.

### Flowchart

A very basic one.

### Sequence diagram

### Entity Relationship Diagram

### State diagram

### Gantt chart

### Mindmap

---

### h3

{% include bbz_custom/link_preview.html url="<https://github.com/bluebirz/diagram-playground/tree/main/Mermaid/markdown>" %}

---

#### h4
