// ===================================================================
//	Copyright (C) 2013 Tim Leonard
// ===================================================================
#include "Game\Scene\Voxels\Tasks\ChunkLoadTask.h"
#include "Game\Scene\Voxels\ChunkManager.h"
#include "Game\Scene\Voxels\Generation\ChunkGenerator.h"

#include "Generic\Threads\Thread.h"

ChunkLoadTask::ChunkLoadTask(ChunkManager* manager, IntVector3 chunk_position, const ChunkManagerConfig& config)
	: m_manager(manager)
	, m_position(chunk_position)
	, m_chunk(NULL)
	, m_config(config)
{
}

IntVector3 ChunkLoadTask::Get_Chunk_Position()
{
	return m_position;
}

Chunk* ChunkLoadTask::Get_Chunk()
{
	return m_chunk;
}
	 
void ChunkLoadTask::Run()
{
	// Wait until we have some memory for this chunk (we may need to wait for another
	// chunk to be unloaded).
	void* mem = NULL;
	while (true)
	{
		mem = m_manager->Get_Chunk_Memory_Pool().Allocate();
		if (mem != NULL)
		{
			break;
		}

		Thread::Get_Current()->Sleep(0.01f);
	}
				
	Chunk* chunk = new(mem) Chunk  (m_manager, m_position.X, m_position.Y, m_position.Z, 
									m_config.chunk_size.X, m_config.chunk_size.Y, m_config.chunk_size.Z,
									m_config.voxel_size.X, m_config.voxel_size.Y, m_config.voxel_size.Z);

	chunk->Set_Status(ChunkStatus::Loading);
		
	// Load actual chunk.
	RegionFile* region = m_manager->Get_Region_File(chunk->Get_Region());
	if (region->Contains_Chunk(chunk))
	{
		region->Load_Chunk(chunk);
	}
	else
	{
		// Generate a procedural chunk.
		ChunkGenerator generator(m_manager, m_config);
		generator.Generate(chunk);

		// Save generated result.
		region->Save_Chunk(chunk);
	}
				
	// Loaded!
	chunk->Set_Status(ChunkStatus::Loaded);
	chunk->Recalculate_State();

	// Done, store result!
	m_chunk = chunk;
}

