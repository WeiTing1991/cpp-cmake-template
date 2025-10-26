cmake_minimum_required(VERSION 3.20)

project(
    CppCmakeTemplate
    VERSION 1.0.0
    DESCRIPTION "A C++ project template using CMake"
    LANGUAGES CXX
)

# Set C++ standard
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)


# Export compile commands for IDE/tools
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Define the path to the installed directory
# Uncomment if use a custom vcpkg installation path
# set(INSTALLED_SHARED_DIR ./vcpkg_installed/${VCPKG_TARGET_TRIPLET}/share)

# Add subdirectories
add_subdirectory(Src)
# add_subdirectory(Tests)

# Main executable
add_executable(${PROJECT_NAME} Src/main.cpp)

# Link the submodule library to main executable
target_link_libraries(${PROJECT_NAME} PRIVATE submodule_lib)

# Include directories
target_include_directories(${PROJECT_NAME} PRIVATE
    ${CMAKE_SOURCE_DIR}/Src/submodule
)
