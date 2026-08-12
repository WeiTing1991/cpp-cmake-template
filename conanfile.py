from conan import ConanFile
from conan.tools.cmake import CMakeToolchain, CMakeDeps


class CppCmakeTemplateRecipe(ConanFile):
    name = "cpp-cmake-template"
    settings = "os", "compiler", "build_type", "arch"

    def requirements(self):
        # Testing
        self.requires("gtest/1.17.0")

    def build_requirements(self):
        self.tool_requires("cmake/[>=4.0]")

    def generate(self):
        tc = CMakeToolchain(self)
        tc.user_presets_path = "ConanPresets.json"
        tc.generate()
        deps = CMakeDeps(self)
        deps.generate()
