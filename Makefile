# RPMBUILDER_VERSION
# Only required to install a specifiy version
RPMBUILDER_VERSION?=v0.8.1 # renovate: datasource=github-releases depName=Richterrettich/rpm-builder

# CONTAINER_RUNTIME
# The CONTAINER_RUNTIME variable will be used to specified the path to a
# container runtime. This is needed to start and run a container image.
CONTAINER_RUNTIME?=$(shell which podman)

# RPMBUILDER_IMAGE_REGISTRY_NAME
# Defines the name of the new container to be built using several variables.
RPMBUILDER_IMAGE_REGISTRY_NAME:=docker.io
RPMBUILDER_IMAGE_REGISTRY_USER:=volkerraschek

RPMBUILDER_IMAGE_NAMESPACE?=${RPMBUILDER_IMAGE_REGISTRY_USER}
RPMBUILDER_IMAGE_NAME:=rpm-builder
RPMBUILDER_IMAGE_VERSION?=latest
RPMBUILDER_IMAGE_FULLY_QUALIFIED=${RPMBUILDER_IMAGE_REGISTRY_NAME}/${RPMBUILDER_IMAGE_NAMESPACE}/${RPMBUILDER_IMAGE_NAME}:${RPMBUILDER_IMAGE_VERSION}
RPMBUILDER_IMAGE_UNQUALIFIED=${RPMBUILDER_IMAGE_NAMESPACE}/${RPMBUILDER_IMAGE_NAME}:${RPMBUILDER_IMAGE_VERSION}

# BUILD CONTAINER IMAGE
# ==============================================================================
PHONY:=container-image/build
container-image/build:
	${CONTAINER_RUNTIME} build \
		--build-arg RPMBUILDER_VERSION=${RPMBUILDER_VERSION} \
		--file Dockerfile \
		--no-cache \
		--pull \
		--tag ${RPMBUILDER_IMAGE_FULLY_QUALIFIED} \
		--tag ${RPMBUILDER_IMAGE_UNQUALIFIED} \
		.

# DELETE CONTAINER IMAGE
# ==============================================================================
PHONY:=container-image/delete
container-image/delete:
	- ${CONTAINER_RUNTIME} image rm ${RPMBUILDER_IMAGE_FULLY_QUALIFIED} ${RPMBUILDER_IMAGE_UNQUALIFIED}
	- ${CONTAINER_RUNTIME} image rm ${BASE_IMAGE_FULL}

# PUSH CONTAINER IMAGE
# ==============================================================================
PHONY+=container-image/push
container-image/push:
	echo ${RPMBUILDER_IMAGE_REGISTRY_PASSWORD} | ${CONTAINER_RUNTIME} login ${RPMBUILDER_IMAGE_REGISTRY_NAME} --username ${RPMBUILDER_IMAGE_REGISTRY_USER} --password-stdin
	${CONTAINER_RUNTIME} push ${RPMBUILDER_IMAGE_FULLY_QUALIFIED}

# PHONY
# ==============================================================================
# Declare the contents of the PHONY variable as phony.  We keep that information
# in a variable so we can use it in if_changed.
.PHONY: ${PHONY}