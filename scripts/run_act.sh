#!/usr/bin/env bash

act_image_modified="navidemad/setup-chromium-act-images:ubuntu-latest"
act --verbose --job local --bind --env chromium_trunk='snapshots' --env act_image_modified="$act_image_modified" --platform "ubuntu-22.04=$act_image_modified" --container-architecture linux/arm64

# trunks=("continuous")
# platforms=("catthehacker/ubuntu:full-latest")
# for trunk in "${trunks[@]}"; do
#   for platform in "${platforms[@]}"; do
#     echo "Running job for trunk: $trunk on platform: $platform"
#     ACT_PLATFORM="$platform" act -j local -P --env TRUNK="$trunk" --env PLATFORM="$platform" --container-architecture linux/arm64
#   done


# nektos/act-environments-ubuntu:22.04

# trunks=("continuous")
# platforms=("catthehacker/ubuntu:full-latest")
# for trunk in "${trunks[@]}"; do
#   for platform in "${platforms[@]}"; do
#     echo "Running job for trunk: $trunk on platform: $platform"
#     ACT_PLATFORM="$platform" act -j local -P --env TRUNK="$trunk" --env PLATFORM="$platform" --container-architecture linux/arm64
#   done
# done
