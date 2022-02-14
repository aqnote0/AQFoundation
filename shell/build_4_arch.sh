#!/bin/bash

echo "shell build dir: " ${BUILD_DIR}
# if [ ${CONFIGURATION} == "Debug" ] || [ ${archiveCheck} != "" ]; then
#   echo "debug, nothing to build"
#   exit
# fi

FRAMEWORK_NAME="AQFoundation"
SCHEME="AQFoundation"
PRODUCT_DIR="Products"
WORKSPACE="AQFoundation.xcworkspace"
FRAMEWORK_CONFIG="${CONFIGURATION}"
BUILD_ARCHS="${BUILD_ARCHS}"

echo "Var WORKSPACE: " ${WORKSPACE}
echo "Var FRAMEWORK_CONFIG: " ${FRAMEWORK_CONFIG}
echo "Var SCHEME: " ${SCHEME}
echo "Var BUILD_ARCHS: " ${BUILD_ARCHS}

rm -rf ${BUILD_DIR}/DerivedData

# xcodebuild clean build -workspace ${WORKSPACE} -configuration "${FRAMEWORK_CONFIG}" -scheme "${SCHEME}" -sdk iphoneos ${BUILD_ARCHS}
xcodebuild build -workspace ${WORKSPACE} -configuration "${FRAMEWORK_CONFIG}" -scheme "${SCHEME}" -sdk iphonesimulator -destination 'name=iPhone 12'

DEVICE_FRAMEWORK=${BUILD_DIR}/Release-iphoneos/${FRAMEWORK_NAME}.framework
SIMULATOR_FRAMEWORK=${BUILD_DIR}/Release-iphonesimulator/${FRAMEWORK_NAME}.framework

rm -rf ${PRODUCT_DIR}
mkdir ${PRODUCT_DIR}

cp -r "${SIMULATOR_FRAMEWORK}" "${PRODUCT_DIR}"
# rm -f "${PRODUCT_DIR}/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}"

# echo "create fat binary(x86+arm)."
# lipo -create "${DEVICE_FRAMEWORK}/${FRAMEWORK_NAME}" "${SIMULATOR_FRAMEWORK}/${FRAMEWORK_NAME}" -output "${PRODUCT_DIR}/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}"

echo "Clean temporary files."
find $PRODUCT_DIR -depth 1 | grep "Debug\|Release" | xargs rm -rf

echo "BUILD FINISH."
