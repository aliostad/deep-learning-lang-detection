// Eggs.SD-6
//
// Copyright Agustin K-ballo Berge, Fusion Fenix 2015
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

#include <functional>

int fun() { return 0; }

struct callable {
  int operator()(){ return 0; }
  int x;
};

void test_invoke() {
  int f = std::invoke(fun);

  callable c;
  int mf = std::invoke(&callable::operator(), c);
  int mfp = std::invoke(&callable::operator(), &c);
  int mo = std::invoke(&callable::x, c);
  int mop = std::invoke(&callable::x, &c);
}

int main() {
  test_invoke();
}
