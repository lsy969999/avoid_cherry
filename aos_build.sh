#!/usr/bin/env bash

# Stop subsequent execution when encountering any errors
set -e

RELEASE_MODE=${1}
LIB_FOLDER="debug"

# build to Android target
if [ "${RELEASE_MODE}" = "--release" ]; then
    LIB_FOLDER="release"
    cargo so b --lib --target aarch64-linux-android ${RELEASE_MODE}
else
    RUST_BACKTRACE=full RUST_LOG=wgpu_hal=debug cargo so b --lib --target aarch64-linux-android
fi

# copy .so files to jniLibs folder
ARM64="aos/app/src/main/jniLibs/arm64-v8a"
ARMv7a="aos/app/src/main/jniLibs/armeabi-v7a"

if [ ! -d "$ARM64" ]; then
    mkdir "$ARM64"
fi
if [ ! -d "$ARMv7a" ]; then
    mkdir "$ARMv7a"
fi

cp target/aarch64-linux-android/${LIB_FOLDER}/libavoid_cherry.so "${ARM64}/libavoid_cherry.so"