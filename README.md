# Cpp CMake Project Template

![C++23](https://img.shields.io/badge/C%2B%2B-23-blue?logo=cplusplus)
![CMake](https://img.shields.io/badge/CMake-4%2B-blue?logo=cmake)
![Conan](https://img.shields.io/badge/Conan-2-blue?logo=conan)
![License](https://img.shields.io/badge/License-MIT-green)
![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux%20%7C%20Windows-lightgrey)

Simple CMake project template for C++, supports macOS, Linux, and Windows.

## Tech Stack

- Package Manager: Conan
- Language: C++23
- Build: CMake 4+, Ninja
- Static analysis & formatting: clang-format, clang-tidy

> [!NOTE]
> For Package Manager use VCPKG, please refer to the [feature/vcpkg](../../tree/feature/vcpkg) branch.

## Prerequisites

- CMake 4+
- Conan 2+
- Ninja
- clang-format
- clang-tidy (optional)

## Setup

```sh
# macOS
brew install conan

# Windows
pip install conan
```

```sh
conan profile detect
```

## Build

### macOS / Linux

```sh
./build.sh           # Debug (default)
./build.sh Release   # Release
./build.sh --clean   # Clean build
./build.sh --format  # Format code
./build.sh --tidy    # Run clang-tidy
```

### Windows (PowerShell)

```powershell
.\build.ps1                  # Debug (default)
.\build.ps1 -Preset Release  # Release
.\build.ps1 -Clean           # Clean build
.\build.ps1 -Format          # Format code
.\build.ps1 -Tidy            # Run clang-tidy
```

### Pure CMake commands

```sh
# Install dependencies
conan install . --output-folder=build/Debug --build=missing -s build_type=Debug

# Configure
cmake --preset Debug

# Build
cmake --build --preset Debug
```

## Test

### macOS / Linux

```sh
./run_test.sh
```

### Windows (PowerShell)

```powershell
.\run_test.ps1
```

### Pure CMake commands

```sh
cd build/Debug
ctest --output-on-failure
```
