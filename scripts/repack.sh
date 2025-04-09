#!/bin/bash
# SPDX-FileCopyrightText: spike0en
# SPDX-License-Identifier: MIT

set -e

echo "--- Running Pong Firmware Repacker Script ---"
echo

if [ -z "$POST_OTA_VERSION" ]; then
  echo "Error: POST_OTA_VERSION environment variable is not set."
  exit 1
fi
if [ -z "$NOS_VERSION" ]; then
  echo "Error: NOS_VERSION environment variable is not set."
  exit 1
fi
if [ -z "$BOOT_URL" ]; then
  echo "Error: BOOT_URL environment variable is not set."
  exit 1
fi
if [ -z "$FIRMWARE_URL" ]; then
  echo "Error: FIRMWARE_URL environment variable is not set."
  exit 1
fi

echo "POST OTA Version: $POST_OTA_VERSION"
echo "NOS Version: $NOS_VERSION"
echo "Boot URL: $BOOT_URL"
echo "Firmware URL: $FIRMWARE_URL"
echo

SCRIPT_DIR=$(pwd)
FIRMWARE_DIR="$SCRIPT_DIR/firmware-update"
TMP_DIR="$SCRIPT_DIR/tmp"
META_INF_DIR="$SCRIPT_DIR/META-INF"

echo "--- Preparing Required Directories ---"

if [ -d "$FIRMWARE_DIR" ]; then
    echo "Deleting existing firmware-update directory..."
    rm -rf "$FIRMWARE_DIR"
fi
mkdir -p "$FIRMWARE_DIR"
echo "firmware-update directory prepared successfully."

if [ -d "$TMP_DIR" ]; then
    echo "Deleting existing tmp directory..."
    rm -rf "$TMP_DIR"
fi
mkdir -p "$TMP_DIR"
echo "Temporary directory prepared successfully."
echo

if [ ! -d "$META_INF_DIR" ] || [ ! -f "$META_INF_DIR/com/google/android/update-binary" ] || [ ! -f "$META_INF_DIR/com/google/android/updater-script" ]; then
    echo "Error: META-INF directory or its contents not found in the repository root."
    echo "Please ensure META-INF/com/google/android/update-binary and updater-script exist."
    exit 1
fi
echo "META-INF directory found."
echo

echo "--- Downloading Firmware Files ---"

echo "Downloading boot category file (-image-boot.7z) from provided URL (Source: spike0en/nothing_archive)..."
aria2c -x5 -d "$TMP_DIR" -o "boot.7z" "$BOOT_URL"
if [ $? -ne 0 ] || [ ! -f "$TMP_DIR/boot.7z" ]; then
    echo "Failed to download boot category file using aria2c. Exiting..."
    exit 1
fi
echo "Boot category file downloaded successfully."

echo "Downloading firmware category file (-image-firmware.7z) from provided URL (Source: spike0en/nothing_archive)..."
aria2c -x5 -d "$TMP_DIR" -o "firmware.7z" "$FIRMWARE_URL"
if [ $? -ne 0 ] || [ ! -f "$TMP_DIR/firmware.7z" ]; then
    echo "Failed to download firmware category file using aria2c. Exiting..."
    exit 1
fi
echo "Firmware category file downloaded successfully."
echo

echo "--- Extracting Downloaded Files ---"

echo "Extracting boot file..."
7z x "$TMP_DIR/boot.7z" -o"$TMP_DIR" -y > /dev/null
if [ $? -ne 0 ]; then
    echo "Failed to extract boot file. Exiting..."
    exit 1
fi
echo "Boot file extracted successfully."

echo "Extracting firmware file..."
7z x "$TMP_DIR/firmware.7z" -o"$TMP_DIR" -y > /dev/null
if [ $? -ne 0 ]; then
    echo "Failed to extract firmware file. Exiting..."
    exit 1
fi
echo "Firmware file extracted successfully."
echo

echo "--- Removing recovery and vbmeta Image Files ---"

RECOVERY_IMG="$TMP_DIR/recovery.img"
VBMETA_IMG="$TMP_DIR/vbmeta.img"

if [ -f "$RECOVERY_IMG" ]; then
    rm "$RECOVERY_IMG"
    echo "recovery.img removed successfully."
else
    echo "recovery.img not found, skipping removal."
fi

if [ -f "$VBMETA_IMG" ]; then
    rm "$VBMETA_IMG"
    echo "vbmeta.img removed successfully."
else
    echo "vbmeta.img not found, skipping removal."
fi
echo

echo "--- Moving Files to firmware-update fir ---"

mv "$TMP_DIR"/*.img "$FIRMWARE_DIR/"
if [ $? -ne 0 ]; then
    echo "Failed to move image files. Exiting..."
    exit 1
fi
echo "Image files moved successfully."

rm -rf "$TMP_DIR"
echo "Temporary folder cleaned up."
echo

echo "--- Creating Flashable Firmware ZIP Package ---"

ZIP_NAME="FW_${POST_OTA_VERSION}_${NOS_VERSION}.zip"
echo "Creating zip file: $ZIP_NAME"
cd "$SCRIPT_DIR"
7z a -tzip -mx=6 "$ZIP_NAME" firmware-update/ META-INF/

if [ $? -ne 0 ]; then
    echo "Failed to create zip file. Exiting..."
    exit 1
fi

echo
echo "--- Firmware Package Successfully Created ---"
echo "Firmware update files have been compressed and saved as $ZIP_NAME."
echo "Output zip file path: $SCRIPT_DIR/$ZIP_NAME"

# Output the zip name for the workflow
echo "zip_name=$ZIP_NAME" >> $GITHUB_OUTPUT