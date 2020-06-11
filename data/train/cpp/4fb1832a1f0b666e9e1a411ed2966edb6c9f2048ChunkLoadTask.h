// ===================================================================
//	Copyright (C) 2013 Tim Leonard
// ===================================================================
#ifndef _GAME_SCENE_VOXELS_TASKS_CHUNKLOADTASK_
#define _GAME_SCENE_VOXELS_TASKS_CHUNKLOADTASK_

#include "Engine\Tasks\Task.h"

#include "Generic\Types\IntVector3.h"

#include "Game\Scene\Voxels\Generation\ChunkGenerator.h"

class Chunk;
class ChunkManager;

class ChunkLoadTask : public Task
{
private:	
	ChunkManager*				m_manager;
	Chunk*						m_chunk;
	IntVector3					m_position;
	const ChunkManagerConfig&	m_config;

public:
	ChunkLoadTask(ChunkManager* manager, IntVector3 chunk_position, const ChunkManagerConfig& config);

	IntVector3 Get_Chunk_Position();
	Chunk*	   Get_Chunk();
	 
	void Run();

};

#endif

