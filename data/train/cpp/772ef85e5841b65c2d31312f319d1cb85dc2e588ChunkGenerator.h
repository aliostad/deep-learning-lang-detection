// ===================================================================
//	Copyright (C) 2013 Tim Leonard
// ===================================================================
#ifndef _GAME_SCENE_VOXELS_GENERATION_CHUNK_GENERATOR_
#define _GAME_SCENE_VOXELS_GENERATION_CHUNK_GENERATOR_

#include "Game\Scene\Voxels\ChunkManagerConfig.h"

class Chunk;
class ChunkManager;
class Noise;
class NoiseSampler3D;

class ChunkGenerator
{
private:
	const ChunkManagerConfig&	m_config;

	ChunkManager*				m_manager;
	Chunk*						m_chunk;

	Noise*						m_terrain_base_noise;
	NoiseSampler3D*				m_terrain_base_noise_sampler;

	IntVector3					m_chunk_position;
	Vector3						m_chunk_world_position;

	Vector3						m_scale_factor;

protected:

	void Place_Terrain();

public:
	ChunkGenerator(ChunkManager* manager, const ChunkManagerConfig& config);
	~ChunkGenerator();
	
	void Generate(Chunk* chunk);

};

#endif

