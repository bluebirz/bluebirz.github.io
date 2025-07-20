---
title: "Deploy Secure Github pages with Custom Domain on Cloudflare"
layout: post
author: bluebirz
description: We can enable HTTPS on Github pages with custom domain name on Cloudflare.
date: 2025-03-14
categories: [tips & tricks]
tags: [Github, Github Pages, Cloudflare]
comment: true
image:
  path: assets/img/features/bluebirz/cloudflare-gh.drawio.png
  lqip: ../assets/img/features/lqip/bluebirz/cloudflare-gh.drawio.webp
  alt: github pages with cloudflare
  caption: 
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

1. Go to Cloudflare > Select a domain name > Menu <kbd>DNS</kbd> > <kbd>Records</kbd>
1. Add `A` records with "Content" as Github pages IP addresses and "Proxy status" as "DNS only".  
  Set "Name" as "@" if it's root which means it's top level domain and Cloudflare will show the domain name instead of "@" after adding the record.
1. Add `CNAME` record with "Content" as our domain name, "Name" as "www", and "Proxy status" as "DNS only".

> By default, new record will have "Proxy status" as "Proxied" which means it will go through Cloudflare's network.
>
> ![proxied](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/github-page-custom-domain-cloudflare/cloudflare-default.png)
>
> But we don't need it because we are going to enable HTTPS by Github pages.
>
> Make sure that we turn it off and the records have "Proxy status" as "DNS only".
{: .prompt-warning}

These are my configurations.

![dns only](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/github-page-custom-domain-cloudflare/cloudflare-suppose.png)

### Github pages configurations

1. Go to the repo of our Github pages.
1. Select tab "Settings" > "Code and automation" > "Pages"
1. Add our domain name under "Custom domain" section and click <kbd>Save</kbd>
1. The checkbox "Enforce HTTPS" should be clickable and we click it.
1. Github will issue the certificate and it takes some time to complete.

![github-https](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/github-page-custom-domain-cloudflare/github-https.png)

> If the Cloudflare configurations have "Proxied" status, Github will not be able to issue the certificate.
>
> And we would see the message: *"Unavailable for your site because your domain is not properly configured to support HTTPS"*.
{: .prompt-warning}

---

## Test it

1. Run `dig` command then we should see the IP addresses from Github pages.

    ```sh
    dig <DOMAIN_NAME> +noall +answer -t A
    ```

    ![dig](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/github-page-custom-domain-cloudflare/dig.png){:style="max-width:66%;margin:auto;"}

1. Try to access the domain name. Our webpage should be rendered properly with HTTPS.

---

## References

- [Managing a custom domain for your GitHub Pages site](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site)
- [Secure and fast GitHub Pages with CloudFlare](https://blog.cloudflare.com/secure-and-fast-github-pages-with-cloudflare/)
- [Enforcing HTTPS on GitHub pages with Cloudflare](https://www.nickquinn.co.uk/posts/github-pages-with-cloudflare/)
