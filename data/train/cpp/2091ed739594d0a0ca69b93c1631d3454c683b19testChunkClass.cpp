/*
 * File:   testChunkClass.cpp
 * Author: Keo
 *
 * Created on 27.10.2013, 18:39:26
 */

#include "testChunkClass.h"


CPPUNIT_TEST_SUITE_REGISTRATION(testChunkClass);

testChunkClass::testChunkClass()
{
}

testChunkClass::~testChunkClass()
{
}

void testChunkClass::setUp()
{
}

void testChunkClass::tearDown()
{
}

void testChunkClass::testChunk()
{
    sf::Vector3i p0(2, 3, 4);
    sf::Vector3i blockPosition(16, 16, 10);

    Chunk chunk(p0);
    CPPUNIT_ASSERT_EQUAL(AIR, chunk.getBlock(blockPosition));
    
    chunk.placeBlock(blockPosition, GRASS);
    CPPUNIT_ASSERT_EQUAL(GRASS, chunk.getBlock(blockPosition));
}

void testChunkClass::testName()
{
    sf::Vector3i p(1,4,5);
    CPPUNIT_ASSERT_EQUAL(std::string("1-4-5.chunk"),Chunk::getChunkName(p));
}

void testChunkClass::testSaveAndLoad()
{
    /*sf::Vector3i p(1,4,5);
    Chunk chunk(p);
    chunk.placeBlock(p,GRASS);
    chunk.save();
    
    Chunk chunkLoad;
    
    CPPUNIT_ASSERT_EQUAL(GRASS, chunkLoad.getBlock(p));*/
    CPPUNIT_FAIL("Test not yet implemented!");
}

void testChunkClass::testPlaceBlock()
{
    sf::Vector3i p0(2, 3, 4);

    Chunk chunk(p0);
    CPPUNIT_ASSERT_EQUAL(AIR, chunk.placeBlock(p0, GRASS));
    CPPUNIT_ASSERT_EQUAL(GRASS, chunk.placeBlock(p0, GRASS));
}

void testChunkClass::testDummyGenerate()
{
    sf::Vector3i p0(2, 3, 4);
    Chunk chunk(p0);
    chunk.dummyGenerate();
    int air, grass;
    for (int i=0; i<32; ++i )
    {
        for (int j=0; j<32; ++j )
        {
                for (int k=0; k<32; ++k )
                {
                    if (chunk.getBlock(sf::Vector3i(i,j,k)) == AIR)
                        ++air;
                    else ++grass;
                }
        }
    }
    CPPUNIT_ASSERT(air != grass);
}
