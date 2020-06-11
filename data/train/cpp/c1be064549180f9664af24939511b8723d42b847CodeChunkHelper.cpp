#include "CodeChunkHelper.h"

CodeChunk CodeChunkHelper::GenerateCodeChunk(const va_t& firstVa, const va_t& lastVa)
{
  CodeChunk chunk;
  
  AsmCode tempDisasm;
  for( auto passedChunkBaseVa = firstVa; passedChunkBaseVa <= lastVa; ++passedChunkBaseVa )
  {
    tempDisasm.VirtualAddr = passedChunkBaseVa;
    chunk.add_to_chunk( tempDisasm );
  }
  
  return chunk;
}

CodeChunk CodeChunkHelper::GenerateCodeChunkWithOneJump(const va_t& firstVa, const va_t& lastVa, const va_t& JmpVa)
{
  CodeChunk chunk;
  
  AsmCode tempDisasm;
  for( auto passedChunkBaseVa = firstVa; passedChunkBaseVa <= lastVa; ++passedChunkBaseVa )
  {
    if ( passedChunkBaseVa == JmpVa )
    {
      tempDisasm.Instruction.BranchType = kraken::JmpType;
      tempDisasm.Instruction.AddrValue = JmpVa;
    }
    else
    {
      tempDisasm.Instruction.BranchType = kraken::Undefined;
      tempDisasm.Instruction.AddrValue = -1;
    }

    tempDisasm.VirtualAddr = passedChunkBaseVa;
    chunk.add_to_chunk( tempDisasm );
  }
  
  return chunk;
}
