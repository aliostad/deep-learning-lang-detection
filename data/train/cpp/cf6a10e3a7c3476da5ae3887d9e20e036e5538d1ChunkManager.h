//
// Created by Eugene Sturm on 4/9/15.
//

#ifndef DG_CHUNKMANAGER_H
#define DG_CHUNKMANAGER_H


#include <glm/glm.hpp>
#include <glm/gtc/type_ptr.hpp>
#include "gfx/gl/RenderDeviceGL.h"
#include "IFeatureRenderer.h"
#include "Assert.h"
#include "Camera.h"
#include "Chunk.h"
#include "ChunkRenderer.h"

class ChunkManager {
private:
    ChunkRenderer* _chunk_renderer { 0 };
    std::vector<Chunk*> _chunks;
public:
    ChunkManager(ChunkRenderer* chunk_renderer);
    ~ChunkManager();
private:
    void BuildChunk(Chunk* chunk);
};


#endif //DG_CHUNKMANAGER_H
