# Cpp CMake Project Template

Simple CMake project template for Cpp, currently supported Window and Linux

## Prerequisite
- CMake
- gcc
- ninja
- Clang-format


#### MVSC
```bash
cmake --preset windows-mvsc
cmake --build --preset=window-mvsc
```
#### Ninja on windows

```bash
.generate_compile_commnads.bat
```

#### Ninja on linux
```bash
cmake --preest ninja-linux
cmake --build --preset=ninja-linux-build
```

### TODO:
- [ ] add test with `google tests`
- [ ] add github action with `build and formater`
