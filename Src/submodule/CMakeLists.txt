cmake_minimum_required(VERSION 3.20)

# Collect source files
file(GLOB_RECURSE SUBMODULE_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp
)

file(GLOB_RECURSE SUBMODULE_HEADERS
    ${CMAKE_CURRENT_SOURCE_DIR}/*.h
    ${CMAKE_CURRENT_SOURCE_DIR}/*.hpp
)

# Create library
add_library(submodule_lib STATIC
    ${SUBMODULE_SOURCES}
    ${SUBMODULE_HEADERS}
)

# Set include directories
target_include_directories(submodule_lib PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)

# Set C++ standard
target_compile_features(submodule_lib PUBLIC cxx_std_20)
