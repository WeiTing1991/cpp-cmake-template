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
