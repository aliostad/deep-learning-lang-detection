/*
 * File:   ChunkTest.h
 * Author: daniele
 *
 * Created on Oct 11, 2010, 2:16:04 PM
 */

#include <iostream>
#include <string>

#include "Chunk.h"
#include <gtest/gtest.h>

namespace {
    class ChunkTest : public ::testing::Test {
    protected:
        ChunkTest() {}
        virtual ~ChunkTest() {}

        virtual void SetUp()
        {
            _offset = 31337;
            _testString = "test123";
            _chunk = new Chunk( _testString.c_str(), BufferDescriptor( _offset, _testString.size() ) );
            _emptyChunk = new Chunk();
        }
        
        virtual void TearDown()
        {
            delete _chunk;
            delete _emptyChunk;
        }
        
        std::size_t _offset;
        std::string _testString;
        Chunk* _chunk;
        Chunk* _emptyChunk;
    };
    
    TEST_F(ChunkTest, descriptor)
    {
        EXPECT_TRUE( _chunk->descriptor() == BufferDescriptor(_offset, _testString.size()) );
    }

    TEST_F(ChunkTest, empty_descriptor_is_zero)
    {
        EXPECT_TRUE( _emptyChunk->descriptor() == BufferDescriptor(0, 0) );
    }

    TEST_F(ChunkTest, offset)
    {
        EXPECT_EQ( _chunk->offset(), _offset );
    }

    TEST_F(ChunkTest, empty_offset_is_zero)
    {
        EXPECT_EQ( _emptyChunk->offset(), 0 );
    }
    
    TEST_F(ChunkTest, pointer_is_valid)
    {
        ASSERT_TRUE( _chunk->ptr() );
    }
    
    TEST_F(ChunkTest, vector_reference_is_valid)
    {
        ASSERT_EQ( (intptr_t) &_chunk->vector()[0], (intptr_t) _chunk->ptr() );
    }
    
    TEST_F(ChunkTest, empty_pointer_is_null)
    {
        EXPECT_STREQ( _emptyChunk->ptr(), NULL );
    }

    TEST_F(ChunkTest, size)
    {
        EXPECT_EQ( _chunk->size(), _testString.size() );
    }

    TEST_F(ChunkTest, empty_size_is_zero)
    {
        EXPECT_EQ( _emptyChunk->size(), 0 );
    }
}
