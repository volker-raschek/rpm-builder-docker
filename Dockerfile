FROM docker.io/library/rust:1.92.0-slim-bullseye AS build

ARG RPMBUILDER_VERSION=master

# install dependencies
RUN set -e && \
    apt-get update --yes && \
    apt-get install --yes curl git make

# compile musl and rpm-builder
RUN set -e && \
    git clone -b rpm-builder-${RPMBUILDER_VERSION} https://github.com/rpm-rs/rpm-builder.git /rpm-builder && \
    cd /rpm-builder && \
    cargo build --profile release

FROM docker.io/library/debian:buster-slim

COPY --from=build /rpm-builder/target/release/rpm-builder /usr/bin/rpm-builder

ENTRYPOINT [ "/usr/bin/rpm-builder" ]