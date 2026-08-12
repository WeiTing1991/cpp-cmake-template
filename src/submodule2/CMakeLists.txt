file(GLOB_RECURSE SUBMODULE2_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp
)

add_library(submodule2_lib STATIC
    ${SUBMODULE2_SOURCES}
)

target_include_directories(submodule2_lib PUBLIC
    ${PROJECT_SOURCE_DIR}/include
)

target_compile_features(submodule2_lib PUBLIC cxx_std_23)
