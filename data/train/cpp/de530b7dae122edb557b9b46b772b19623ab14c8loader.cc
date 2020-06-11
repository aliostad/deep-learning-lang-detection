#include <commons/asm/bytecodes.hh>
#include <commons/tolkfile/tolk-file.hh>

#include "loader.hh"
#include "interpreter/handlers/handlers.hh"

using namespace interpreter::handlers;
using namespace ressource;

Loader::Loader()
{}

Loader& Loader::get_instance()
{
  static Loader instance;

  return instance;
}

void Loader::init_handlers_manager(interpreter::OpcodeManager& opm)
{
  opm.register_opcode_handler(OP_HALT, halt_handler);
  opm.register_opcode_handler(OP_PUSH, push_handler);
  opm.register_opcode_handler(OP_PUSHR, pushr_handler);
  opm.register_opcode_handler(OP_POP, pop_handler);
  opm.register_opcode_handler(OP_POPR, popr_handler);
  opm.register_opcode_handler(OP_ADD, add_handler);
  opm.register_opcode_handler(OP_SUB, sub_handler);
  opm.register_opcode_handler(OP_MUL, mul_handler);
  opm.register_opcode_handler(OP_DIV, div_handler);
  opm.register_opcode_handler(OP_MOD, mod_handler);
  opm.register_opcode_handler(OP_CALL, call_handler);
  opm.register_opcode_handler(OP_CALLR, callr_handler);
  opm.register_opcode_handler(OP_RET, ret_handler);
  opm.register_opcode_handler(OP_SAVE, save_handler);
  opm.register_opcode_handler(OP_RESTORE, restore_handler);
  opm.register_opcode_handler(OP_SETR, setr_handler);
  opm.register_opcode_handler(OP_CREATE, create_handler);
  opm.register_opcode_handler(OP_DELETE, delete_handler);
  opm.register_opcode_handler(OP_READ, read_handler);
  opm.register_opcode_handler(OP_WRITE, write_handler);
  opm.register_opcode_handler(OP_JMP, jmp_handler);
  opm.register_opcode_handler(OP_JE, je_handler);
  opm.register_opcode_handler(OP_JL, jl_handler);
  opm.register_opcode_handler(OP_JG, jg_handler);
  opm.register_opcode_handler(OP_JNE, jne_handler);
  opm.register_opcode_handler(OP_JLE, jle_handler);
  opm.register_opcode_handler(OP_JGE, jge_handler);
  opm.register_opcode_handler(OP_JMPS, jmps_handler);
  opm.register_opcode_handler(OP_PCALL, pcall_handler);
  opm.register_opcode_handler(OP_PWAIT, pwait_handler);
  opm.register_opcode_handler(OP_ASK, ask_handler);
}
