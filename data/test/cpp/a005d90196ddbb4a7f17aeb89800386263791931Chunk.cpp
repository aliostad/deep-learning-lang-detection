#include "Precomp.h"

#include "Chunk.h"

#include "ChunkManager.h"

#include "opengl/Mesh.h"
#include "resources/ResourceCache.h"
#include <boost/foreach.hpp>

const Block Chunk::EMPTY_BLOCK=Block();

Chunk::Chunk(ChunkManager *chunkManager,const glm::ivec3 &position, const uint32_t & offset)
{
    _chunkManager = chunkManager;
    this->position = position;
    this->offset=offset;

    // Create the blocks
    _blocks.reserve(CHUNK_BLOCK_SIZE);
    loop(i,CHUNK_BLOCK_SIZE)
    {
        _blockIndices[i]=-1;
    }


    empty=true;
    generated=built=uploaded=false;

    leftN=rightN=botN=topN=backN=frontN=nullptr;
}

Chunk::~Chunk()
{
    freeVector(_blocks);
}

void Chunk::UpdateNeighbours(uint32_t x, uint32_t y, uint32_t z)
{
    if(x==0&&leftN!=nullptr)
    {
        leftN->built=false;
        leftN->uploaded=false;
    }
    if(x==CHUNK_SIZE-1&&rightN!=nullptr)
    {
        leftN->built=false;
        leftN->uploaded=false;
    }

    if(y==0&&botN!=nullptr)
    {
        botN->built=false;
        botN->uploaded=false;
    }
    if(y==CHUNK_SIZE-1&&topN!=nullptr)
    {
        topN->built=false;
        topN->uploaded=false;
    }

    if(z==0&&backN!=nullptr)
    {
        backN->built=false;
        backN->uploaded=false;
    }
    if(z==CHUNK_SIZE-1&&frontN!=nullptr)
    {
        frontN->built=false;
        frontN->uploaded=false;
    }
}

void Chunk::SetBlock(uint32_t x,uint32_t y,uint32_t z,EBlockType type,bool active)
{
    if(x<0||x>=CHUNK_SIZE||y<0||y>=CHUNK_SIZE||z<0||z>=CHUNK_SIZE) return;

    int32_t ind=_blockIndices[x+y*CHUNK_SIZE+z*CHUNK_SIZE*CHUNK_SIZE];

    Block blockToAdd=EMPTY_BLOCK;
    blockToAdd.type=type;
    blockToAdd.active=active;

    if(ind!=-1) //block already exists
    {
        _blocks[ind]=blockToAdd;
    }
    else //add a new one to the vector
    {
        _blocks.push_back(blockToAdd);
        _blockIndices[x+y*CHUNK_SIZE+z*CHUNK_SIZE*CHUNK_SIZE]=_blocks.size()-1;
        empty=false;
    }

    UpdateNeighbours(x,y,z);
}

const Block &Chunk::GetBlock(uint32_t x,uint32_t y,uint32_t z)
{
    if(!((x>CHUNK_SIZE-1||x<0)||(y>CHUNK_SIZE-1||y<0)||(z>CHUNK_SIZE-1||z<0)))
    {
        int32_t ind=_blockIndices[x+y*CHUNK_SIZE+z*CHUNK_SIZE*CHUNK_SIZE];
        if(ind!=-1)
            return _blocks[ind];
    }
    return EMPTY_BLOCK;
}

void Chunk::Fill()
{
    for (int z = 0; z < CHUNK_SIZE; z++)
    {
        for (int y = 0; y < CHUNK_SIZE; y++)
        {
            for (int x = 0; x < CHUNK_SIZE; x++)
            {
                SetBlock(x,y,z,EBT_STONE,true);
            }
        }
    }
}

void Chunk::FillCheckerboard()
{
    loop(x,CHUNK_SIZE)
    loop(y,CHUNK_SIZE)
    loop(z,CHUNK_SIZE)
    {
        SetBlock(x,y,z,(EBlockType)(rand()%EBT_COUNT),true);
    }

    generated=true;
}

uint32_t Chunk::GetBlockCount()
{
    uint32_t ret=0;

    for (int x = 0; x < CHUNK_SIZE; x++)
    {
        for (int z = 0; z < CHUNK_SIZE; z++)
        {
            for (int y = 0; y < CHUNK_SIZE; y++)
            {
                if(GetBlock(x,y,z).active) ret++;
            }
        }
    }

    return ret;
}

const Block & Chunk::ElementAt(int32_t x,int32_t y, int32_t z)
{
    if(x<0&&leftN!=nullptr)
    {
        return leftN->ElementAt(CHUNK_SIZE-1,y,z);
    }
    else if(x>CHUNK_SIZE-1&&rightN!=nullptr)
    {
        return rightN->ElementAt(0,y,z);
    }
    else if(y<0&&botN!=nullptr)
    {
        return botN->ElementAt(x,CHUNK_SIZE-1,z);
    }
    else if(y>CHUNK_SIZE-1&&topN!=nullptr)
    {
        return topN->ElementAt(x,0,z);
    }
    else if(z<0&&backN!=nullptr)
    {
        return backN->ElementAt(x,y,CHUNK_SIZE-1);
    }
    else if(z>CHUNK_SIZE-1&&frontN!=nullptr)
    {
        return frontN->ElementAt(x,y,0);
    }
    else if(x<0||y<0||z<0||x>CHUNK_SIZE-1||y>CHUNK_SIZE-1||z>CHUNK_SIZE-1)
    {
        return EMPTY_BLOCK;
    }
    else
    {
        return GetBlock(x,y,z);
    }
}

