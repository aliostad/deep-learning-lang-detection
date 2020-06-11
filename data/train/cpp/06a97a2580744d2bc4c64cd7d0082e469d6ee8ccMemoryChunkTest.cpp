//
// Created by mwypych on 27.03.17.
//

#include <gtest/gtest.h>
#include <memory>
#include <vector>
#include <algorithm>
#include <MemLeakTest.h>
#include <MemoryChunk.h>

using ::memorychunk::MemoryChunk;
using ::std::make_unique;
using ::std::move;
using ::std::fill;
using ::std::swap;
using ::std::vector;

class MemoryChunkTests : public ::testing::Test, MemLeakTest {
};

TEST_F(MemoryChunkTests, IsAbleToCreateChunkAndDestroyItAsLocalVariable) {
  {
    MemoryChunk chunk{64};
    fill(chunk.MemoryAt(0), chunk.MemoryAt(63) + 1, 77);
    EXPECT_EQ(77, *chunk.MemoryAt(0));
    EXPECT_EQ(77, *chunk.MemoryAt(45));
    EXPECT_EQ(77, *chunk.MemoryAt(63));
  }
}

TEST_F(MemoryChunkTests, IsAbleToCreateChunkAndDestroyItAsHeapVariable) {
  MemoryChunk *pchunk = new MemoryChunk{1024};
  *pchunk->MemoryAt(0) = 88;
  *pchunk->MemoryAt(1023) = 99;
  EXPECT_EQ(88, *pchunk->MemoryAt(0));
  EXPECT_EQ(99, *pchunk->MemoryAt(1023));
  delete pchunk;
}

TEST_F(MemoryChunkTests, IsAbleToMoveChunks) {
  MemoryChunk chunk{1024};
  int8_t *ptr = chunk.MemoryAt(0);
  MemoryChunk moved_chunk = move(chunk);
  EXPECT_EQ(nullptr, chunk.MemoryAt(0));
  EXPECT_EQ(0, chunk.ChunkSize());

  EXPECT_EQ(1024, moved_chunk.ChunkSize());
  EXPECT_EQ(ptr, moved_chunk.MemoryAt(0));
}

TEST_F(MemoryChunkTests, IsAbleToCopyConstructChunks) {
  MemoryChunk chunk{1024};
  int8_t *ptr = chunk.MemoryAt(0);
  fill(chunk.MemoryAt(0), chunk.MemoryAt(1023) + 1, 111);

  MemoryChunk copied_chunk{chunk};
  EXPECT_NE(nullptr, chunk.MemoryAt(0));
  EXPECT_NE(nullptr, copied_chunk.MemoryAt(0));

  EXPECT_EQ(1024, chunk.ChunkSize());
  EXPECT_EQ(1024, copied_chunk.ChunkSize());

  EXPECT_EQ(ptr, chunk.MemoryAt(0));
  EXPECT_NE(ptr, copied_chunk.MemoryAt(0));

  EXPECT_EQ(111, *chunk.MemoryAt(768));
  EXPECT_EQ(111, *copied_chunk.MemoryAt(768));

  fill(chunk.MemoryAt(0), chunk.MemoryAt(1023) + 1, 55);

  EXPECT_EQ(55, *chunk.MemoryAt(333));
  EXPECT_EQ(111, *copied_chunk.MemoryAt(333));

  fill(copied_chunk.MemoryAt(0), copied_chunk.MemoryAt(1023) + 1, 67);

  EXPECT_EQ(55, *chunk.MemoryAt(333));
  EXPECT_EQ(67, *copied_chunk.MemoryAt(333));
}

TEST_F(MemoryChunkTests, IsAbleToCopyMoveChunks) {
  MemoryChunk chunk{2048};
  int8_t *ptr = chunk.MemoryAt(0);
  fill(chunk.MemoryAt(0), chunk.MemoryAt(2047) + 1, 13);

  MemoryChunk copied_chunk{move(chunk)};
  EXPECT_EQ(nullptr, chunk.MemoryAt(0));
  EXPECT_NE(nullptr, copied_chunk.MemoryAt(0));

  EXPECT_EQ(0, chunk.ChunkSize());
  EXPECT_EQ(2048, copied_chunk.ChunkSize());

  EXPECT_EQ(ptr, copied_chunk.MemoryAt(0));

  EXPECT_EQ(13, *copied_chunk.MemoryAt(768));
}

TEST_F(MemoryChunkTests, IsAbleToCopyAssignChunks) {
  MemoryChunk chunk{1024};
  int8_t *ptr = chunk.MemoryAt(0);
  fill(chunk.MemoryAt(0), chunk.MemoryAt(1023) + 1, 111);

  MemoryChunk copied_chunk = chunk;
  EXPECT_NE(nullptr, chunk.MemoryAt(0));
  EXPECT_NE(nullptr, copied_chunk.MemoryAt(0));

  EXPECT_EQ(1024, chunk.ChunkSize());
  EXPECT_EQ(1024, copied_chunk.ChunkSize());

  EXPECT_EQ(ptr, chunk.MemoryAt(0));
  EXPECT_NE(ptr, copied_chunk.MemoryAt(0));

  EXPECT_EQ(111, *chunk.MemoryAt(768));
  EXPECT_EQ(111, *copied_chunk.MemoryAt(768));

  fill(chunk.MemoryAt(0), chunk.MemoryAt(1023) + 1, 55);

  EXPECT_EQ(55, *chunk.MemoryAt(333));
  EXPECT_EQ(111, *copied_chunk.MemoryAt(333));

  fill(copied_chunk.MemoryAt(0), copied_chunk.MemoryAt(1023) + 1, 67);

  EXPECT_EQ(55, *chunk.MemoryAt(333));
  EXPECT_EQ(67, *copied_chunk.MemoryAt(333));
}

TEST_F(MemoryChunkTests, IsSelfAssignableAware) {
  int8_t *ptr;
  {
    MemoryChunk chunk{512};
    ptr = chunk.MemoryAt(0);
    chunk = chunk;

    EXPECT_EQ(512, chunk.ChunkSize());
    EXPECT_EQ(ptr, chunk.MemoryAt(0));
    fill(chunk.MemoryAt(0), chunk.MemoryAt(511) + 1, 33);
    EXPECT_EQ(33, *chunk.MemoryAt(44));
  }
  {
    MemoryChunk chunk2{512};
    EXPECT_EQ(512, chunk2.ChunkSize());
  }
}

TEST_F(MemoryChunkTests, IsSelfMoveAssignableAware) {
  int8_t *ptr;
  {
    MemoryChunk chunk{512};
    ptr = chunk.MemoryAt(0);
    chunk = move(chunk);

    EXPECT_EQ(512, chunk.ChunkSize());
    EXPECT_EQ(ptr, chunk.MemoryAt(0));
    fill(chunk.MemoryAt(0), chunk.MemoryAt(511) + 1, 33);
    EXPECT_EQ(33, *chunk.MemoryAt(44));
  }
}

TEST_F(MemoryChunkTests, IsAbleToSwapChunks) {
  {
    MemoryChunk chunk{768};
    MemoryChunk chunk2{256};
    int8_t *ptr = chunk.MemoryAt(0);
    int8_t *ptr2 = chunk2.MemoryAt(0);
    swap(chunk, chunk2);

    EXPECT_EQ(256, chunk.ChunkSize());
    EXPECT_EQ(768, chunk2.ChunkSize());

    EXPECT_EQ(ptr2, chunk.MemoryAt(0));
    EXPECT_EQ(ptr, chunk2.MemoryAt(0));

    fill(chunk.MemoryAt(0), chunk.MemoryAt(255) + 1, 63);
    EXPECT_EQ(63, *chunk.MemoryAt(44));

    fill(chunk2.MemoryAt(0), chunk2.MemoryAt(767) + 1, 41);
    EXPECT_EQ(41, *chunk2.MemoryAt(46));
  }
}

TEST_F(MemoryChunkTests, IsAbleEmplaceChunksIntoVector) {
  vector <MemoryChunk> chunks;
  chunks.emplace_back(4096);
  chunks.emplace_back(256);
  MemoryChunk &chunk = chunks[0];
  MemoryChunk &chunk2 = chunks[1];

  int8_t *ptr = chunk.MemoryAt(0);
  int8_t *ptr2 = chunk2.MemoryAt(0);
  swap(chunk, chunk2);

  EXPECT_EQ(256, chunks[0].ChunkSize());
  EXPECT_EQ(4096, chunks[1].ChunkSize());

  EXPECT_EQ(ptr2, chunk.MemoryAt(0));
  EXPECT_EQ(ptr, chunk2.MemoryAt(0));

  fill(chunk.MemoryAt(0), chunk.MemoryAt(255) + 1, 63);
  EXPECT_EQ(63, *chunk.MemoryAt(44));

  fill(chunk2.MemoryAt(0), chunk2.MemoryAt(767) + 1, 41);
  EXPECT_EQ(41, *chunk2.MemoryAt(46));
}
