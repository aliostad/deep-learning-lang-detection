#include <cstdlib>
#include <cstring>

#include <iostream>
#include <vector>

#include "../Block/Block.hpp"
#include "Chunk.hpp"
#include "ChunkManager.hpp"
#include "LocalChunkSystem.hpp"

#define DEBUG_GRAPH

bool Chunk::isStrictelyInside(const sf::Vector3i & blockPosition)
{
	return blockPosition.x > 0 && blockPosition.y > 0 && blockPosition.z > 0 &&
			blockPosition.x < SIZE_1 && blockPosition.y < SIZE_1 && blockPosition.z < SIZE_1;
}



Chunk::Chunk() : mPosition(), mNeedRebuild(false), mIsModified(false)
{
	mData = new ChunkData();
}

void Chunk::reset() {
	mPosition.x=mPosition.y=mPosition.z=0x7FFFFFFF;
	mIsModified = false;
}


const ChunkCoordinate & Chunk::getPosition() const
{
	return mPosition;
}

void Chunk::setPosition(const ChunkCoordinate &position)
{
	mPosition = position;
}

bool Chunk::rebuild()
{
	if (hasData() && mNeedRebuild) {
		const LocalChunkSystem local(*mManager, this);
		mData->rebuild(local);
		mNeedRebuild = false;
		return true;
	}
	return false;
}

void Chunk::draw(const MeshDetail detail) const
{
#ifdef DEBUG_GRAPH
	glDisable(GL_LIGHTING);
	if (!hasData())
		glBegin(GL_POINTS);
	else
		glBegin(GL_LINES);
	
		if (!hasData())
			glColor3f(1,.7,1);
		else	
			glColor3f(.7,detail,detail/2.0);
		glVertex3f(0,0,0);glVertex3f(Chunk::SIZE ,0,0);
		glVertex3f(0,0,0);glVertex3f(0,Chunk::SIZE,0);
		glVertex3f(0,0,0);glVertex3f(0,0,Chunk::SIZE);
		
		glVertex3f(Chunk::SIZE,Chunk::SIZE,Chunk::SIZE);glVertex3f(Chunk::SIZE,0,Chunk::SIZE);
		glVertex3f(Chunk::SIZE,Chunk::SIZE,Chunk::SIZE);glVertex3f(0,Chunk::SIZE,Chunk::SIZE);
		glVertex3f(Chunk::SIZE,Chunk::SIZE,Chunk::SIZE);glVertex3f(Chunk::SIZE,Chunk::SIZE,0);
		
		glVertex3f(Chunk::SIZE,0,0);glVertex3f(Chunk::SIZE,Chunk::SIZE,0);
		glVertex3f(Chunk::SIZE,0,0);glVertex3f(Chunk::SIZE,0,Chunk::SIZE);
		glVertex3f(Chunk::SIZE,0,Chunk::SIZE);glVertex3f(0,0,Chunk::SIZE);
		
		glVertex3f(0,Chunk::SIZE,0);glVertex3f(Chunk::SIZE,Chunk::SIZE,0);
		glVertex3f(0,Chunk::SIZE,0);glVertex3f(0,Chunk::SIZE,Chunk::SIZE);
		glVertex3f(0,Chunk::SIZE,Chunk::SIZE);glVertex3f(0,0,Chunk::SIZE);
	glEnd();
	glEnable(GL_LIGHTING);
#endif
	
	if (hasData())
		mData->getMesh().draw(detail);
	
}

void Chunk::load()
{
	// load from file or generate
	mManager->loadChunk(this);
	
}



void Chunk::beginSet(bool playerAction)
{
	mIsModified = playerAction;	
}


void Chunk::endSet()
{
	//rebuild();
	mNeedRebuild = true;
}


void Chunk::setOne(const BlockCoordinate &pos, Block & block)
{
	beginSet(true);
	set(pos, block);
	endSet();
}




void Chunk::unload()
{
	// TODO : implement persistence
}

Chunk::~Chunk()
{
	if (mData != 0)
		delete mData;
}
