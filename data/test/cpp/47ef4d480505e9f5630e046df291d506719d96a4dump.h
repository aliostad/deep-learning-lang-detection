/*
  frame dumper
  Copyright (C) 2001  Martin Vogt

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU Library General Public License as published by
  the Free Software Foundation.

  For more information look at the file COPYRIGHT in this package

 */


#ifndef __DUMP_H
#define __DUMP_H

#include "mpegsound.h"

class Dump {

 public:
  Dump();
  ~Dump();

  void dump(REAL out[SBLIMIT][SSLIMIT]);
  void dump(REAL out[SBLIMIT*SSLIMIT]);
  void dump2(REAL out[SSLIMIT*SBLIMIT]);
  void dump(REAL out[SSLIMIT][SBLIMIT]);
  void dump(int out[SBLIMIT][SSLIMIT]);
  void dump(layer3scalefactor* out);
  void dump(char* prt,int len,int ldelete=false);
  void scale_zero(layer3scalefactor* out);


};
#endif
