# `dgoss`
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Ftcwlab%2Fdgoss.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2Ftcwlab%2Fdgoss?ref=badge_shield)
[![pipeline status](https://gitlab.com/tcwlab.com/saas/baseline/images/dgoss/badges/main/pipeline.svg)](https://gitlab.com/tcwlab.com/saas/baseline/images/dgoss/-/commits/main)
[![coverage report](https://gitlab.com/tcwlab.com/saas/baseline/images/dgoss/badges/main/coverage.svg)](https://gitlab.com/tcwlab.com/saas/baseline/images/dgoss/-/commits/main)
[![GitHub tag](https://img.shields.io/github/tag/tcwlab/dgoss)](https://github.com/tcwlab/dgoss/releases/?include_prereleases&sort=semver "View GitHub releases")
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://gitlab.com/tcwlab.com/saas/baseline/images/dgoss/-/blob/main/LICENSE)

## tl;dr

This image is used to validate that a container is behaving and working as expected.
As this project is just _wrapping_ the `goss` and `dgoss` tools, you will not find
much details about the usage of these tools, but only how to use this image.

## Quick reference

- **Maintained by:** [Sascha Willomitzer](https://thechameleonway.com) [(of the TCWlab project)](https://gitlab.com/sascha_willomitzer)
- **Where to get help:** [file an issue](https://gitlab.com/tcwlab.com/saas/baseline/images/dgoss/-/issues)
- **Supported architectures:** linux/amd64
- **Published image artifact details:** [see source code repository](https://gitlab.com/tcwlab.com/saas/baseline/images/dgoss/-/tree/main)
- **Documentation:** For `goss` and `dgoss` you can find some explanations in the [original project](https://github.com/aelsabbahy/goss/blob/master/README.md)

## Getting started

This docker image is intended to be used as a part of a CI/CD pipeline. It is based on the official
[Docker library image](https://hub.docker.com/_/docker) and the great work of [aelsabbahy](https://github.com/aelsabbahy)
and his [GOSS tool](https://github.com/aelsabbahy/goss/).


As we only use this image as part of our GitLab pipelines, this is the configuration you could use.

The folder structure is very lean:

```bash
.
├── .gitlab-ci.yml
├── Dockerfile
├── goss
│   └── goss.yaml
```

First of all, you need a container image to test.

But in the following steps we only focus on
the part of _using_ [`tcwlab/dgoss`](https://hub.docker.com/r/tcwlab/dgoss).

### Step 1: `.gitlab-ci.yml`

For a full working example, please have a look at
[this working solution](https://gitlab.com/tcwlab.com/saas/baseline/images/dgoss/-/blob/main/.gitlab-ci.yml).

This is a snippet for your `.gitlab-ci.yml`:

```yaml
[...]
validate-image:
  stage: test
  # For this example we stick to the :latest tag
  image: tcwlab/dgoss:latest
  variables:
    # Path to the goss.yaml file in your repository
    GOSS_FILES_PATH: goss
    # Strategy to fix issues on some platforms
    GOSS_FILES_STRATEGY: cp
  script:
    - dgoss run -it <YOUR_CONTAINER_IMAGE>
  [...]
```

### Step 2: `Dockerfile`

As this Getting Started Guide is not taking care of multistage builds, etc. we start
as lean as we can:

```Dockerfile
FROM tcwlab/dgoss:latest
RUN echo "hello from inside"
```

If you want to see a real world example, please [have a look here](https://gitlab.com/tcwlab.com/saas/baseline/images/dgoss/-/blob/main/Dockerfile).

### Step 3: `goss.yaml`

In order to test our container image, we define what we want to have inside.
- binary for `goss` is in place
- script for `dgoss` is in place
- `goss -v` returns the wanted version (in this example v0.3.16)
- we expect `dgoss` to run on a error, but want to see the usage information.

```yaml
file:
  /usr/bin/goss:
    exists: true
    filetype: file
  /usr/bin/dgoss:
    exists: true
    filetype: file
command:
  goss:
    exit-status: 0
    exec: "goss -v"
    stdout:
      - goss version v0.3.16
    stderr: []
    timeout: 10000 # in milliseconds
    skip: false
  dgoss:
    exit-status: 1
    exec: "dgoss"
    stdout: []
    stderr:
      - USAGE
    timeout: 10000 # in milliseconds
    skip: false
```
Yep, that's it.
If you don't believe me, have a look [here](https://gitlab.com/tcwlab.com/saas/baseline/images/dgoss/-/blob/main/goss/goss.yaml).

## Roadmap
If you are interested in the upcoming/planned features, ideas and milestones,
please have a look at our [board](https://gitlab.com/tcwlab.com/saas/baseline/images/dgoss/-/boards).

## License
This project is licensed under [Apache License v2](./LICENSE).

## Project status
This project is maintained "best effort", which means, we strive for automation as much as we can
A lot of updates will be done "automagically".

We do **not** have a specific dedicated set of people to work on this project.

It absolutely comes with **no warranty**.

[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Ftcwlab%2Fdgoss.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2Ftcwlab%2Fdgoss?ref=badge_large)
