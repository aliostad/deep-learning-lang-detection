// ===================================================================
//	Copyright (C) 2013 Tim Leonard
// ===================================================================
#include "Game\Scene\Voxels\Tasks\ChunkRegenerateMeshTask.h"
#include "Game\Scene\Voxels\ChunkManager.h"
#include "Game\Scene\Voxels\Generation\ChunkGenerator.h"

#include "Generic\Threads\Thread.h"

ChunkRegenerateMeshTask::ChunkRegenerateMeshTask(ChunkManager* manager, Chunk* chunk, const ChunkManagerConfig& config)
	: m_manager(manager)
	, m_chunk(chunk)
	, m_config(config)
{
}

Chunk* ChunkRegenerateMeshTask::Get_Chunk()
{
	return m_chunk;
}
	 
void ChunkRegenerateMeshTask::Run()
{
	m_chunk->Calculate_Visible_Voxels();
}

