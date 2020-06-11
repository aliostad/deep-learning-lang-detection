#include "precomp.h"
//////////////////////////////////////////////////////////////////////////////
//
// evcl - genesis - ir - instruction LOAD
// ir/instruction/ir_insn_LOAD.cpp
//
// Copyright (C) 1996-2006 by Project Vogue.
// Written by Yoshifumi "VOGUE" INOUE. (yosi@msn.com)
//
// @(#)$Id: //proj/evcl3/mainline/compiler/ir/ir_insn_LOAD.cpp#3 $
//
#include "./ir_instruction.h"

#include "./ir_fns.h"

namespace Compiler
{

//////////////////////////////////////////////////////////////////////
//
// LoadInsn::LoadInsn
//
LoadInsn::LoadInsn(Register* pRd, Register* pRx) :
    One_Operand_Instruction(pRx)
{
    m_ty = ty_get_pointee(pRx->GetTy());
    m_pOutput = pRd;
} // LoadInsn::LoadInsn

} // Compiler
