# Cpp CMake Project Template

![C++23](https://img.shields.io/badge/C%2B%2B-23-blue?logo=cplusplus)
![CMake](https://img.shields.io/badge/CMake-4%2B-blue?logo=cmake)
![vcpkg](https://img.shields.io/badge/vcpkg-manifest-blue)
![License](https://img.shields.io/badge/License-Apache%202.0-green)
![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux%20%7C%20Windows-lightgrey)

Simple CMake project template for C++, supports macOS, Linux, and Windows.

## Tech Stack

- Package Manager: vcpkg (manifest mode)
- Language: C++23
- Build: CMake 4+, Ninja
- Static analysis & formatting: clang-format, clang-tidy

> [!NOTE]
> For Package Manager use Conan, please refer to the [main](../../tree/main) branch.

## Prerequisites

- CMake 4+
- vcpkg
- Ninja
- clang-format
- clang-tidy (optional)

## Setup

### macOS / Linux

```sh
git clone https://github.com/microsoft/vcpkg.git ~/vcpkg
cd vcpkg && ./bootstrap-vcpkg.sh
```
add into .bashrc or .zshrc
```sh
export VCPKG_ROOT=/path/to/vcpkg
export PATH=$VCPKG_ROOT:$PATH
```
### Windows (PowerShell)

```powershell
git clone https://github.com/microsoft/vcpkg.git ~/vcpkg
cd vcpkg; .\bootstrap-vcpkg.bat
```
add into .bashrc or .zshrc

```powershell
$env:VCPKG_ROOT = "C:\path\to\vcpkg"
$env:PATH = "$env:VCPKG_ROOT;$env:PATH"
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

### CMake

```sh
# Configure (vcpkg installs dependencies automatically)
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

### CMake

```sh
cd build/Debug
ctest --output-on-failure
```
