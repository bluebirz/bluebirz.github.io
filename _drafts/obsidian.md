---
title: "Create a second brain with Obsidian"
layout: post
author: bluebirz
description: No need to remember everything, just write it down in Obsidian.
date: 00:00:00 +0200
categories: []
tags: []
comment: true
image:
  path: ../assets/img/features/external/obsidian-banner.png
  alt: Obsidian banner
  caption: <a href="https://obsidian.md/">Obsidian</a>
---


## What is Obsidian?

{% include bbz_custom/link_preview.html url='<https://obsidian.md/>' %}

---

## My opinions about Obsidian

### I like this

- **Backlinks**  
  Backlinks are the most powerful feature in Obsidian. It helps you to connect notes together.
- **Customizable**  
  Almost everything can be customized. Fonts, Color, Layout, Templates, etc can be changed and moved around, sometimes plugins can help.
- **Open source**  
  Obsidian is free to use. And we can buy a license to support the developers, or enable some extra functionalities.
- **Markdown based**  
  I'm familiar with Markdown, so it's easy to write notes.
- **Apps and syncing**  
  There are Obsidian apps for Mac and iOS and I have used it so far and feel comfortable. Windows, Android, and other platforms are also available.
- **File preview**  
  Obsidian can preview files such as PDFs, and images.
  
### I feel so-so about this

- **Graph view**  
  Graph view allows you to see the connections between notes. It's so good when we need to see overview of notes but I barely use it because my notes are mostly sparse and don't connected to others.

### I don't like this

- **Tab management**  
  When I open a note, it always open in the current tab. In order to open a note in new tab, we need to press <kbd>ctrl</kbd> and click or right click to <kbd>open in new tab</kbd> and that's a bit annoying for me.  
  However, I installed a plugin to solve this, even thought it has some issues with specific file types.

---

## Alternatives to Obsidian

Here are some apps that are alternatives to Obsidian.

- [Logseq](https://logseq.com/)  
  Another second brainer app. I tried it for several days and decided not to go with.
- [Bear](https://bear.app/)  
  
- [Roam Research](https://roamresearch.com/)
- [Notion](https://www.notion.com/)
- [Craft](https://www.craft.do/)

---

## My setup

### Vault

- iCloud Drive

### Core plugins

- **Backlinks**
- **Daily Notes**  
  - Create subfolders based on year/month[^1] by applying "Date format" as `YYYY/MM/YYYY-MM-DD ddd`.
    ![daily notes config](../assets/obs/daily-note-config.png)

    and the files will be structured like this:
    ![daily notes structure](../assets/obs/daily-note-folder.png){:style="max-width:50%;margin:auto;"}
  - Apply templates for daily notes (look at my setup below.)
- **Slash Commands**
- **Templates**
- **[Obsidian Clipper](https://docs.obsidianclipper.com/)**

### Community plugins

Community plugins can be found in <kbd>Settings</kbd> windows.

- **[Calendar](https://obsidian.md/plugins?id=calendar)**  
  It's a simple calendar that create/open a new daily note when clicking on a date.
- **[Dataloom](https://obsidian.md/plugins?id=notion-like-tables)**  
  Dataloom manages a table and allows filtering, columns pinning, and many more.
- **[File Explorer Note Count](https://obsidian.md/plugins?id=file-explorer-note-count)**
- **[Iconic](https://obsidian.md/plugins?id=iconic)**
- **[Kanban](https://obsidian.md/plugins?id=obsidian-kanban)**
- **[Open in New Tab](https://obsidian.md/plugins?id=open-in-new-tab)**
- **[Style Settings](https://obsidian.md/plugins?id=obsidian-style-settings)**

### Styling

- **Theme: [Things](https://github.com/colineckert/obsidian-things)**  
  I like this theme from its clean look and several checkbox styles.
- **Templates**  
  I have only 1 template at this moment, Daily Note.

  ```md
  ## Tasks

  - [ ]

  ## Notes

  -

  ```

- **Folder colors**  
  I decorated folder background colors by adding code snippets[^2]

---

## References

[^1]: [Daily notes: Allow formatting file location (subfolders based on year/month)](https://forum.obsidian.md/t/daily-notes-allow-formatting-file-location-subfolders-based-on-year-month/19711)
[^2]: [Minimalist colored folders](https://forum.obsidian.md/t/minimalist-colored-folders/54032)
