#!/bin/sh
# remove existing product lib file, just in case
rm -rf build/${BUILD_STYLE}-iphoneos/UISpec_${BUILD_STYLE}.a

# combine lib files for various platforms into one
lipo -create "build/${BUILD_STYLE}-iphoneos/UISpec_Device.a" "build/${BUILD_STYLE}-iphonesimulator/UISpec_Simulator.a" -output build/${BUILD_STYLE}-iphoneos/UISpec_${BUILD_STYLE}.a
