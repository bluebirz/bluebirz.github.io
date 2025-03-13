---
title: "Deploy Secure Github pages with Custom Domain on Cloudflare"
layout: post
author: bluebirz
description:
# date:
categories: []
tags: []
pin: false
math: false
mermaid: false
comment: true
series:
  key: asd
  index: 1 
image:
  path: ../assets/img/features/
  alt: Unsplash / 
  caption: <a href="">Unsplash / </a>
---

According to the previous blog about moving to Github pages below.

{% include bbz_custom/link_preview.html post="2025-01-28-move-to-github-pages.md" %}

I got some stuffs to share about how to enable HTTPS on Github pages with our own domain name on Cloudflare.

---

## Prerequisites

1. Github pages that is already online in the url `https://<USERNAME>.github.io`.
1. Domain name
1. Cloudflare account
1. IP addresses of Github pages according to [Managing a custom domain for your GitHub Pages site](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site)

---

## Action steps

### Cloudflare configurations

1. Go to Cloudflare > Menu <kbd>DNS</kbd> > <kbd>Records</kbd>
1. Add `A` records with "Content" as Github pages IP addresses and "Proxy status" as "DNS Only".  
  Set "Name" as "@" if it's root which means it's not subdomain. Cloudflare will show the domain name after adding the record.
1. Add `CNAME` record with "Content" as our domain name, "Name" as "www", and "Proxy status" as "DNS Only".

> By default, adding new record will have "Proxy status" as "Proxied" which means it will go through Cloudflare's network. But we don't need it because Github pages already has HTTPS.
>
> ![proxied](../assets/gh/cloudflare-default.png)
>
> Make sure that the records have "Proxy status" as "DNS Only" like below.
>
> ![dns only](../assets/gh/cloudflare-suppose.png)
>
> Otherwise, we can't setup HTTPS on Github pages.
{: .prompt-warning}

### Github pages configurations

1. Go to

---

```sh
dig <DOMAIN_NAME> +noall +answer -t A
```

---

## References

- [Managing a custom domain for your GitHub Pages site](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site)
- [Secure and fast GitHub Pages with CloudFlare](https://blog.cloudflare.com/secure-and-fast-github-pages-with-cloudflare/)
- [Enforcing HTTPS on GitHub pages with Cloudflare](https://www.nickquinn.co.uk/posts/github-pages-with-cloudflare/)
