---
title: 2-Factor Authentication - Security of our privacy
layout: post
author: bluebirz
description: How can we protect our accounts like the way we bought locks and keys or kind of to protect our house doors?
date: 2020-04-08
categories: [security]
tags: [2FA, cyber security]
comment: true
image:
  path: https://images.unsplash.com/photo-1603899122634-f086ca5f5ddd?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Franck
  caption: <a href="https://unsplash.com/photos/black-iphone-5-on-yellow-textile-DoWZMPZ-M9s">Unsplash / Franck</a>
---

How many accounts you have on the internet?

It's 21st century that rare people have no online accounts. Facebook, Twitter, YouTube, Instagram, and etc. are online platforms located on the internet and we are netizens living in them, at least one.

But how can we protect our accounts like the way we bought locks and keys or kind of to protect our house doors.

![meme](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/2fa/DE8txt5XcAMpAB5.jpeg)
*Credit: <https://twitter.com/RasuShrestha/status/886979853265899520>*

The joke is real. I had seen my colleagues used post-its to remind their passwords and sticked them on their computers, desks, and partition panels. Their passwords may include everything they think they can't remember – file passwords, intranet passwords, or even their own social media account passwords.

Most of us have known just a single password can used to login but not to protect our account. Let's see what if our accounts would be stolen.

- In case of social media accounts, an account thief can impersonate as us to borrow money or do some financial statements.
- In case of bank accounts, we sure lose all money.
- In case of credential files, they got valuable information for direct or indirect exploitations.
- Leaking a password of one account may lead to another account as we cannot remember various patterns of our own passwords and set them up in same or similar scenario.

---

## Transform a phone to be a secondary password

Now we mostly have mobile phones, I mean smart phones. Why not apply them to be additional password? A thief must have our password and phones in order to enter to the system. It is 2-Factor Authentication or 2FA.

2FA requires 2 different passwords, one is an ordinary password that we have to set at the time we registered and second is created or sent from the system.

This time we are going to use 2FA from QR code which has 30 seconds as its lifetime before expires.

Here we go!

---

## 1. Need a 2FA application

Mine is [Microsoft Authenticator](https://www.microsoft.com/en-us/account/authenticator) and you can try [Authy](https://authy.com/) or [Google Authenticator](https://support.google.com/accounts/answer/1066447).

---

## 2. Login to the system that we need to setup 2FA

This time we gonna setup one of Twitter. Go to Setting → Privacy and safety → two-factor authentication. Then tick at "Authenticator app" and we should find this.

![twt 2fa start](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/2fa/Screen-Shot-2020-04-06-at-22.52.41.png)

Follow the instruction until QR code appears.

---

## 3. Scan the QR code with the app

Once the scan is completed, the 30-second-timer code should be there (look at the bottom of the figure).

![ms auth](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/2fa/IMG_3313_blur.png)

---

## 4. Confirm the code

At the Twitter page, we have to input the code above and the process will be finished.

![twt 2fa done](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/2fa/Screen-Shot-2020-04-06-at-22.57.04.png)

---

## 5. Next login needs 2FA code

After we setup the 2FA, the 2FA codes are required every time we try logging in to the system. Now we have added one more barrier to our own accounts.

More than that, Twitter and many platform provide "Backup code" in case we cannot access to the app. The backup code is single-used item.

---

Here we can setup 2FA for own accounts and please take care your privacy with this security on the online world.

See ya next time.

Bye~
