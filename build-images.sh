#!/usr/bin/env bash
# Do not edit by hand; please use build scripts/templates to make changes
set -eo pipefail

GOVERSION=1.22.12
CIRCLE_BRANCH_SANITIZED=${CIRCLE_BRANCH//\/}
DOCKERIMAGE=arangodboasis/cimg-go:${GOVERSION}-${CIRCLE_TAG:-$CIRCLE_BRANCH_SANITIZED-$CIRCLE_SHA1}
echo Building ${DOCKERIMAGE}

if [ "$1" = "latest" ]; then
    ~/regctl image copy ${DOCKERIMAGE} arangodboasis/cimg-go:${GOVERSION}-latest
else
    docker buildx install
    docker build \
        --build-arg CIMGBASETAG=${CIMGBASETAG} \
        --build-arg GO_VERSION=${GOVERSION} \
        --platform linux/amd64,linux/arm64 \
        --push \
        --file 1.22/Dockerfile \
        -t ${DOCKERIMAGE} .
fi
