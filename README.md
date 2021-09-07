# rpm-builder-docker

[![Build Status](https://drone.cryptic.systems/api/badges/volker.raschek/rpm-builder-docker/status.svg)](https://drone.cryptic.systems/volker.raschek/rpm-builder-docker)
[![Docker Pulls](https://img.shields.io/docker/pulls/volkerraschek/rpm-builder)](https://hub.docker.com/r/volkerraschek/rpm-builder)

This project contains only build sources for the container image
`docker.io/volkerraschek/rpm-builder`. The upstream project ist hosted on
[github](https://github.com/Richterrettich/rpm-builder).

## Usage

Package an example application like `my-demo-application` via the following
example command.

```bash
$ docker run \
    --workdir /workspace \
    --volume ${PWD}/workspace:rw \
    --rm \
    volkerraschek/rpm-builder:latest \
      --arch=x86_64 \
      --epoch=0 \
      --version=0.1.0 \
      --release=1 \
      --license="Apache 2.0" \
      --name my-demo-application \
      --dir installDir:/ \
      --out /workspace/my-demo-application.rpm \
      .
```

You get on overview of all possible sub commands via `--help` or visit the
[documentation](https://github.com/Richterrettich/rpm-builder#additional-flags).

```bash
$ docker run \
    --rm \
    volkerraschek/rpm-builder:latest \
      --help
```
