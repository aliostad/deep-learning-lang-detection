#pragma once

#include "../stdafx.h"
#include <vector>

#include "../base/entity/raw.h"

namespace asn1
{
  using namespace std;
  class stream : object
  {
    vector<entity *> out;
  public:
    stream();
    stream(string);
    stream(const stream &);
    stream(stream &&);

    operator string() const;
    
    stream &operator<<(entity *);    stream &operator<<(const entity &);    stream &operator<<(const string &);    stream &operator=(const stream &);    stream &operator=(stream &&);    const vector<entity *> &Parse() const;    stream &operator>>(entity *&);
    ~stream();
  };
}