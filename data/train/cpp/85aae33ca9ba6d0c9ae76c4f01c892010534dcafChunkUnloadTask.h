// ===================================================================
//	Copyright (C) 2013 Tim Leonard
// ===================================================================
#ifndef _GAME_SCENE_VOXELS_TASKS_CHUNKUNLOADTASK_
#define _GAME_SCENE_VOXELS_TASKS_CHUNKUNLOADTASK_

#include "Engine\Tasks\Task.h"

#include "Generic\Types\IntVector3.h"

class Chunk;
class ChunkManager;

class ChunkUnloadTask : public Task
{
private:
	ChunkManager* m_manager;
	IntVector3 m_position;
	Chunk* m_chunk;

public:
	ChunkUnloadTask(ChunkManager* manager, IntVector3 chunk_position);

	IntVector3 Get_Chunk_Position();
	Chunk*	   Get_Chunk();

	void Run();

};

#endif

