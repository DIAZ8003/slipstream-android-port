set(ANDROID_ABI "arm64-v8a")
set(ANDROID_PLATFORM "android-24")
set(CMAKE_SYSTEM_NAME Android)
set(CMAKE_SYSTEM_VERSION 24)
set(CMAKE_ANDROID_NDK "$ENV{ANDROID_NDK_HOME}")
set(CMAKE_ANDROID_STL_TYPE c++_static)

# Compiladores LLVM del NDK
set(CMAKE_C_COMPILER "${CMAKE_ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android24-clang")
set(CMAKE_CXX_COMPILER "${CMAKE_ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android24-clang++")

set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
