#include "module.h"

Module::Module() : message("Module loaded successfully!")
{}

Module::~Module()
{}

void Module::load() const
{
  std::cout << "Loading module..." << std::endl;
}

std::string Module::getMessage() const
{
  return message;
}

int Module::add(int x, int y) const
{
  return x + y;
}
