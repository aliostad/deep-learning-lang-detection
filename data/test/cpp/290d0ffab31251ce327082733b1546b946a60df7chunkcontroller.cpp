#include "chunkcontroller.h"
#include <ctime>

ChunkController::ChunkController(GLfloat value1, GLfloat value2, QObject* parent) : QThread(parent)
{
	cellSize = 5.0f;
	bushSize = 0.75f;
	treeScaleCoefficient = 0.5f;
	xTrn = value1;
	zTrn = value2;
}

GLfloat ChunkController::getCellSize()
{
	return cellSize;
}

GLfloat ChunkController::getBushSize()
{
	return bushSize;
}

GLfloat ChunkController::getTreeScaleCoefficient()
{
	return treeScaleCoefficient;
}

Chunk* ChunkController::getChunk(int id)
{
	return (chunk + id);
}

void ChunkController::setXTrn(GLfloat value)
{
	xTrn = value;
}

void ChunkController::setZTrn(GLfloat value)
{
	zTrn = value;
}

void ChunkController::run()
{
	srand(time(NULL));
	if(-xTrn > (MAP_SIZE - 1) * cellSize * 0.5f)
	{
		chunk[0] = chunk[1];
		emit ready(0);
		
		chunk[3] = chunk[4];
		emit ready(3);
		
		chunk[6] = chunk[7];
		emit ready(6);
		
		chunk[1] = chunk[2];
		emit ready(1);
		
		chunk[4] = chunk[5];
		emit ready(4);
		
		chunk[7] = chunk[8];
		emit ready(7);
		
		chunk[2].clear();
		chunk[2].setSide(Chunk::Left, chunk[1].heightMap);
		chunk[2].generate();
		emit ready(2);
		
		chunk[5].clear();
		chunk[5].setSide(Chunk::Left, chunk[4].heightMap);
		chunk[5].setSide(Chunk::Bottom, chunk[2].heightMap);
		chunk[5].generate();
		emit ready(5);
		
		chunk[8].clear();
		chunk[8].setSide(Chunk::Left, chunk[7].heightMap);
		chunk[8].setSide(Chunk::Bottom, chunk[5].heightMap);
		chunk[8].generate();
		emit ready(8);
	}
	if(-xTrn < -(MAP_SIZE - 1) * cellSize * 0.5f)
	{
		chunk[2] = chunk[1];
		emit ready(2);
		
		chunk[5] = chunk[4];
		emit ready(5);
		
		chunk[8] = chunk[7];
		emit ready(8);
		
		chunk[1] = chunk[0];
		emit ready(1);
		
		chunk[4] = chunk[3];
		emit ready(4);
		
		chunk[7] = chunk[6];
		emit ready(7);
		
		chunk[0].clear();
		chunk[0].setSide(Chunk::Right, chunk[1].heightMap);
		chunk[0].generate();
		emit ready(0);
		
		chunk[3].clear();
		chunk[3].setSide(Chunk::Right, chunk[4].heightMap);
		chunk[3].setSide(Chunk::Bottom, chunk[0].heightMap);
		chunk[3].generate();
		emit ready(3);
		
		chunk[6].clear();
		chunk[6].setSide(Chunk::Right, chunk[7].heightMap);
		chunk[6].setSide(Chunk::Bottom, chunk[3].heightMap);
		chunk[6].generate();
		emit ready(6);
	}
	if(-zTrn > (MAP_SIZE - 1) * cellSize * 0.5f)
	{
		chunk[0] = chunk[3];
		emit ready(0);
		
		chunk[1] = chunk[4];
		emit ready(1);
		
		chunk[2] = chunk[5];
		emit ready(2);
		
		chunk[3] = chunk[6];
		emit ready(3);
		
		chunk[4] = chunk[7];
		emit ready(4);
		
		chunk[5] = chunk[8];
		emit ready(5);
		
		chunk[6].clear();
		chunk[6].setSide(Chunk::Bottom, chunk[3].heightMap);
		chunk[6].generate();
		emit ready(6);
		
		chunk[7].clear();
		chunk[7].setSide(Chunk::Left, chunk[6].heightMap);
		chunk[7].setSide(Chunk::Bottom, chunk[4].heightMap);
		chunk[7].generate();
		emit ready(7);
		
		chunk[8].clear();
		chunk[8].setSide(Chunk::Left, chunk[7].heightMap);
		chunk[8].setSide(Chunk::Bottom, chunk[5].heightMap);
		chunk[8].generate();
		emit ready(8);
	}
	if(-zTrn < -(MAP_SIZE - 1) * cellSize * 0.5f)
	{
		chunk[6] = chunk[3];
		emit ready(6);
		
		chunk[7] = chunk[4];
		emit ready(7);
		
		chunk[8] = chunk[5];
		emit ready(8);
		
		chunk[3] = chunk[0];
		emit ready(3);
		
		chunk[4] = chunk[1];
		emit ready(4);
		
		chunk[5] = chunk[2];
		emit ready(5);
		
		chunk[0].clear();
		chunk[0].setSide(Chunk::Top, chunk[3].heightMap);
		chunk[0].generate();
		emit ready(0);
		
		chunk[1].clear();
		chunk[1].setSide(Chunk::Top, chunk[4].heightMap);
		chunk[1].setSide(Chunk::Left, chunk[0].heightMap);
		chunk[1].generate();
		emit ready(1);
		
		chunk[2].clear();
		chunk[2].setSide(Chunk::Top, chunk[5].heightMap);
		chunk[2].setSide(Chunk::Left, chunk[1].heightMap);
		chunk[2].generate();
		emit ready(2);
	}
}

void ChunkController::generateMap()
{	
	for(int i = 0; i < 9; ++i)
	{
		chunk[i].clear();
	}
	
	chunk[0].generate();
	emit ready(0);
	
	chunk[1].setSide(Chunk::Left, chunk[0].heightMap);
	chunk[1].generate();
	emit ready(1);
	
	chunk[2].setSide(Chunk::Left, chunk[1].heightMap);
	chunk[2].generate();
	emit ready(2);
	
	chunk[3].setSide(Chunk::Bottom, chunk[0].heightMap);
	chunk[3].generate();
	emit ready(3);
	
	chunk[4].setSide(Chunk::Bottom, chunk[1].heightMap);
	chunk[4].setSide(Chunk::Left, chunk[3].heightMap);
	chunk[4].generate();
	emit ready(4);
	
	chunk[5].setSide(Chunk::Bottom, chunk[2].heightMap);
	chunk[5].setSide(Chunk::Left, chunk[4].heightMap);
	chunk[5].generate();
	emit ready(5);
	
	chunk[6].setSide(Chunk::Bottom, chunk[3].heightMap);
	chunk[6].generate();
	emit ready(6);
	
	chunk[7].setSide(Chunk::Bottom, chunk[4].heightMap);
	chunk[7].setSide(Chunk::Left, chunk[6].heightMap);
	chunk[7].generate();
	emit ready(7);
	
	chunk[8].setSide(Chunk::Bottom, chunk[5].heightMap);
	chunk[8].setSide(Chunk::Left, chunk[7].heightMap);
	chunk[8].generate();
	emit ready(8);
}