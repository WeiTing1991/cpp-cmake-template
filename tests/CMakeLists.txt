find_package(GTest REQUIRED)

add_executable(template_tests
        test_module.cpp
)

target_link_libraries(template_tests
        PRIVATE
        submodule_lib
        GTest::gtest_main
)

include(GoogleTest)
gtest_discover_tests(template_tests)
