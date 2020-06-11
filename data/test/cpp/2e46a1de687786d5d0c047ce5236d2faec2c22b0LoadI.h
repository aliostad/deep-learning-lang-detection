// @(#)$Id$
//
// Evita Il - IR - IL
//
// Copyright (C) 2010 by Project Vogue.
// Written by Yoshifumi "VOGUE" INOUE. (yosi@msn.com)

#if !defined(INCLUDE_Il_Ir_Instructions_LoadI_h)
#define INCLUDE_Il_Ir_Instructions_LoadI_h

#include "./GeneralInstruction.h"

namespace Il {
namespace Ir {

// LoadI ty %rd <= %rx
class LoadI : public Instruction_<LoadI, Op_Load> {
  public: LoadI();
  public: LoadI(const Type&, const Output&, const Operand&);
  DISALLOW_COPY_AND_ASSIGN(LoadI);
}; // LoadI

} // Ir
} // Il

#endif // !defined(INCLUDE_Il_Ir_Instructions_LoadI_h)
