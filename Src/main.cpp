#include <iostream>

#include "module.h"

int main() {
  std::cout << "=== Main Program ===" << std::endl;

  // Create an instance of Module from submodule
  Module module;

  // Use the module
  module.load();

  // Get message
  std::string msg = module.getMessage();
  std::cout << "Message: " << msg << std::endl;

  // Use add function
  int result = module.add(5, 3);
  std::cout << "5 + 3 = " << result << std::endl;

  std::cout << "\n=== Original Hello World ===" << std::endl;
  std::cout << "Hello, World!" << std::endl;

  return 0;
}
