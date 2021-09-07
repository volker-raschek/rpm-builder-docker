FROM docker.io/library/rust:1.54.0-alpine3.13 AS build

ARG RPMBUILDER_VERSION=master
ARG MUSL_VERSION=1.2.0

# install dependencies
RUN apk update && \
    apk add curl git make musl-dev

# compile rpm-builder
RUN git clone https://github.com/Richterrettich/rpm-builder.git && \
    cd rpm-builder && \
    git checkout ${RPMBUILDER_VERSION} && \
    make build_linux && echo $PWD

FROM docker.io/library/alpine:3.14.2

COPY --from=build /rpm-builder/target/x86_64-unknown-linux-musl/release/rpm-builder /usr/bin/rpm-builder

ENTRYPOINT [ "/usr/bin/rpm-builder" ]