#!/usr/bin/env bash

set -eo pipefail
#set -x

BASE_DIR=$(cd "$(dirname "$0")""/.."; pwd -P)
PODS_DIR="$BASE_DIR/Pods"
TEMP_DIR="$BASE_DIR/Temp"
ARCHIVE_PATH="$TEMP_DIR/Archive-sim.xcarchive"
FRAMEWORK_DIR="$TEMP_DIR/Framework"

fix7672() {
  VERSION=$(grep -Eo 'RealmSwift \(\d+\.\d+\.\d+\)' "$BASE_DIR/Podfile.lock" | grep -Eo '\d+\.\d+\.\d+')
  MINOR_VERSION=$(echo "$VERSION" | cut -d'.' -f2)
  if [ "$MINOR_VERSION" -le 20 ] || [ "$MINOR_VERSION" -ge 23 ]; then
    echo "#7672 fix is not needed for RealmSwift $VERSION"
    return 0
  fi

  echo "Applying #7672 fix for RealmSwift $VERSION"
  TARGET_PATH="$PODS_DIR/RealmSwift/RealmSwift/Impl/Persistable.swift"
  chmod u+w "$TARGET_PATH"
  CONTENT1=$(cat "$TARGET_PATH")
  RESULT="${CONTENT1:0:1967}, PersistedType.PersistedType.PersistedType == PersistedType.PersistedType${CONTENT1:1967}"
  echo "$RESULT" > "$TARGET_PATH"
}

rm -rf "$TEMP_DIR"
rm -rf "$PODS_DIR"
export FRAMEWORK_BUILD=1
pod install
fix7672

xcodebuild archive -workspace "CocoaPodsExample.xcworkspace" -scheme "CocoaPodsExample" \
  -destination "generic/platform=iOS Simulator" -archivePath "$ARCHIVE_PATH" \
    | xcpretty

xcodebuild -create-xcframework \
  -framework "$ARCHIVE_PATH/Products/Library/Frameworks/XCF.framework" \
  -output "$FRAMEWORK_DIR/XCF.xcframework" \
    | xcpretty

cp -R "$BASE_DIR/XCF/XCF.podspec" "$FRAMEWORK_DIR/XCF.podspec"
rm -rf "$PODS_DIR"
unset FRAMEWORK_BUILD
pod install
fix7672
