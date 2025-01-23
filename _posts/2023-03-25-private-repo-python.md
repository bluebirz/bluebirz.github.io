---
title: A private repo for our own Python packages
layout: post
description: Google Artifact Registry is a service from Google to store an image, a module in Python, NodeJS, and much more.
date: 2023-03-25 00:00:00 +0200
categories: [devops]
tags: [Python, private repository, Google Cloud Platform, Google Artifact Registry, container]
image:
  path: ../assets/img/features/ashin-k-suresh-mkxTOAxqTTo-unsplash.jpg
  alt: Unsplash / Ashin K Suresh
  caption: <a href="https://unsplash.com/photos/a-lit-up-box-sitting-on-top-of-a-table-mkxTOAxqTTo">Unsplash / Ashin K Suresh</a>
---

Functions are very common in programming schemes. They are useful for repeated operations and readability. Then, what if we have to add the same functions into our programs for many?

Imagine we have many projects in our hands, and some of them need a same function. We might end up copying that same function into each. That will be a redundancy problem which mean we probably have to maintain the function multiple times based on number of copies.

---

## Talk a basic one

Let's say we have files like this.

<script src="https://gist.github.com/bluebirz/88927b7f719c0e1610a636ff66641336.js?file=local-structure.md"></script>

We have a function to sum all integers in a list here in "adder.py".

<script src="https://gist.github.com/bluebirz/88927b7f719c0e1610a636ff66641336.js?file=local-adder.py"></script>

We can import it into a main program "main.py" like this.

<script src="https://gist.github.com/bluebirz/88927b7f719c0e1610a636ff66641336.js?file=local-main.py"></script>

Run and the output should be like the following.

![local adder](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/custom-py-modules/00-start.png){:style="max-width:66%;margin:auto;"}

But, how could we share this adder function for the team?

---

Introducing...

## Google Artifact Registry

Google Artifact Registry is a service from Google to store an image, a package in Python, NodeJS, and much more (see full list [here](https://cloud.google.com/artifact-registry/docs/supported-formats).)

We now use it to store our functions. Here is the list of our missions today.

1. Build a package and upload to Google Artifact Registry repository
1. Prepare setting to access the repo
1. Install the package
1. Test if we can import the package successfully

Let's go!

### 1. Build and upload

#### 1.1. Prepare a repository in Google Artifact Registry

- Make sure the API is enabled, otherwise enable it.

![GAR api](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/custom-py-modules/01-enable-api.png){:style="max-width:50%;margin:auto;"}

- Create a repo. Feel free to use the web console, but this time we use gcloud command.

```sh
gcloud artifacts repositories create {REPO-NAME} --repository-format=python --location={LOCATION}
```

![repo create](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/custom-py-modules/02-create-repo.png){:style="max-width:66%;margin:auto;"}

- Verify if the repo is ready

![repo created](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/custom-py-modules/03-ui-repo.png){:style="max-width:66%;margin:auto;"}

#### 1.2. Prepare a package

Install libraries.

<script src="https://gist.github.com/bluebirz/88927b7f719c0e1610a636ff66641336.js?file=artifact-requirements.txt"></script>

Setup files for packaging.

<script src="https://gist.github.com/bluebirz/88927b7f719c0e1610a636ff66641336.js?file=artifact-structure.md"></script>

- "LICENSE"  
    <script src="https://gist.github.com/bluebirz/88927b7f719c0e1610a636ff66641336.js?file=artifact-license"></script>
- "README.md"  
    <script src="https://gist.github.com/bluebirz/88927b7f719c0e1610a636ff66641336.js?file=artifact-readme.md"></script>
- "pyproject.toml"  
    <script src="https://gist.github.com/bluebirz/88927b7f719c0e1610a636ff66641336.js?file=artifact-pyproject.toml"></script>
- "src/" files.  
  Should have a folder with same name as project name in pyproject.toml at line #6 to avoid naming mistakes.
- "test" files.  
  Can be empty at this moment.

#### 1.3. Build the package

```sh
python3 -m build
```

![build](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/custom-py-modules/04-build.png){:style="max-width:66%;margin:auto;"}

As a result, we should see the folder "dist" in the same directory as "src".

![dist](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/custom-py-modules/05-dist.png){:style="max-width:50%;margin:auto;"}

#### 1.4. Upload to Google Artifact Registry

Now it's time to upload our package to the repo on Google Artifact Registry.

```sh
twine upload --repository-url https://{LOCATION}-python.pkg.dev/{PROJECT-ID}/{REPO-NAME}/ dist/*
```

![twine upload](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/custom-py-modules/06-upload.png){:style="max-width:66%;margin:auto;"}

#### 1.5. Verify the package

- Web UI  

    ![repo update](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/custom-py-modules/07-repo-loaded.png)

- List packages

    ```sh
    gcloud artifacts packages list --repository={REPO-NAME} --location={LOCATION}
    ```

    ![package list](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/custom-py-modules/08-list-pkg.png){:style="max-width:66%;margin:auto;"}

- List package versions

    ```sh
    gcloud artifacts versions list --package={PACKAGE-NAME} --repository={REPO-NAME} --location={LOCATION}
    ```

    ![versions list](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/custom-py-modules/09-list-pkg-version.png){:style="max-width:66%;margin:auto;"}

### 2. Access the repo

Now we already have the first package in our Google Artifact Registry repo. So what should we do next to access and grab it?

We need 3 things

1. ".pypirc"
1. "pip.conf"
1. "requirements.txt" with our index URLs

#### 2.1. Print setting from the repo

Run the command

```sh
gcloud artifacts print-settings python \
--project={PROJECT-ID} \
--repository={REPO-NAME} \
--location={LOCATION}
```

And we should get the similar output.

![artifacts setting](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/custom-py-modules/10-print-setting.png){:style="max-width:66%;margin:auto;"}

#### 2.2. Copy a part of output to ".pypirc"

The ".pypirc" would be like this.

<script src="https://gist.github.com/bluebirz/88927b7f719c0e1610a636ff66641336.js?file=entry-point-pypirc"></script>

#### 2.3. Copy another part to "pip.conf"

Like this one.

<script src="https://gist.github.com/bluebirz/88927b7f719c0e1610a636ff66641336.js?file=entry-point-pip.conf"></script>

#### 2.4. Add a package name for "requirements.txt"

<script src="https://gist.github.com/bluebirz/88927b7f719c0e1610a636ff66641336.js?file=entry-point-requirements.txt"></script>

`-i` means the flag `--index-url`. We need this to tell `pip` to find this package name in that URL as well.

#### 2.5. Final structure

<script src="https://gist.github.com/bluebirz/88927b7f719c0e1610a636ff66641336.js?file=entry-point-structure.md"></script>

### 3. Install the packages

At this step, we should install the packages we developed. Just using the command.

```sh
pip install -r requirements.txt
```

See we finally got the package in our environment now. Verify with the command.

```sh
pip list | grep {PACKAGE-NAME}
```

![pip list](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/custom-py-modules/11-pip-install.png){:style="max-width:66%;margin:auto;"}

When we go see the folders inside our "virtualenv", we would find our files there.

![folder my_adder](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/custom-py-modules/12-venv.png){:style="max-width:66%;margin:auto;"}

### 4. Test the package

The last step is to ensure we can import the package properly and successfully. Now we can `import` from the folder name like this.

<script src="https://gist.github.com/bluebirz/88927b7f719c0e1610a636ff66641336.js?file=entry-point-main.py"></script>

And run it with confidence.

![test run](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/custom-py-modules/13-test-function.png){:style="max-width:66%;margin:auto;"}

YEAH!! WE DID IT!!

---

## Integrate with Docker image

Let's move to next topic. Basically Docker image is a fundamental tool for development. We shall apply this package with the image as follows.

### 1. Prepare structure

let's say we have files in this structure. don't forget ".pypirc", "pip.conf", and "requirements.txt"

<script src="https://gist.github.com/bluebirz/88927b7f719c0e1610a636ff66641336.js?file=entry-point-docker-structure.md"></script>

### 2. Understand "OAuth 2.0 token" from GCP

When we work with a Docker image, need to know that we can't directly access GCP APIs unlike running a `gcloud` command on our laptop. This means, our one big question is how can we authenticate to access the Google Artifact Registry repo.

The answer is, to authenticate through "OAuth 2.0 Token".

In brief, "OAuth 2.0 token" is a long long string used for authenticating to a system, in this case is Google Cloud Platform. Follow [the link](https://developers.google.com/identity/protocols/oauth) to read more.

### 3. Apply OAuth 2.0 token

We will generate the OAuth 2.0 token and add it into the "requirements.txt" in order to authorized access and read then download the package.

This is what "requirements.txt" in OAuth 2.0 token version looks like.

<script src="https://gist.github.com/bluebirz/88927b7f719c0e1610a636ff66641336.js?file=entry-point-docker-tokenized-requirements.txt"></script>

At the token part, that `ya29.abc123`, we need to generate it with the command.

```sh
gcloud auth print-access-token
```

Learn more about this command [here](https://cloud.google.com/sdk/gcloud/reference/auth/print-access-token).

One thing to remember is **storing credentials in Git is bad practice**.

So what should we do? We will create the "requirements.txt" with OAuth 2.0 token from the raw version inside the image and delete that OAuth 2.0 token version as soon as the installation is completed.

---

### 4. Define Dockerfile

As mentioned above, now we can create a Dockerfile

<script src="https://gist.github.com/bluebirz/88927b7f719c0e1610a636ff66641336.js?file=entry-point-docker-Dockerfile"></script>

- Get a token as a parameter by `ARG TOKEN` at line #4.
- Normally "requirements.txt" has `-i` as `https://{LOCATION}...`, so we need to substitute to another with `awk` (using `sed` before yet I got many errors).
- Once substitution completed, save result into another requirements.txt, name it tokenized_requirements.txt
- pip install from "tokenized_requirements.txt".
- Delete "tokenized_requirements.txt" not to leak the credentials
- Put `CMD` at the end to run the command when an image container is run.

### 5. Build an image and test run

Now build an image with this command

```sh
docker build \
--no-cache \
--progress=plain \
--build-arg TOKEN=$(gcloud auth print-access-token) \
-t entry-point:latest .
```

- `--no-cache` means building this image without any cache from previous builds.
- `--progress=plain` means printing out the build progress in plain format.
- variable `TOKEN` can be parsed via flag `--build-arg`.
- Name it "entry-point" by flag `-t`.

![build image](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/custom-py-modules/14-docker-build.png){:style="max-width:66%;margin:auto;"}

Once the image is there, we can run to see the result.

```sh
docker run -it --name testpy entry-point
```

And yes, it's correct.

![docker run](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/custom-py-modules/15-docker-run.png){:style="max-width:66%;margin:auto;"}

---

## Bottomline diagram

I write the diagram to summarize all process above.

![diagram](https://bluebirzdotnet.s3.ap-southeast-1.amazonaws.com/custom-py-modules/GAR_py.drawio.png)

---

## Repo

All materials in this blog also is at the [github repo](https://github.com/bluebirz/google-artifact-registry-custom-module).

---

## Bonus track

If using Google Cloud Composer, we can setup to install the package from Google Artifact Registry by following [this link](https://cloud.google.com/composer/docs/how-to/using/installing-python-dependencies#install-ar-repo).

---

## References

- [Packaging Python Projects](https://packaging.python.org/en/latest/tutorials/packaging-projects/)
- [How to Publish Python package at PyPi using Twine module?](https://www.geeksforgeeks.org/how-to-publish-python-package-at-pypi-using-twine-module/)
- [Configure authentication to Artifact Registry for Python package repositories](https://cloud.google.com/artifact-registry/docs/python/authentication)
- [Python Packages in Artifact Registry (Updated)](https://lukwam.medium.com/python-packages-in-artifact-registry-d2f63643d2b7)
- [How to find and replace string without use command Sed?](https://unix.stackexchange.com/questions/97582/how-to-find-and-replace-string-without-use-command-sed)
