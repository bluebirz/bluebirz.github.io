---
title: "Mermaid draws diagrams"
layout: post
author: bluebirz
description: Text to diagrams for a better documentation
date: 2025-07-06 
categories: [programming, Markdown]
tags: [Markdown, Mermaid]
mermaid: true
comment: true
image:
  path: https://images.unsplash.com/photo-1532619187608-e5375cab36aa?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1532619187608-e5375cab36aa?q=10&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D 
  alt: Unsplash / Kaleidico
  caption: <a href="https://unsplash.com/photos/man-drawing-on-dry-erase-board-7lryofJ0H9s">Unsplash / Kaleidico</a>
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
config: 
  some: config
---
<diagram type>
  <diagram content>
```
````

Let's take a look at some sample diagrams.

---

## Examples of Mermaid diagrams

### Flowchart

A very basic one. I usually have it when it comes to quick presentation during meetings.

For example:

````md
```mermaid
---
title: "Form filling workflow"
---
flowchart TD
  user -- "fill form" --> front["front page"] -- "send data" --> api --> database
```
````

It will be rendered as:

```mermaid
---
title: "Form filling workflow"
---
flowchart TD
  user -- "fill form" --> front["front page"] -- "send data" --> api --> database
```

<br/>

### Sequence diagram

I often use it to describe how the services and people in each party communicate with each other.

For example:

````md
```mermaid
---
title: "Form filling workflow"
---
sequenceDiagram
  autonumber
  actor User
  participant Frontend
  participant API
  participant Database

  User->>Frontend: Fill form
  Frontend->>API: Send data
  API->>Database: Save data
  Database-->>API: Acknowledge
  API-->>Frontend: Success response
  Frontend-->>User: Show success message
```
````

```mermaid
--- 
title: "Form filling workflow"
---
sequenceDiagram
  autonumber
  actor User
  participant Frontend
  participant API
  participant Database

  User->>Frontend: Fill form
  Frontend->>API: Send data
  API->>Database: Save data
  Database-->>API: Acknowledge
  API-->>Frontend: Success response
  Frontend-->>User: Show success message
```

<br/>

### Entity Relationship Diagram

A database relation diagram.

For example:

````md
```mermaid
---
title: form filling er-diagram
---
erDiagram
  USER |o--o{ FORM : fills
  FORM ||--|{ QUESTION : contains

  USER {
    string id PK
    string email
  }
  FORM {
    string id PK
    string user_id FK
  }
  QUESTION {
    string id PK
    string form_id FK
    string question_text
    string question_type
  }
```
````

```mermaid
---
title: form filling er-diagram
---
erDiagram
  USER |o--o{ FORM : fills
  FORM ||--|{ QUESTION : contains

  USER {
    string id PK
    string email
  }
  FORM {
    string id PK
    string user_id FK
  }
  QUESTION {
    string id PK
    string form_id FK
    string question_text
    string question_type
  }
```

<br/>

### Gantt chart

A simple timeline for project planning.

For example:

````md
```mermaid
---
title: Survey and design plan
---
gantt
  dateFormat  YYYY-MM-DD
  axisFormat %b-%d
  excludes weekends
  section Get requirements
    Survey        : req1, 2025-01-01, 2025-01-10
    Survey reports: req2, after req1, 3d
  section Design
    Meeting for design: crit, active, des1, 2025-01-16, 2025-01-20
    Design proposal   : after des1, 11d
```
````

```mermaid
---
title: Survey and design plan
---
gantt
  dateFormat  YYYY-MM-DD
  axisFormat %b-%d
  excludes weekends
  section Get requirements
    Survey        : req1, 2025-01-01, 2025-01-10
    Survey reports: req2, after req1, 3d
  section Design
    Meeting for design: crit, active, des1, 2025-01-16, 2025-01-20
    Design proposal   : after des1, 11d
```

<br/>

### Mindmap

Great for brainstorming and organize ideas.

For example:

````md
```mermaid
---
title: "How should our new service look like?"
---
mindmap
  root((Our new service))
    [target groups]
      schools
      universities
    [platform]
      android app
      ios app
    [Purposes]
      class organization
      homework management
      exam reports
```

````

```mermaid
---
title: "How should our new service look like?"
---
mindmap
  root((Our new service))
    [target groups]
      schools
      universities
    [platform]
      android app
      ios app
    [Purposes]
      class organization
      homework management
      exam reports
```

---

## Repo

I've create a repo for more Mermaid diagrams here.

{% include bbz_custom/link_preview.html url="<https://github.com/bluebirz/diagram-playground/tree/main/Mermaid/markdown>" %}
