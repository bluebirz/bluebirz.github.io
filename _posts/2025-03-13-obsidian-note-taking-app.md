---
title: "Create a second brain with Obsidian"
layout: post
author: bluebirz
description: No need to remember everything, just write it down in Obsidian.
date: 2025-03-13
categories: [apps]
tags: [Obsidian]
comment: true
image:
  path: ../assets/img/features/external/obsidian-banner.png
  alt: Obsidian banner
  caption: <a href="https://obsidian.md/">Obsidian</a>
---

## What is Obsidian?

Obsidian is a note-taking app but enhanced with a second brain concept. Notes are written in markdown, can be connected using backlinks and be visualized as a graph to see relationships between notes.

All notes store in a "vault" which is a folder and we can create multiple vaults.

One of its strengths is customizability. Fonts, colors, layouts, themes, templates, and plugins can be changed as much as we want.

Below is the website of Obsidian.

{% include bbz_custom/link_preview.html url='<https://obsidian.md/>' %}

We can install by installer or package manager. I rather use homebrew to install it. And this is a very default look of obsidian when we open it up for the first time.

![default](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/obsidian/default.png)

---

## Alternatives to Obsidian

Here are some apps that are alternatives to Obsidian.

- [Logseq](https://logseq.com/)  
  Another second brainer app. I tried it for several days and decided not to go with.
- [Bear](https://bear.app/)  
  This app is freemium. At the time I tried, it required a subscription to sync across devices.
- [Roam Research](https://roamresearch.com/)
- [Notion](https://www.notion.com/)  
  I have an issue with Notion's privacy policy so I rather not to use it.
- [Craft](https://www.craft.do/)
- [Drafts](https://getdrafts.com/)

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
  Graph view allows you to see the connections between notes. It's so good when we need to see overview of notes but I barely use it because my notes are mostly sparse and don't get much connected to each other.

### I don't like this

- **Tab management**  
  When I open a note, it always open in the current tab. In order to open a note in new tab, we need to press <kbd>ctrl</kbd> and click or right-click to <kbd>open in new tab</kbd> and that's a bit annoying for me.  
  However, I installed a plugin to solve this, even thought it has some issues with specific file types.

---

## My setup

This is my obsidian after spending time to customize it.

![my-setup-mac](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/obsidian/my-setup.png)
*Look & feel on my Mac*

![my-setup-ios](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/obsidian/my-setup-ios.jpeg){:style="max-width:40%;margin:auto;"}
*Look & feel on my iPhone*

### Vault

- **iCloud Drive**  
  Obsidian offers [Obsidian Sync](https://obsidian.md/sync) with subscription fee.  
  Anyway, I prefer syncing on iCloud Drive just by creating a vault in the iCloud Drive folder. This also works with OneDrive, Google Drive, and syncing this way is **free**[^sync].

### Core plugins

- **Backlinks**
- **Daily Notes**  
  - Create subfolders based on year/month[^day] by applying "Date format" as `YYYY/MM/YYYY-MM-DD ddd`.
    ![daily notes config](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/obsidian/daily-note-config.png){:style="max-width:90%;margin:auto"}

    and the files will be structured like this:  
    ![daily notes structure](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/obsidian/daily-note-folder.png){:style="max-width:50%;margin:auto;"}
  - Apply templates for daily notes (look at my setup below.)
- **Slash Commands**  
  Not have to tap nor click, we can just start with slash (`/`) to run command such as moving this file to another folder.  
  ![slash commands](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/obsidian/slash-command.png){:style="max-width:50%;margin:auto;"}

- **Templates**  
  Creating templates and generate it up when we call a configured menu. For example, template for daily notes[^template]. There are several pages about Obsidian templates, including in the forum[^template-forum].
- **[Obsidian Clipper](https://docs.obsidianclipper.com/)**  
  I love this plugin. It scraps website pages into markdown files in my vault so I can read it later.

### Community plugins

Community plugins can be found in <kbd>Settings</kbd> windows.

- **[Calendar](https://obsidian.md/plugins?id=calendar)**  
  It's a simple calendar that create/open a new daily note when clicking on a date.
- **[Dataloom](https://obsidian.md/plugins?id=notion-like-tables)**  
  Dataloom manages a table and allows filtering, columns pinning, and many more.
- **[File Explorer Note Count](https://obsidian.md/plugins?id=file-explorer-note-count)**  
  This plugin displays the number of notes in each folders.
- **[Iconic](https://obsidian.md/plugins?id=iconic)**  
  This allows users to add icons to each notes and folders.
- **[Kanban](https://obsidian.md/plugins?id=obsidian-kanban)**  
  We can create a Trello-board-like note with this.
- **[Open in New Tab](https://obsidian.md/plugins?id=open-in-new-tab)**  
  This plugin will open a selected note in a new tab or the existing tab if the note has been opened. However, this wouldn't work with some note types such as daily notes.
- **[Style Settings](https://obsidian.md/plugins?id=obsidian-style-settings)**  
  This plugin can override Obsidian theme or appearance and allow us to customize.

### Styling

- **Theme: [Things](https://github.com/colineckert/obsidian-things)**  
  I like this theme. It looks and provide several checkbox styles for a variety of my needs.
- **Templates**  
  I have only 1 template at this moment, Daily Note.

  ```md
  ## Tasks

  - [ ]

  ## Notes

  -

  ```

  And it looks like this when I create a new daily note.  
  ![new note](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/obsidian/daily-note-page.png){:style="max-width:66%;margin:auto;"}

- **Folder colors**  
  I decorated folder background colors by adding code snippets[^color].  
  To install it, we download the CSS file and place into the folder `vault/.obsidian/snippets/`. We can open the folder by clicking the folder icon at the menu <kbd>Appearance</kbd> > <kbd>CSS Snippets</kbd>. After the CSS files are placed, click the refresh button and enable the snippets we need.

  ![css snippets](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/obsidian/css-snippets.png){:style="max-width:66%;margin:auto;"}

---

## References

[^sync]: [Sync your notes across devices](https://help.obsidian.md/sync-notes)
[^day]: [Daily notes: Allow formatting file location (subfolders based on year/month)](https://forum.obsidian.md/t/daily-notes-allow-formatting-file-location-subfolders-based-on-year-month/19711)
[^color]: [Minimalist colored folders](https://forum.obsidian.md/t/minimalist-colored-folders/54032)
[^template]: [Templates](https://help.obsidian.md/plugins/templates)
[^template-forum]: [16 Obsidian Templates For Zettelkasten To Start With](https://forum.obsidian.md/t/16-obsidian-templates-for-zettelkasten-to-start-with/49098)
