#include <gtest/gtest.h>

#include "cpp_cmake_template/submodule1/module.h"

TEST(ModuleTest, Add) {
    Module module;
    EXPECT_EQ(module.add(2, 3), 5);
}

TEST(ModuleTest, GetMessage) {
    Module module;
    EXPECT_FALSE(module.getMessage().empty());
}
