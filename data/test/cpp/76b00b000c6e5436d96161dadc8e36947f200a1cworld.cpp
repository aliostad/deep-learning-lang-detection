//Author: Samuel Börlin

#include "world.hpp"
#include "chunk.hpp"
#include <algorithm>
#include <iostream>
#include "engine.hpp"

World::World() {
	m_meshPerFrame = 1;
	m_generatePerFrame = 1;
}

World::~World() {
	for(int i = 0; i < m_vpChunks.size(); i++) {
		Chunk* pChunk = m_vpChunks[i];
		if(pChunk != nullptr) {
			delete pChunk;
			pChunk = nullptr;
		}
	}
}

Voxel* World::GetVoxel(int x, int y, int z) {
	int voxelX = x%Chunk::CHUNKSIZEX;
	int voxelY = y%Chunk::CHUNKSIZEY;
	int voxelZ = z%Chunk::CHUNKSIZEZ;
	if(voxelX < 0) voxelX += Chunk::CHUNKSIZEX;
	if(voxelY < 0) voxelY += Chunk::CHUNKSIZEY;
	if(voxelZ < 0) voxelZ += Chunk::CHUNKSIZEZ;
	int chunkX = (x-voxelX)/Chunk::CHUNKSIZEX;
	int chunkY = (y-voxelY)/Chunk::CHUNKSIZEY;
	int chunkZ = (z-voxelZ)/Chunk::CHUNKSIZEZ;
	Chunk* pChunk = GetChunk(chunkX, chunkY, chunkZ);
	if(pChunk != nullptr) {
		return pChunk->GetVoxel(voxelX, voxelY, voxelZ);
	}
	return nullptr;
}

inline Chunk* World::GetChunk(int x, int y, int z) {
	for(int i = 0; i < m_vpChunks.size(); i++) {
		Chunk* pChunk = m_vpChunks[i];
		if(pChunk != nullptr) {
			Chunk::ChunkPosition chunkPos = pChunk->GetPos();
			if(chunkPos.x == x && chunkPos.y == y && chunkPos.z == z) {
				return pChunk;
			}
		}
	}
	return nullptr;
}

Chunk* World::GetChunkWorldCoords(int x, int y, int z) {
	int voxelX = x%Chunk::CHUNKSIZEX;
	int voxelY = y%Chunk::CHUNKSIZEY;
	int voxelZ = z%Chunk::CHUNKSIZEZ;
	if(voxelX < 0) voxelX += Chunk::CHUNKSIZEX;
	if(voxelY < 0) voxelY += Chunk::CHUNKSIZEY;
	if(voxelZ < 0) voxelZ += Chunk::CHUNKSIZEZ;
	int chunkX = (x-voxelX)/Chunk::CHUNKSIZEX;
	int chunkY = (y-voxelY)/Chunk::CHUNKSIZEY;
	int chunkZ = (z-voxelZ)/Chunk::CHUNKSIZEZ;
	Chunk* pChunk = GetChunk(chunkX, chunkY, chunkZ);
	return pChunk;
}

Chunk* World::LoadChunk(Chunk::ChunkPosition chunkPosition) {
	Chunk* pChunk = new Chunk(chunkPosition.x, chunkPosition.y, chunkPosition.z, this);
	m_vpChunks.push_back(pChunk);
	m_vpChunksToGenerate.push_back(pChunk);
	m_vpChunksToMesh.push_back(pChunk);
	m_vpChunksToRender.push_back(pChunk);
	return pChunk;
}

bool World::UnloadChunk(Chunk::ChunkPosition chunkPosition) {
	Chunk* pChunk = GetChunk(chunkPosition.x, chunkPosition.y, chunkPosition.z);
	if(pChunk == nullptr) return false;
	m_vpChunks.erase(std::remove(m_vpChunks.begin(), m_vpChunks.end(), pChunk), m_vpChunks.end());
	m_vpChunksToGenerate.erase(std::remove(m_vpChunksToGenerate.begin(), m_vpChunksToGenerate.end(), pChunk), m_vpChunksToGenerate.end());
	m_vpChunksToMesh.erase(std::remove(m_vpChunksToMesh.begin(), m_vpChunksToMesh.end(), pChunk), m_vpChunksToMesh.end());
	m_vpChunksToRender.erase(std::remove(m_vpChunksToRender.begin(), m_vpChunksToRender.end(), pChunk), m_vpChunksToRender.end());
	delete pChunk;
	pChunk = nullptr;
	return true;
}

void World::RenderChunks() {
	for(int i = 0; i < m_vpChunksToRender.size(); i++) {
		Chunk* pChunk = m_vpChunksToRender[i];
		if(pChunk->MeshBuilt()) {
			pChunk->Render();
		}
	}
}

void World::RebuildChunkMeshes() {
	for(int i = 0; i < m_vpChunks.size(); i++) {
		Chunk* pChunk = m_vpChunks[i];
		pChunk->BuildMesh();
		//pChunk->RebuildNeighbours();
	}
}

struct SortByDistance {
	bool operator()(Chunk* c1, Chunk* c2) {
		glm::vec3 chunkPos1(c1->GetPos().x,c1->GetPos().y,c1->GetPos().z);
		glm::vec3 chunkPos2(c2->GetPos().x,c2->GetPos().y,c2->GetPos().z);
		glm::vec3 camPos((int)floor(Engine::m_pCameraInstance->GetPos().x / Chunk::CHUNKSIZEX), (int)floor(Engine::m_pCameraInstance->GetPos().y / Chunk::CHUNKSIZEY), (int)floor(Engine::m_pCameraInstance->GetPos().z / Chunk::CHUNKSIZEZ));
		return glm::distance(chunkPos1, camPos) < glm::distance(chunkPos2, camPos);
	}
};

void World::UpdateGenerateQueue() {
	std::sort(m_vpChunksToGenerate.begin(), m_vpChunksToGenerate.end(), SortByDistance());

	int count = 0;
	std::vector<Chunk*>::iterator it = m_vpChunksToGenerate.begin();
	while(it != m_vpChunksToGenerate.end()) {
		if(count >= m_generatePerFrame) break;
		Chunk* pChunk = *it;
		pChunk->GenerateVoxels();
		//it = m_vpChunksToGenerate.erase(std::remove(m_vpChunksToGenerate.begin(), m_vpChunksToGenerate.end(), pChunk), m_vpChunksToGenerate.end());
		//it++;
		m_vpChunksToGenerate.erase(it++);
		count++;
	}
}

void World::UpdateMeshQueue() {
	std::sort(m_vpChunksToMesh.begin(), m_vpChunksToMesh.end(), SortByDistance());

	int count = 0;
	std::vector<Chunk*>::iterator it = m_vpChunksToMesh.begin();
	while(it != m_vpChunksToMesh.end()) {
		if(count >= m_meshPerFrame) break;
		Chunk* pChunk = *it;
		pChunk->BuildMesh();
		pChunk->RebuildNeighbours();
		//it = m_vpChunksToGenerate.erase(std::remove(m_vpChunksToGenerate.begin(), m_vpChunksToGenerate.end(), pChunk), m_vpChunksToGenerate.end());
		//it++;
		m_vpChunksToMesh.erase(it++);
		count++;
	}
}

void World::UpdateRenderQueue() {

}

void World::UpdateQueues() {
	UpdateGenerateQueue();
	UpdateMeshQueue();
	UpdateRenderQueue();
}