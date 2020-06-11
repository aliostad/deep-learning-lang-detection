//
// Created by Eugene Sturm on 4/9/15.
//

#include "ChunkManager.h"

ChunkManager::ChunkManager(ChunkRenderer* chunk_renderer) : _chunk_renderer(chunk_renderer) {
        ASSERT(_chunk_renderer, "null chunk renderer");

        Chunk* chunk = new Chunk();
        chunk->pos = glm::vec3(0, 0, 0);
        BuildChunk(chunk);
        _chunk_renderer->BuildMesh(chunk);
        _chunk_renderer->RegisterChunk(chunk);
        _chunks.push_back(chunk);
}

ChunkManager::~ChunkManager() {
    for(Chunk* chunk : _chunks) {
        delete chunk;
    }
}

void ChunkManager::BuildChunk(Chunk* chunk) {
    uint32_t chunkVoxelCount = k_chunkVoxelDims.x * k_chunkVoxelDims.y * k_chunkVoxelDims.z;
    chunk->voxels = new Voxel[chunkVoxelCount];
    chunk->num_voxels = chunkVoxelCount;
    uint32_t ground_voxel_count = 0;
    float z = chunk->pos.z + ((k_chunkDims.z / 2.f) - (k_voxelDims.z / 2.f));
    for (uint32_t k = 0; k < k_chunkVoxelDims.z; ++k) {
        float y = chunk->pos.y + ((k_chunkDims.y / 2.f) - (k_voxelDims.y / 2.f));
        for (uint32_t j = 0; j < k_chunkVoxelDims.y; ++j) {
            float x = chunk->pos.x + ((-1.f * k_chunkDims.x / 2.f) + (k_voxelDims.x / 2.f));
            for (uint32_t i = 0; i < k_chunkVoxelDims.x; ++i) {
                float density = 1.f;//_perlin.noise3D(x, y, z, noiseScale);
                //LOG_D("chunk", "x:" << x << " y:" << y << " z:" << z << " -> " << density);
                uint32_t idx = i + (j * k_chunkVoxelDims.y) + (k * k_chunkVoxelDims.y * k_chunkVoxelDims.z);
                if (density >= 0.f) {
                    chunk->voxels[idx].id = GROUND_VOXEL;
                    ground_voxel_count++;
                }
                else {
                    chunk->voxels[idx].id = AIR_VOXEL;
                }

                x += k_voxelDims.x * 1;
            }
            y -= k_voxelDims.y * 1;
        }
        z -= k_voxelDims.z * 1;
    }

    _chunk_renderer->BuildMesh(chunk);
}