---
title: Lock a file with GPG
layout: post
author: bluebirz
description: GPG is a tool to encrypt a file or a message with a public key into unreadable format.
date: 2021-10-20
categories: [security]
tags: [Shell script, GPG]
comment: true
image:
  path: https://images.unsplash.com/photo-1515974256630-babc85765b1d?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  lqip: https://images.unsplash.com/photo-1515974256630-babc85765b1d?q=10&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
  alt: Unsplash / Moja Msanii
  caption: <a href="https://unsplash.com/photos/honeywell-home-wall-appliance-vO9-gal54go">Unsplash / Moja Msanii</a>
---

**GPG** (stands for **GNU Privacy Guard**)  is a tool to encrypt a file or a message with a public key into unreadable format and can be read once decrypted back to its original form using a private key.

That private key has to be held by only one person (that is us) while the public keys can be shared to others. It's called **asymmatric keys**.

---

## Benefits

As an asymmatric key exchange, we don't have to worry to share keys because it's not a single key. We just share our public keys to partners for encrypting their data and decrypt them in our place using our own private key.

Note that it's only private key that must not share to others. It is simple and consume pretty less time to establish the encryption mechanism.

---

## How it works?

First of all, see the diagram below.

![gpg flow](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/gpg/flow.png)

Yes, there are two person, receiver and sender. The receiver is decrypter who decrypt the message and the sender, of course, is encrypter.

A receiver need to create their own private key and public key. A private key is for decrypt an object that is already encrypted with the matched public key from a sender.

Passpharses are optional to enable more secure encryption. And Checksum is also optional to ensure if the sender is expected for the receiver.

---

## Prerequisites

This requires only a GPG program. GPG could be already installed in most of UNIX-based, I guess. However, you can install it manually, visit <https://gnupg.org/download/>

---

## Start programming

### [Receiver] Preparation

I prepare 2 environments as below.

![prep](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/gpg/01_prepare_env.png)

`cent` acts as receiver and `cent2` is sender.

### [Receiver] Generate keys

After accessing into `cent`, the receiver, run this to start a prompt for generating GPG keys.

```sh
gpg --full-generate-key
```

Type your information and choices by each question like below. I wanna spot two things in this dialogs

1. A generated key can be **no expired** if we put `0` for the question "Key is valid for?"
1. An email at "Email address" is the identity for further uses. Please recheck it before submitting.

Now Adam is here.

![genkey](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/gpg/02_gen_key.png)

### [Receiver] Error: No pinentry

It's possibly failed at the first run due to `gpg: problem with the agent: No pinentry`. So we need to install the `pinentry`.

```sh
yum install pinentry
```

![pinentry](https://bluebirzdotnet.s3.ap-sou#theast-1.amazonaws.com/gpg/03_pinentry.png)

`yum` may not available on your system. Please check your package manager.

### [Receiver] List keys

Let's say we now have keys. List the key with this.

```sh
# list public keys
gpg --list-keys

# list private keys
gpg --list-secret-keys
```

![gpg list](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/gpg/04_list_key.png)

### [Receiver] Export keys

Now the time to export our public key to partners and let them encrypt something back for test.

The diagram at the first shows key server as exchanger but I prefer sharing the key as a file attached in a mail to make sure our partners can import the key completely.

```sh
gpg --export -o <destination_path> -a
```

`-o` means output path and `-a` is create armor ascii output.

The output should be looked like this.

![gpg export](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/gpg/05_export.png)

### [Sender] Import key

Turn back to sender. First is to import the public key.

```sh
gpg --import <public_key_path>
```

confirm the import with key listing so we can see Adam.

![gpg import](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/gpg/06_import.png)

### [Sender] Trust the key

Recent imported key always untrust so trust them before use.

```sh
gpg --edit-key <email_of_public_key>
```

A dialog appears and type <kbd>trust</kbd>, <kbd>5</kbd> for ultimately trust this, <kbd>y</kbd> to confirm, and <kbd>quit</kbd> to quit the dialog.

Now the key is ready to use.

![trust key](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/gpg/07_trust.png)

### [Sender] Create sample file

Let's create a greeting message for Adam and wrap it into the file.

![create file](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/gpg/08_create_msg.png)

### [Sender] Encrypt the file

A single line of command to encrypt the file.

```sh
gpg --output <output_encrypted_file> --batch --yes -e -r <public_key_email> <original_file>
```

- `--batch --yes` means run this command in batch so it can run in background.
- `-e` means encryption operation
- `-r` means it follows by the target recipient's email

![encrypt](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/gpg/09_encrypt.png)

Now the encrypted files are ready to send back to the receiver.

### [Receiver] Decrypt the file

Say the receiver, Adam, got the file from Brian already. Let's decrypt it.

```sh
gpg --output <destination_path> --batch --yes --decrypt <original_encrypted_file>
```

GPG will search the correct private key in the machine and output decrypted file will be ready if the private key is there.

Check out the message.

![gpg decrypt](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/gpg/10_decrypt.png)

---

## Add password

We may need another level to protect the file. Adding passwords is a good one.

### [Sender] Add password to the encrypted file

```sh
gpg --output <output_encrypted_file> --batch --yes -e -r <public_key_email> --passphrase <password> <original_file>
```

Don't forget to tell the receiver what the password is.

![add pwd](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/gpg/11_encrypt_pwd.png)

### [Receiver] Decrypt the file with password

Got a new file but it's protected with password. Add the password to decrypt.

```sh
gpg --output <destination_path> --batch --yes --passphrase <password> --decrypt <original_encrypted_file>
```

![decrypt with pwd](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/gpg/12_decrypt_pwd.png)

Okay, password is correct.

---

## Checksum

Checksum is a data integrity calculation using `SHA` functions on bit counts of a message or a file. The result is a long text containing heximal numbers. It helps verify the data transmission to be completed and correct.

GPG offers ability to sign the checksum file, too. Before that, we **need the GPG key of sender** as well and receiver will be able to know who sent this message.

### [Sender] Generate key for sender

Run `gpg --full-generate-key` and, hey! Brian is here.

![gen full key](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/gpg/13_gen_key_sender.png)

### [Sender] Generate and sign Checksum

Checksum file can be made with this command.

```sh
sha256sum <message_file> | awk '{print $1}' > <checksum_file>
```

`sha256sum` is checksum function on CentOS and might be failed on other system.

Once the checksum file is ready, run this to sign.

```sh
gpg --output <signed_checksum_file> --batch --yes --quiet --sign <checksum_file>
```

![gpg sign checksum](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/gpg/14_create_checksum_encrypt.png)

### [Receiver] Verify and decrypt Checksum

Adam got the checksum file and want to see who sent this.

```sh
gpg --verify <signed_checksum_file>
```

Now we're sure it's from Brian. Next is to verify if decrypted file is completed and valid. We have to decrypt the checksum and compare its content with the checksum of our decrypted file.

```sh
# calculate checksum on decrypted file
sha256sum <decrypted_file> | awk '{print $1}'

# decrypt the checksum from sender
gpg --output <checksum_file> --decrypt <sign_checksum_file>
```

In case of matched value, it indicates the file we decrypted is valid in content and from the sender we trust.

![gpg verify](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/gpg/15_verify_decrypt.png)

---

## References

- [GPG Cheat Sheet](https://irtfweb.ifa.hawaii.edu/~lockhart/gpg/)
- [Pinentry](https://chaosfreakblog.wordpress.com/2013/06/21/gpg-problem-with-the-agent-no-pinentry-solved/)
