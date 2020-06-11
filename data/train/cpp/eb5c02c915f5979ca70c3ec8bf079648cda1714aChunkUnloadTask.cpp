// ===================================================================
//	Copyright (C) 2013 Tim Leonard
// ===================================================================
#include "Game\Scene\Voxels\Tasks\ChunkUnloadTask.h"
#include "Game\Scene\Voxels\ChunkManager.h"

ChunkUnloadTask::ChunkUnloadTask(ChunkManager* manager, IntVector3 chunk_position)
	: m_manager(manager)
	, m_position(chunk_position)
{
	m_chunk = m_manager->Get_Chunk(m_position);
}

IntVector3 ChunkUnloadTask::Get_Chunk_Position()
{
	return m_position;
}

Chunk* ChunkUnloadTask::Get_Chunk()
{	
	return m_chunk;
}
	 
void ChunkUnloadTask::Run()
{
	m_chunk->Set_Status(ChunkStatus::Unloading);
		
	// Unload actual chunk.
	RegionFile* region = m_manager->Get_Region_File(m_chunk->Get_Region());
	region->Save_Chunk(m_chunk);

	// Unloaded!
	m_chunk->Set_Status(ChunkStatus::Unloaded);
}

