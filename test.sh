#!/usr/bin/env bash

platforms=("ubuntu") # For multiple items: ("item1" "item2")
trunks=("continuous")

for trunk in "${trunks[@]}"; do
  for platform in "${platforms[@]}"; do
    echo "Running job for trunk: $trunk on platform: $platform"
    act_image_modified="navidemad/setup-chromium-act-images:$platform-latest"
    act --job act --bind --env chromium_trunk="$trunk" --env act_image_modified="$platform-latest" --platform "$platform-latest=$act_image_modified" --container-architecture linux/amd64
    # act --verbose --job act --bind --env chromium_trunk="$trunk" --env act_image_modified="$platform-latest" --platform "$platform-latest=$act_image_modified" --container-architecture linux/amd64
  done
done


act --job act --bind --env chromium_trunk="continuous" --env act_image_modified="ubuntu-latest" --platform "ubuntu-latest=ghcr.io/catthehacker/ubuntu:act-latest" --container-architecture linux/amd64

docker build -f dockerfiles/Dockerfile.ubuntu --build-arg ACT_IMAGE="ghcr.io/catthehacker/ubuntu:act-latest" --tag "${{ secrets.DOCKER_USERNAME }}/setup-chromium-act-images:ubuntu-latest" --no-cache .
