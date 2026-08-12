#ifndef MODULE_H
#define MODULE_H

#include <iostream>
#include <string>

class Module
{
public:
  Module();
  ~Module();

  void load() const;
  std::string getMessage() const;
  int add(int x, int y) const;

private:
  std::string message;
};

#endif  // MODULE_H
