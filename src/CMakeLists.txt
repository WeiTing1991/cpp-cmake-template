add_subdirectory(submodule1)
add_subdirectory(submodule2)

add_executable(CppCmakeTemplate main.cpp)

target_link_libraries(CppCmakeTemplate PRIVATE submodule1_lib submodule2_lib)

target_include_directories(CppCmakeTemplate PRIVATE
    ${PROJECT_SOURCE_DIR}/include
)
