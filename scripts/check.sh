#!/bin/bash

# Base URL for Chromium snapshots
CHROMIUM_SNAPSHOT_BASE_URL="https://www.googleapis.com/download/storage/v1/b/chromium-browser"

# Arrays for trunks
TRUNKS=("continuous" "snapshots")

# Define architectures for each trunk type manually
CONTINUOUS_ARCHS=("Mac" "Linux" "Linux_x64")
SNAPSHOTS_ARCHS=("Mac" "Mac_Arm" "Linux" "Linux_x64" "Arm")

# Function to check URL and SNAPSHOT_ZIP_URL
check_url() {
  local BASE_URL=$1
  local CHROMIUM_PLATFORM=$2
  local CHROMIUM_REVISION=$(curl --fail -sL "${BASE_URL}%2FLAST_CHANGE?alt=media")

  if test -z "$CHROMIUM_REVISION"; then
    echo "[KO] Latest Version File: $BASE_URL CHROMIUM_REVISION: '$CHROMIUM_REVISION'"
  else
    echo "[OK] Latest Version File: $BASE_URL CHROMIUM_REVISION: '$CHROMIUM_REVISION'"
    local SNAPSHOT_ZIP_URL="${BASE_URL}%2F${CHROMIUM_REVISION}%2Fchrome-${CHROMIUM_PLATFORM}.zip?alt=media"
    # Optionally, check if the SNAPSHOT_ZIP_URL exists
    if curl --fail -s -I "$SNAPSHOT_ZIP_URL" > /dev/null; then
      echo "[OK] SNAPSHOT ZIP Available: $SNAPSHOT_ZIP_URL"
    else
      echo "[KO] SNAPSHOT ZIP Not available: $SNAPSHOT_ZIP_URL"
    fi
  fi
}

# Loop through each trunk
for CHROMIUM_TRUNK in "${TRUNKS[@]}"; do
  echo "Checking trunk: $CHROMIUM_TRUNK"

  # Determine which set of architectures to use based on trunk
  if [ "$CHROMIUM_TRUNK" == "continuous" ]; then
    ARCHS=("${CONTINUOUS_ARCHS[@]}")
  elif [ "$CHROMIUM_TRUNK" == "snapshots" ]; then
    ARCHS=("${SNAPSHOTS_ARCHS[@]}")
  fi

  # Loop through each architecture for the current trunk
  for CHROMIUM_ARCH in "${ARCHS[@]}"; do
    # Determine CHROMIUM_PLATFORM based on CHROMIUM_ARCH
    if [[ "$CHROMIUM_ARCH" == "Linux" || "$CHROMIUM_ARCH" == "Linux_x64" || "$CHROMIUM_ARCH" == "Arm" ]]; then
      CHROMIUM_PLATFORM="linux"
    elif [[ "$CHROMIUM_ARCH" == "Mac" || "$CHROMIUM_ARCH" == "Mac_Arm" ]]; then
      CHROMIUM_PLATFORM="mac"
    fi

    # Construct the URL
    URL="${CHROMIUM_SNAPSHOT_BASE_URL}-${CHROMIUM_TRUNK}/o/${CHROMIUM_ARCH}"

    # Check the URL and SNAPSHOT_ZIP_URL
    check_url "$URL" "$CHROMIUM_PLATFORM"
  done
done
