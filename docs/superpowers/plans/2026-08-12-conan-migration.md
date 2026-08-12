# Conan Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Migrate cpp-cmake-template from vcpkg to Conan, preserving the vcpkg setup on a backup branch.

**Architecture:** Create a `feature/vcpkg` branch to preserve current state, then on main: remove vcpkg, add `conanfile.py` with `CMakeToolchain`+`CMakeDeps` generators, rewrite `CMakePresets.json` to inherit from Conan-generated presets, add build/test scripts, and update all config files to match geometry-toolkit patterns.

**Tech Stack:** CMake 4.0+, Conan 2, Ninja, C++23, GoogleTest, clang-format, clang-tidy

## Global Constraints

- Follow geometry-toolkit patterns exactly (at `/Users/weitingchen/project/code-toolkit/geometry-toolkit/`)
- C++23 standard, CMake minimum 4.0
- Conan presets output to `ConanPresets.json` (not default `CMakeUserPresets.json`)
- No platform-specific presets — Debug/Release work cross-platform via Conan
- Keep existing `Src/` directory structure and submodule library unchanged

---

### Task 1: Create feature/vcpkg backup branch

**Files:**
- No file changes — git branch operation only

**Interfaces:**
- Consumes: current main branch state
- Produces: `feature/vcpkg` branch preserving vcpkg setup

- [ ] **Step 1: Create the backup branch from current main**

```bash
cd /Users/weitingchen/project/cpp-cmake-template
git branch feature/vcpkg
```

- [ ] **Step 2: Verify the branch exists**

```bash
git branch --list feature/vcpkg
```

Expected: `feature/vcpkg` appears in output.

- [ ] **Step 3: Stay on main and commit**

No commit needed — branch creation doesn't modify working tree.

---

### Task 2: Remove vcpkg and old build artifacts from main

**Files:**
- Remove: `vcpkg/` (entire directory)
- Remove: `generate_compile_commands.bat`
- Remove: `out/` (old build output)

**Interfaces:**
- Consumes: `feature/vcpkg` branch exists as backup
- Produces: clean main branch without vcpkg files

- [ ] **Step 1: Remove vcpkg directory, bat script, and out directory**

```bash
git rm -r vcpkg/
git rm generate_compile_commands.bat
rm -rf out/
```

Note: `out/` is gitignored so just `rm -rf`. `vcpkg/` is untracked (shown in git status as `??`), so use `rm -rf vcpkg/` if `git rm` fails.

- [ ] **Step 2: Commit the removal**

```bash
git add -A
git commit -m "remove vcpkg and old build files

Preserved on feature/vcpkg branch."
```

---

### Task 3: Add Conan and CMake configuration

**Files:**
- Create: `conanfile.py`
- Rewrite: `CMakePresets.json`
- Modify: `CMakeLists.txt`
- Modify: `Src/submodule/CMakeLists.txt` (bump cxx_std_20 to cxx_std_23)

**Interfaces:**
- Consumes: clean main from Task 2
- Produces: working Conan + CMake build system

- [ ] **Step 1: Create conanfile.py**

Create `/Users/weitingchen/project/cpp-cmake-template/conanfile.py`:

```python
from conan import ConanFile
from conan.tools.cmake import CMakeToolchain, CMakeDeps


class CppCmakeTemplateRecipe(ConanFile):
    name = "cpp-cmake-template"
    settings = "os", "compiler", "build_type", "arch"

    def requirements(self):
        # Testing
        self.requires("gtest/1.17.0")

    def build_requirements(self):
        self.tool_requires("cmake/[>=4.0]")

    def generate(self):
        tc = CMakeToolchain(self)
        tc.user_presets_path = "ConanPresets.json"
        tc.generate()
        deps = CMakeDeps(self)
        deps.generate()
```

- [ ] **Step 2: Rewrite CMakePresets.json**

Replace `/Users/weitingchen/project/cpp-cmake-template/CMakePresets.json` with:

```json
{
  "version": 4,
  "include": ["ConanPresets.json"],
  "configurePresets": [
    {
      "name": "Debug",
      "inherits": "conan-debug",
      "binaryDir": "${sourceDir}/build/Debug",
      "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Debug",
        "BUILD_TESTS": "ON",
        "CMAKE_EXPORT_COMPILE_COMMANDS": "ON"
      }
    },
    {
      "name": "Release",
      "inherits": "conan-release",
      "binaryDir": "${sourceDir}/build/Release",
      "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Release",
        "BUILD_TESTS": "OFF"
      }
    }
  ],
  "buildPresets": [
    { "name": "Debug",   "configurePreset": "Debug" },
    { "name": "Release", "configurePreset": "Release" }
  ]
}
```

- [ ] **Step 3: Rewrite root CMakeLists.txt**

Replace `/Users/weitingchen/project/cpp-cmake-template/CMakeLists.txt` with:

```cmake
cmake_minimum_required(VERSION 4.0)

project(CppCmakeTemplate)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
add_compile_options(-Wall -Wextra -Werror)

option(BUILD_TESTS "Build tests" ON)

add_subdirectory(Src)

if(BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()
```

- [ ] **Step 4: Update Src/submodule/CMakeLists.txt — bump C++ standard to 23**

Change line 26 in `/Users/weitingchen/project/cpp-cmake-template/Src/submodule/CMakeLists.txt`:

```cmake
# Change:
target_compile_features(submodule_lib PUBLIC cxx_std_20)
# To:
target_compile_features(submodule_lib PUBLIC cxx_std_23)
```

- [ ] **Step 5: Commit**

```bash
git add conanfile.py CMakePresets.json CMakeLists.txt Src/submodule/CMakeLists.txt
git commit -m "add Conan build system with CMake 4.0 and C++23

- conanfile.py with gtest dependency
- CMakePresets.json inheriting from Conan-generated presets
- Debug/Release presets work cross-platform (macOS, Linux, Windows)"
```

---

### Task 4: Add test scaffold and build scripts

**Files:**
- Create: `tests/CMakeLists.txt`
- Create: `build.sh`
- Create: `run_test.sh`

**Interfaces:**
- Consumes: Conan + CMake config from Task 3
- Produces: build/test scripts matching geometry-toolkit, placeholder test directory

- [ ] **Step 1: Create tests/CMakeLists.txt**

Create `/Users/weitingchen/project/cpp-cmake-template/tests/CMakeLists.txt`:

```cmake
find_package(GTest REQUIRED)

add_executable(template_tests
        test_module.cpp
)

target_link_libraries(template_tests
        PRIVATE
        submodule_lib
        GTest::gtest_main
)

include(GoogleTest)
gtest_discover_tests(template_tests)
```

- [ ] **Step 2: Create a minimal test file**

Create `/Users/weitingchen/project/cpp-cmake-template/tests/test_module.cpp`:

```cpp
#include <gtest/gtest.h>

#include "module.h"

TEST(ModuleTest, Add) {
    Module module;
    EXPECT_EQ(module.add(2, 3), 5);
}

TEST(ModuleTest, GetMessage) {
    Module module;
    EXPECT_FALSE(module.getMessage().empty());
}
```

- [ ] **Step 3: Create build.sh**

Create `/Users/weitingchen/project/cpp-cmake-template/build.sh`:

```bash
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
```

- [ ] **Step 4: Create run_test.sh**

Create `/Users/weitingchen/project/cpp-cmake-template/run_test.sh`:

```bash
#!/usr/bin/env bash

cd build/Debug
ctest --output-on-failure

cd ../..
```

- [ ] **Step 5: Make scripts executable**

```bash
chmod +x build.sh run_test.sh
```

- [ ] **Step 6: Commit**

```bash
git add tests/ build.sh run_test.sh
git commit -m "add test scaffold and build/test scripts

- tests/test_module.cpp with basic module tests
- build.sh with --clean, --format, --tidy flags
- run_test.sh for running ctest"
```

---

### Task 5: Update config files (.gitignore, .clang-tidy, .clangd, README)

**Files:**
- Rewrite: `.gitignore`
- Create: `.clang-tidy`
- Create: `.clangd`
- Rewrite: `README.md`

**Interfaces:**
- Consumes: complete build system from Tasks 3-4
- Produces: updated project config matching geometry-toolkit patterns

- [ ] **Step 1: Rewrite .gitignore**

Replace `/Users/weitingchen/project/cpp-cmake-template/.gitignore` with:

```gitignore
# Build directories
/build/
build/

# CMake generated files
CMakeFiles/
CMakeCache.txt
cmake_install.cmake
Makefile
*.cmake
!CMakeLists.txt
!CMakePresets.json

# Conan generated files
CMakeUserPresets.json
ConanPresets.json

# Compiled binaries and objects
*.o
*.a
*.so
*.dylib
*.out
*.obj
*.exe
*.dll
*.lib
*.pdb

# IDE
.vs/
.idea/
.vscode/settings.json
.vscode/c_cpp_properties.json
*.user
*.suo
*.sln.docstates

# System
.DS_Store

# Other
.cache
temp/
```

- [ ] **Step 2: Create .clang-tidy**

Create `/Users/weitingchen/project/cpp-cmake-template/.clang-tidy`:

```yaml
Checks: >
  clang-diagnostic-*,
  clang-analyzer-*,
  cppcoreguidelines-*,
  modernize-*,
  -modernize-use-trailing-return-type,
  readability-*
WarningsAsErrors: '*'
```

- [ ] **Step 3: Create .clangd**

Create `/Users/weitingchen/project/cpp-cmake-template/.clangd`:

```yaml
CompileFlags:
  Add: [-std=c++23]
  CompilationDatabase: build/Debug
```

- [ ] **Step 4: Rewrite README.md**

Replace `/Users/weitingchen/project/cpp-cmake-template/README.md` with:

```markdown
# Cpp CMake Project Template

Simple CMake project template for C++, supports macOS, Linux, and Windows.

## Tech Stack

- Package Manager: Conan
- Language: C++23
- Build: CMake 4+, Ninja
- Static analysis & formatting: clang-format, clang-tidy

## Prerequisites

- CMake 4+
- Conan 2+
- Ninja
- clang-format
- clang-tidy (optional)

## Setup

```sh
brew install conan   # macOS
conan profile detect
```

## Build

```sh
./build.sh           # Debug (default)
./build.sh Release   # Release
./build.sh --clean   # Clean build
./build.sh --format  # Format code
./build.sh --tidy    # Run clang-tidy
```

### Manual build

```sh
conan install . --output-folder=build/Debug --build=missing -s build_type=Debug
cmake --preset Debug
cmake --build --preset Debug
```

## Test

```sh
./run_test.sh
```

## TODO

- [ ] add github action with build and formatter
```

- [ ] **Step 5: Commit**

```bash
git add .gitignore .clang-tidy .clangd README.md
git commit -m "update config files for Conan build system

- .gitignore for Conan/CMake artifacts
- .clang-tidy and .clangd matching geometry-toolkit
- README with Conan build instructions"
```

---

### Task 6: Verify the build works

**Files:**
- No file changes — verification only

**Interfaces:**
- Consumes: complete project from Tasks 1-5
- Produces: confirmation that the build and tests pass

- [ ] **Step 1: Clean and build**

```bash
cd /Users/weitingchen/project/cpp-cmake-template
./build.sh --clean Debug
```

Expected: Conan installs gtest, CMake configures, Ninja builds successfully.

- [ ] **Step 2: Run tests**

```bash
./run_test.sh
```

Expected: `template_tests` runs, both `ModuleTest.Add` and `ModuleTest.GetMessage` pass.

- [ ] **Step 3: Verify the binary runs**

```bash
./build/Debug/bin/CppCmakeTemplate
```

Expected: prints "Hello, World!" and module output.

- [ ] **Step 4: Fix any issues and commit if needed**

If any build or test failures occur, fix and commit with a descriptive message.
