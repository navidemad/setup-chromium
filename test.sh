#!/usr/bin/env bash

platforms=("ubuntu") # For multiple items: ("item1" "item2")
trunks=("snapshots")

for trunk in "${trunks[@]}"; do
  for platform in "${platforms[@]}"; do
    echo "Running job for trunk: $trunk on platform: $platform"
    act_image_modified="navidemad/setup-chromium-act-images:$platform-latest"
    act --job local --bind --env chromium_trunk="$trunk" --env act_image_modified="$platform-latest" --platform "$platform-latest=$act_image_modified" --container-architecture linux/amd64
    # act --verbose --job local --bind --env chromium_trunk="$trunk" --env act_image_modified="$platform-latest" --platform "$platform-latest=$act_image_modified" --container-architecture linux/amd64
  done
done
