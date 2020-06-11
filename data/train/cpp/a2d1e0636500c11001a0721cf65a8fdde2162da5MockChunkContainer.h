#include "..\kraken\ChunkContainer.h"

#include <gmock\gmock.h>

class MockChunkContainer : public ChunkContainer
{
  public:
    MOCK_METHOD1(fill, bool (const Disassembler& disassemble));
    MOCK_METHOD2(disassemble_next_code_chunk, CodeChunk (queue<va_t>& jumpInstructionQueue, const Disassembler& disassemble));
    MOCK_METHOD1(check_if_intersects, code_collection_t::iterator (const CodeChunk& codeChunk));
    MOCK_METHOD3(merge_code_chunks, void (CodeChunk& destination, const CodeChunk& firstCodeChunk, const CodeChunk& secondCodeChunk));
};
