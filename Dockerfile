FROM docker.io/library/rust:1.91.1-slim-bullseye AS build

ARG RPMBUILDER_VERSION=master

# install dependencies
RUN set -e && \
    apt-get update --yes && \
    apt-get install --yes curl git make

# compile musl and rpm-builder
RUN set -e && \
    git clone -b ${RPMBUILDER_VERSION} https://github.com/Richterrettich/rpm-builder.git /rpm-builder && \
    make --directory /rpm-builder build

FROM docker.io/library/debian:buster-slim

COPY --from=build /rpm-builder/target/release/rpm-builder /usr/bin/rpm-builder

ENTRYPOINT [ "/usr/bin/rpm-builder" ]