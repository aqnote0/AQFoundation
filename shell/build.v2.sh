#!/bin/bash

echo "shell build dir: " ${BUILD_DIR}
# if [ ${CONFIGURATION} == "Debug" ] || [ ${archiveCheck} != "" ]; then
#   echo "debug, nothing to build"
#   exit
# fi

FRAMEWORK_NAME="AQFoundation"
PRODUCT_DIR="Products"
BUILD_DIR=./DerivedData/${FRAMEWORK_NAME}/Build/Products

rm -rf ${BUILD_DIR}/DerivedData

xcodebuild clean build -workspace AQFoundation.xcworkspace -configuration Release -scheme AQFoundation -sdk iphonesimulator -destination 'name=iPhone 12'

SIMULATOR_FRAMEWORK=${BUILD_DIR}/Release-iphonesimulator/${FRAMEWORK_NAME}.framework

rm -rf ${PRODUCT_DIR}
mkdir ${PRODUCT_DIR}

cp -r "${SIMULATOR_FRAMEWORK}" "${PRODUCT_DIR}"

echo "Clean temporary files."
find $PRODUCT_DIR -depth 1 | grep "Debug\|Release" | xargs rm -rf

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


