FROM ghcr.io/actions/actions-runner:2.325.0

ARG TARGETARCH
ARG TARGETOS=linux

USER root

RUN set -e; \
  apt-get update; \
  apt-get install -y buildah podman; \
  rm -rf /var/lib/apt/lists/*

USER runner
