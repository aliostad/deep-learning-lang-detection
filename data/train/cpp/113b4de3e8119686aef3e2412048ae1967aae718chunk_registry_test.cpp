#include "../src/chunk_registry.hpp"
#include <gtest/gtest.h>

class ChunkRegistry : public ::testing::Test
{
protected:
  virtual
  void
  SetUp()
  {
    small_chunk = chunk::create (256);
    large_chunk = chunk::create (1 << 14);

    small_ptr = small_chunk->data();
    large_ptr = large_chunk->data();

    ch_reg.add (small_chunk);
    ch_reg.add (large_chunk);
  }

  virtual
  void
  TearDown()
  {
    chunk::destroy (small_chunk);
    chunk::destroy (large_chunk);
  }

  void *small_ptr;
  void *large_ptr;
  chunk *small_chunk;
  chunk *large_chunk;
  chunk_registry ch_reg;
};

TEST_F(ChunkRegistry, AllocatedInRange) {
  ASSERT_TRUE (ch_reg.in_range (small_chunk->data()));
}

TEST_F(ChunkRegistry, MidChunkInRange) {
  ASSERT_TRUE (ch_reg.in_range ((void*)((char*)large_chunk->data() + (1 << 13))));
}

TEST_F(ChunkRegistry, AfterChunkNotInRange) {
  ASSERT_FALSE (ch_reg.in_range ((void*)((char*)large_chunk->data() + (1 << 16))));
}


TEST_F(ChunkRegistry, FetchChunkObjectPtr) {
  chunk* chunk = ch_reg.find_chunk (large_ptr);

  ASSERT_NE (chunk, nullptr);
  ASSERT_EQ (chunk->data(), large_ptr);
}

TEST_F(ChunkRegistry, FetchHeaderInteriorPtr) {
  chunk* chunk= ch_reg.find_chunk ((char*)large_ptr + (1 << 13));

  ASSERT_EQ (chunk, nullptr);
}

TEST_F(ChunkRegistry, BackPointerIso) {
  chunk* chunk = ch_reg.find_chunk (large_ptr);

  ASSERT_NE (chunk, nullptr);
  ASSERT_EQ (*chunk->back_ptr, chunk);
}

TEST_F(ChunkRegistry, MarkTrue) {
  ch_reg.mark (large_ptr);
  ASSERT_TRUE (ch_reg.is_marked (large_ptr));
}

TEST_F(ChunkRegistry, MarkFalse) {
  ASSERT_FALSE (ch_reg.is_marked (large_ptr));
}

TEST_F(ChunkRegistry, BasePtrIsValid) {
  auto chunk = ch_reg.find_chunk (large_ptr);

  ASSERT_NE (chunk, nullptr);
  ASSERT_TRUE (chunk->valid (large_ptr));
}

TEST_F(ChunkRegistry, NextPtrIsValid) {
  auto chunk = ch_reg.find_chunk (small_ptr);

  ASSERT_NE (chunk, nullptr);
  ASSERT_TRUE (chunk->valid ((char*)small_ptr + 256UL));
}


TEST_F(ChunkRegistry, MidObjectInvalidPtr) {
  auto chunk = ch_reg.find_chunk (large_ptr);

  ASSERT_NE (chunk, nullptr);
  ASSERT_FALSE (chunk->valid ((char*)large_ptr + 240UL));
}


TEST_F(ChunkRegistry, OutOfChunkInvalidPtr) {
  auto chunk = ch_reg.find_chunk (large_ptr);

  ASSERT_NE (chunk, nullptr);
  ASSERT_FALSE (chunk->valid ((char*)large_ptr + 2*4096UL));
}

TEST_F(ChunkRegistry, Remove) {
  ch_reg.remove (large_chunk);
  auto chunk = ch_reg.find_chunk (large_ptr);
  ASSERT_EQ (chunk, nullptr);
}
