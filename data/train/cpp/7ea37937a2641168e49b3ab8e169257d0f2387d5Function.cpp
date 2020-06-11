#include "Function.h"


void Function::dump() {
  printf("Function %s\n", name.c_str());

  printf("Constants:\n");
  constants.dump();
  printf("\n");

  printf("Args:\n");
  args.dump();
  printf("\n");

  printf("Locals:\n");
  locals.dump();
  printf("\n");

  printf("Results:\n");
  results.dump();
  printf("\n");

  printf("Code:\n");
  dumpCode();
}

void Function::dumpCode() {
  for (size_t i = 0; i < code.size(); i++) {
    Instruction& c = code[i];
    printf("%-9s %3d,%3d,%3d\n",opcodeStrings[c.opcode], c.ra, c.rb, c.rc);
  }
}