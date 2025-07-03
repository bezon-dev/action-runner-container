#!/usr/bin/env sh

# on arm64: docker run --privileged --rm tonistiigi/binfmt --install all
# on amd64: docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
# docker buildx create --name multiarch --driver docker-container --use
# docker buildx inspect --bootstrap

REGISTRY_NAME=ghcr.io/bezon-dev
IMAGE_NAME=action-runner-container/action-runner-container

docker buildx build \
  . \
  -t ${REGISTRY_NAME}/${IMAGE_NAME}:latest \
  --platform=linux/arm64,linux/amd64 "${@}"

  # --push \
  # --no-cache --pull \

