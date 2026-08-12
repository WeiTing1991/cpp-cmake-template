add_subdirectory(submodule)

add_executable(CppCmakeTemplate main.cpp)

target_link_libraries(CppCmakeTemplate PRIVATE submodule_lib)

target_include_directories(CppCmakeTemplate PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/submodule
)
