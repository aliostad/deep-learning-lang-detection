/*
 * ChunkCache.h
 *
 *  Created on: Apr 15, 2013
 *      Author: nils
 */

#ifndef CHUNKCACHE_H_
#define CHUNKCACHE_H_

#include <list>

#include "GraphicsSystem/GraphicsContext.h"
#include "ChunkGenerator.h"
#include "TerrainChunk.h"

class CacheRequest
{
public:
	TerrainChunk* m_Requester;
};

class ChunkCache
{
private:
	ChunkGenerator* m_Generator;

	std::list<CacheRequest*> m_Requests;
	std::list<TerrainChunk*> m_ActiveChunks;
public:
	ChunkCache(GraphicsContext* ctx,const char* filename);
	virtual ~ChunkCache();

	void update();

	void newRequest(TerrainChunk* parent);
};

#endif /* CHUNKCACHE_H_ */
