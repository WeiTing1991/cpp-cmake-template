#!/usr/bin/env bash

set -e
PRESET="debug"
CLEAN=false
FORMAT=false
TIDY=false

for arg in "$@"; do
    case $arg in
        --clean)  CLEAN=true ;;
        --format) FORMAT=true ;;
        --tidy)   TIDY=true ;;
        debug|release) PRESET=$arg ;;
    esac
done

if [ "$CLEAN" = true ]; then
    echo "Cleaning build..."
    rm -rf build/
fi

if [ "$FORMAT" = true ]; then
    echo "Formatting..."
    find src include tests -name "*.cpp" -o -name "*.h" | xargs clang-format -i
fi

if [ "$TIDY" = true ]; then
    echo "Running clang-tidy..."
    find src include tests -name "*.cpp" | xargs clang-tidy \
        --config-file=.clang-tidy \
        -p build/$PRESET
fi

cmake --preset "$PRESET"
cmake --build --preset "$PRESET"
