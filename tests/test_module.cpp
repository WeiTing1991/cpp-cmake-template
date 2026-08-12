#include <gtest/gtest.h>

#include "module.h"

TEST(ModuleTest, Add) {
    Module module;
    EXPECT_EQ(module.add(2, 3), 5);
}

TEST(ModuleTest, GetMessage) {
    Module module;
    EXPECT_FALSE(module.getMessage().empty());
}
