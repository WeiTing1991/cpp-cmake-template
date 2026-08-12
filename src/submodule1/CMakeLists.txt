file(GLOB_RECURSE SUBMODULE1_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp
)

add_library(submodule1_lib STATIC
    ${SUBMODULE1_SOURCES}
)

target_include_directories(submodule1_lib PUBLIC
    ${PROJECT_SOURCE_DIR}/include
)

target_compile_features(submodule1_lib PUBLIC cxx_std_23)
