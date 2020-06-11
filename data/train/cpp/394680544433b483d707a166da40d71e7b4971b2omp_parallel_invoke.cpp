#include <iostream>
#include "parallel_invoke.h"

struct spin
{
  void operator()(void) const
  {
    std::cout << "s" << std::endl;
    while (1) {}
  }
};

struct functor
{
  int x;
  
  functor(int x) : x(x) {}

  void operator()(void) const
  {
    std::cout << x << std::endl;

    parallel_invoke(spin(), spin(), spin());
  }
};

int main(void)
{
//  parallel_invoke(functor(1), functor(2));
//  std::cout << "\n";
//  parallel_invoke(functor(1), functor(2), functor(3));
//  std::cout << "\n";
//  parallel_invoke(functor(1), functor(2), functor(3), functor(4));
//  std::cout << "\n";
  parallel_invoke(functor(1), functor(2), functor(3), functor(4), functor(5));
  std::cout << "\n";

  return 0;
}

