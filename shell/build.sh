#!/bin/bash

export FRAMEWORK_NAME="AQFoundation"

xcodebuild -scheme _build -sdk iphoneos -workspace $FRAMEWORK_NAME.xcworkspace -configuration Release clean build
sleep 3

echo "before trip, the flag list: "
nm Products/$FRAMEWORK_NAME.framework/$FRAMEWORK_NAME
echo "=================================================="
sleep 3

strip -x Products/$FRAMEWORK_NAME.framework/$FRAMEWORK_NAME
echo "after trip, the flag list: "
nm Products/$FRAMEWORK_NAME.framework/$FRAMEWORK_NAME
echo "=================================================="
sleep 3

echo "check the Framework Arch. count"
lipo -info Products/$FRAMEWORK_NAME.framework/$FRAMEWORK_NAME


exit 0

