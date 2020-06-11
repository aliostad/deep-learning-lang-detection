#include "CodeChunkTest.h"

TEST_F(CodeChunkTest, ChunkIsEmptyBeginAndEndAreEqual)
{
  CodeChunk chunk;

  EXPECT_EQ( chunk.begin(), chunk.end() );
}

TEST_F(CodeChunkTest, BeginChunkIsNotEmptyReturnsIteratorToTheBeginningOfChunk)
{
  AsmCode disasm;
  disasm.VirtualAddr = _baseVa;

  EXPECT_EQ( disasm, *_chunk.begin() );
}

TEST_F(CodeChunkTest, EndChunkIsNotEmptyReturnsIteratorToTheEndOfChunk)
{
  AsmCode disasm;
  disasm.VirtualAddr = _lastVa;

  EXPECT_EQ( disasm, *(_chunk.end() - 1) );
}

TEST_F(CodeChunkTest, FrontAlwaysReturnsFirstElement)
{
  AsmCode disasm;
  disasm.VirtualAddr = _baseVa;

  EXPECT_EQ( disasm, _chunk.front() );
}

TEST_F(CodeChunkTest, BackAlwaysReturnsLastElement)
{
  AsmCode disasm;
  disasm.VirtualAddr = _lastVa;

  EXPECT_EQ( disasm, _chunk.back() );
}

TEST_F(CodeChunkTest, FirstVaChunkIsEmptyReturnsMinusOne)
{
  CodeChunk chunk;

  EXPECT_EQ( -1, chunk.first_va() );
}

TEST_F(CodeChunkTest, LastVaChunkIsEmptyReturnsMinusOne)
{
  CodeChunk chunk;

  EXPECT_EQ( -1, chunk.last_va() );
}

TEST_F(CodeChunkTest, FirstVaChunkIsNotEmptyReturnsVaOfFirstDisasm)
{
  EXPECT_EQ( _baseVa, _chunk.first_va() );
}

TEST_F(CodeChunkTest, LastVaChunkIsNotEmptyReturnsVaOfLastDisasm)
{
  EXPECT_EQ ( _lastVa, _chunk.last_va() );
}

TEST_F(CodeChunkTest, IsAddressIncludedChunkIsEmptyReturnsFalse)
{
  CodeChunk chunk;

  EXPECT_FALSE( chunk.is_address_included( chunk.first_va() ) );
}

TEST_F(CodeChunkTest, IsAddressIncludedAddressIsLessThanZeroReturnsFalse)
{
  CodeChunk chunk;

  EXPECT_FALSE( chunk.is_address_included( -1 ) );
}

TEST_F(CodeChunkTest, IsAddressIncludedBoundaryVasReturnsTrue)
{
  EXPECT_TRUE( _chunk.is_address_included( _baseVa ) );
  EXPECT_TRUE( _chunk.is_address_included( _lastVa ) );
}

TEST_F(CodeChunkTest, IsAddressIncludedAddressIsBetweenFirstVaAndLastVaReturnsTrue)
{
  EXPECT_TRUE( _chunk.is_address_included( _baseVa + 10 ) );
}

TEST_F(CodeChunkTest, IsAddressIncludedAddressIsNotBetweenFirstVaAndLastVaReturnsFalse)
{
  EXPECT_FALSE( _chunk.is_address_included( _baseVa - 1 ) );
  EXPECT_FALSE( _chunk.is_address_included( _lastVa + 1 ) );
}

TEST_F(CodeChunkTest, IntersectsWithPassedChunkBoundaryVasOverlapWithInnerChunkReturnsTrue)
{
  CodeChunk passedChunk1 = CodeChunkHelper::GenerateCodeChunk( _baseVa - 10, _baseVa );
  CodeChunk passedChunk2 = CodeChunkHelper::GenerateCodeChunk( _lastVa, _lastVa + 10 );

  EXPECT_TRUE( _chunk.intersects_with( passedChunk1 ) );
  EXPECT_TRUE( _chunk.intersects_with( passedChunk2 ) );
}

TEST_F(CodeChunkTest, IntersectsWithPassedCodeChunkIntersectsReturnsTrue)
{
  CodeChunk passedChunk1 = CodeChunkHelper::GenerateCodeChunk( _baseVa - 10, _baseVa + 10 );
  CodeChunk passedChunk2 = CodeChunkHelper::GenerateCodeChunk( _baseVa + 10, _lastVa + 10 );

  EXPECT_TRUE( _chunk.intersects_with( passedChunk1 ) );
  EXPECT_TRUE( _chunk.intersects_with( passedChunk2 ) );
}

TEST_F(CodeChunkTest, IntersectsWithPassedCodeChunkDoesntIntersectReturnsFalse)
{
  CodeChunk passedChunk1 = CodeChunkHelper::GenerateCodeChunk( _baseVa - 10, _baseVa - 1 );
  CodeChunk passedChunk2 = CodeChunkHelper::GenerateCodeChunk( _lastVa + 1, _lastVa + 10 );

  EXPECT_FALSE( _chunk.intersects_with( passedChunk1 ) );
  EXPECT_FALSE( _chunk.intersects_with( passedChunk2 ) );
}

TEST_F(CodeChunkTest, IncludesCodeChunkIsEmptyReturnsFalse)
{
  CodeChunk chunk;

  EXPECT_FALSE( _chunk.includes( chunk ) );
}

TEST_F(CodeChunkTest, IncludesPassedChunkBoundaryVasOverlapWithOnesFromInnerChunksReturnsTrue)
{
  CodeChunk passedChunk1 = CodeChunkHelper::GenerateCodeChunk( _baseVa, _lastVa - 10 );
  CodeChunk passedChunk2 = CodeChunkHelper::GenerateCodeChunk( _baseVa + 10, _lastVa );

  EXPECT_TRUE( _chunk.includes( passedChunk1 ) );
  EXPECT_TRUE( _chunk.includes( passedChunk2 ) );
}

TEST_F(CodeChunkTest, IncludesPassedChunkMatchesInnerChunkReturnsTrue)
{
  CodeChunk passedChunk = CodeChunkHelper::GenerateCodeChunk( _baseVa, _lastVa );

  EXPECT_TRUE( _chunk.includes( passedChunk ) );
}

TEST_F(CodeChunkTest, IncludesPassedChunkIsInnerChunksSubsetReturnsTrue)
{
  CodeChunk passedChunk = CodeChunkHelper::GenerateCodeChunk( _baseVa + 10, _lastVa - 10 );

  EXPECT_TRUE( _chunk.includes( passedChunk ) );
}

TEST_F(CodeChunkTest, IncludesPassedChunkPartiallyInetsectsWithInnerChunkReturnsFalse)
{
  CodeChunk passedChunk1 = CodeChunkHelper::GenerateCodeChunk( _baseVa - 10, _lastVa - 10 );
  CodeChunk passedChunk2 = CodeChunkHelper::GenerateCodeChunk( _baseVa + 10, _lastVa + 10 );

  EXPECT_FALSE( _chunk.includes( passedChunk1 ) );
  EXPECT_FALSE( _chunk.includes( passedChunk2 ) );
}

TEST_F(CodeChunkTest, IncludesPassedChunkNeverInetsectsWithInnerChunkReturnsFalse)
{
  CodeChunk passedChunk1 = CodeChunkHelper::GenerateCodeChunk( _baseVa - 10, _baseVa - 1 );
  CodeChunk passedChunk2 = CodeChunkHelper::GenerateCodeChunk( _lastVa + 1, _lastVa + 10 );

  EXPECT_FALSE( _chunk.includes( passedChunk1 ) );
  EXPECT_FALSE( _chunk.includes( passedChunk2 ) );
}

TEST_F(CodeChunkTest, AddToChunkAlwaysAddsSingleDisasm)
{
  AsmCode disasm;
  disasm.VirtualAddr = 1000;
  CodeChunk chunk;

  chunk.add_to_chunk( disasm );

  EXPECT_EQ( disasm, chunk.front() );
}

TEST_F(CodeChunkTest, AddToChunkAlwaysAddsInstructions)
{
  vector<AsmCode> instructs;

  AsmCode tempDisasm;
  for( int i = _baseVa; i <= _lastVa; ++i )
  {
    tempDisasm.VirtualAddr = i;
    instructs.push_back( tempDisasm );
  }
  
  CodeChunk chunk;

  chunk.add_to_chunk( instructs.begin(), instructs.end() );

  // There is no size() function for CodeChunk() yet so the only way we can get it's length is like this :)
  EXPECT_EQ( ( chunk.end() - chunk.begin() ), instructs.size() );

  auto vectorIterator = instructs.begin();
  auto chunkIterator = chunk.begin();
  while( vectorIterator != instructs.end() && chunkIterator == chunk.end() )
  {
    EXPECT_EQ( *vectorIterator, *chunkIterator );

    ++vectorIterator;
    ++chunkIterator;
  }
}
