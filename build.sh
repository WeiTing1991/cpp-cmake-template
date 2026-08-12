#!/usr/bin/env bash

set -e
PRESET="Debug"
CLEAN=false
FORMAT=false
TIDY=false

for arg in "$@"; do
    case $arg in
        --clean)  CLEAN=true ;;
        --format) FORMAT=true ;;
        --tidy)   TIDY=true ;;
        Debug|Release) PRESET=$arg ;;
    esac
done

BUILD_TYPE=$([ "$PRESET" = "Release" ] && echo "Release" || echo "Debug")

if [ "$CLEAN" = true ]; then
    echo "Cleaning build..."
    rm -rf build/
    rm -f CMakeUserPresets.json ConanPresets.json conan_toolchain.cmake
fi

if [ "$FORMAT" = true ]; then
    echo "Formatting..."
    find Src tests -name "*.cpp" -o -name "*.h" | xargs clang-format -i
fi

if [ "$TIDY" = true ]; then
    echo "Running clang-tidy..."
    find Src tests -name "*.cpp" | xargs clang-tidy \
        --config-file=.clang-tidy \
        -p build/$PRESET
fi

conan install . \
  --output-folder=build/$PRESET \
  --build=missing \
  -s build_type=$BUILD_TYPE

cmake --preset "$PRESET"
cmake --build --preset "$PRESET"
