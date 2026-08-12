# Conan Migration Design

## Overview

Migrate cpp-cmake-template from vcpkg to Conan, following the patterns established in the geometry-toolkit repo. Preserve the vcpkg setup on a `feature/vcpkg` branch.

## Branch Strategy

1. Create `feature/vcpkg` branch from current main — preserves vcpkg setup unchanged
2. On main: remove vcpkg, convert to Conan

## Conan Setup

Mirror geometry-toolkit's pattern exactly:

### conanfile.py

- Class: `CppCmakeTemplateRecipe`
- No runtime dependencies initially (template project)
- `gtest/1.17.0` for testing
- `tool_requires("cmake/[>=4.0]")`
- Generators: `CMakeToolchain` + `CMakeDeps`
- Presets output renamed to `ConanPresets.json` (prevents CLion auto-load conflicts)

### CMakePresets.json

- Version 4
- Includes `ConanPresets.json`
- Two configure presets: Debug and Release
  - Debug: inherits `conan-debug`, `BUILD_TESTS=ON`, `CMAKE_EXPORT_COMPILE_COMMANDS=ON`
  - Release: inherits `conan-release`, `BUILD_TESTS=OFF`
- Binary dirs: `${sourceDir}/build/Debug` and `${sourceDir}/build/Release`
- Two build presets: Debug and Release

### build.sh

Same pattern as geometry-toolkit:
- Args: `Debug` (default), `Release`
- Flags: `--clean`, `--format`, `--tidy`
- Steps: conan install -> cmake configure -> cmake build

### run_test.sh

- Runs ctest from the build directory

## CMakeLists.txt Changes

- CMake minimum: 4.0 (matching geometry-toolkit)
- C++ standard: 23
- Compile options: `-Wall -Wextra -Werror`
- Add `BUILD_TESTS` option (default ON)
- Output dirs: `${CMAKE_BINARY_DIR}/bin` and `${CMAKE_BINARY_DIR}/lib`
- Remove vcpkg toolchain references
- Keep `add_subdirectory(Src)` for the existing submodule library
- Add `tests/` subdirectory (conditional on `BUILD_TESTS`)

## macOS Support

Implicit via Conan + Ninja — no platform-specific presets needed. The Debug/Release presets work on all platforms (macOS, Linux, Windows). This replaces the old approach of separate Windows/Linux Ninja presets.

## Directory Structure (After Migration)

```
cpp-cmake-template/
  CMakeLists.txt          # Updated
  CMakePresets.json        # Rewritten (Conan-style)
  conanfile.py             # New
  build.sh                 # New
  run_test.sh              # New
  .clang-format            # Keep
  .clang-tidy              # New (from geometry-toolkit pattern)
  .clangd                  # New
  .editorconfig            # Keep
  .gitignore               # Updated
  LICENSE                  # Keep
  README.md                # Updated
  Src/
    CMakeLists.txt         # Keep
    main.cpp               # Keep
    submodule/             # Keep
  tests/                   # New (placeholder)
    CMakeLists.txt
```

## Files to Remove (from main)

- `vcpkg/` — full vcpkg clone (preserved on feature/vcpkg branch)
- `generate_compile_commands.bat` — replaced by build.sh
- `out/` — old build output

## .gitignore Updates

Remove:
- `vcpkg_installed/`, `.vcpkg-root`

Add:
- `build/`, `ConanPresets.json`, `CMakeUserPresets.json`
- Conan-generated cmake files (`*.cmake` except `CMakeLists.txt` and `CMakePresets.json`)
- Object files: `*.o`, `*.a`, `*.so`, `*.dylib`, `*.out`

## README.md

Update with:
- Prerequisites: CMake 4+, Conan 2+, Ninja, clang-format
- Build instructions using `build.sh`
- Manual build steps (conan install + cmake preset)
