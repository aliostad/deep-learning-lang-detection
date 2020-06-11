#include "ChunkManager.h"

int ChunkManager::CHUNK_LOAD_PER_FRAME = 1;
int ChunkManager::CHUNK_REBUILD_PER_FRAME = 3;
int ChunkManager::ACTIVE_CHUNKS_SIZE = 12;

ChunkManager::ChunkManager(GLRenderer* renderer)
{
	pRenderer = renderer;
	mGenerator = new TerrainGenerator();

	mGenerator->setAmplitude(2.0);
	mGenerator->setFrequency(1.0);
	mGenerator->setOctaves(1.5);

	lastCameraPos = glm::vec3(0,0,0);
	lastCameraDir = glm::vec3(0,0,0);

	low_x = low_z = low_z = 0;
	chunkList.reserve(1000);

	initializeChunks();
}


ChunkManager::~ChunkManager(void)
{
	
}

void ChunkManager::initializeChunks()
{
	// initialize a ACTIVE_CHUNKS*ACTIVE_CHUNKS grid	
	float sizexz = ACTIVE_CHUNKS_SIZE;
	float sizey = TerrainChunk::TERRAIN_MAX_HEIGHT;
	for(int x = 0; x < ACTIVE_CHUNKS_SIZE; x++)
	{
		for(int z = 0; z < ACTIVE_CHUNKS_SIZE; z++)
		{
			TerrainChunk* terrainChunk = new TerrainChunk(this);
			std::vector<Chunk*> chunks;
			for(int y = 0; y < TerrainChunk::TERRAIN_MAX_HEIGHT; y++)
			{
				
				float percent = float(x)*sizexz*sizey + float(z)*sizey + y;
				percent = percent*100/(sizexz*sizexz*sizey);
				printf("Initializing chunks: %.2f %% \r", percent);
				Chunk* chunk = new Chunk(this, glm::vec3(x,y,z));
				chunk->load();
				chunk->setup();
				chunks.push_back(chunk);
				chunkList.push_back(chunk);
				rebuildList.push_back(chunk);
			}
			terrainChunk->setColumn(chunks);
			terrainChunk->generateTerrain(mGenerator);
		}
	}
	printf("Initializing chunks: 100 %%      ");
	printf("\n");
}

void ChunkManager::update(float dt, Camera* camera)
{
	loadChunks();
	setupChunks();
	rebuildChunks();
	unloadChunks();
	updateVisibleChunks(camera);

	if(camera->getPos() != lastCameraPos || camera->getDir() != lastCameraDir)
	{
		updateRenderList();
	}
	
	renderChunks();

	lastCameraPos = camera->getPos();
	lastCameraDir = camera->getDir();
}

void ChunkManager::loadChunks()
{
	int numLoaded = 0;
	std::vector<Chunk*>::iterator it;
	for(it = loadList.begin(); it != loadList.end() && numLoaded != CHUNK_LOAD_PER_FRAME; ++it)
	{	
		Chunk* chunk = (*it);
		if(!chunk->isLoaded())
		{
			chunk->load();
			numLoaded++;
		}
	}

	//Loadlist is cleared and rebuilt every frame
	loadList.clear();
}

void ChunkManager::setupChunks()
{
	std::vector<Chunk*>::iterator it;
	for(it = setupList.begin(); it != setupList.end(); ++it)
	{
		Chunk* chunk = (*it);
		if(!chunk->isSetup())
		{
			chunk->setup();
		}
	}

	setupList.clear();
}

void ChunkManager::rebuildChunks()
{
	int numRebuilt = 0;
	std::vector<Chunk*>::iterator it;
	for(it = rebuildList.begin(); it != rebuildList.end() && numRebuilt != CHUNK_REBUILD_PER_FRAME; ++it)
	{
		Chunk* chunk = (*it);
		if(chunk->isSetup() && chunk->isLoaded())
		{
		chunk->createMesh(pRenderer);
			
		/*glm::vec3 pos = chunk->getPos();
		int x = (int)pos.x;
		int y = (int)pos.y;
		int z = (int)pos.z;

		Chunk* x0 = getChunk(x-1,y  ,z  );
		Chunk* x1 = getChunk(x+1,y  ,z  );
		Chunk* y0 = getChunk(x  ,y-1,z  );
		Chunk* y1 = getChunk(x  ,y+1,z  );
		Chunk* z0 = getChunk(x  ,y  ,z-1);
		Chunk* z1 = getChunk(x  ,y  ,z+1);
			
		// Flag nearby chunks for renderupdate

		if(x0 != NULL)
			renderFlagList.push_back(x0);
		if(x1 != NULL)
			renderFlagList.push_back(x1);
		if(y0 != NULL)
			renderFlagList.push_back(y0);
		if(y1 != NULL)
			renderFlagList.push_back(y1);
		if(z0 != NULL)
			renderFlagList.push_back(z0);
		if(z1 != NULL)
			renderFlagList.push_back(z0);
		*/
		++numRebuilt;
		}
	}

	rebuildList.clear();	
	for(it = chunkList.begin(); it != chunkList.end(); ++it)
	{
		Chunk* chunk = (*it);
		if(!(chunk->isBuilt()) || chunk->hasChanged())
			rebuildList.push_back(chunk);
	}
}

void ChunkManager::unloadChunks()
{
	std::vector<Chunk*>::iterator it;	
	for(it = unloadList.begin(); it != unloadList.end(); ++it)
	{
		if((*it)->isLoaded())
			(*it)->unload();
	}
	unloadList.clear();
}

void ChunkManager::updateRenderList()
{
	std::vector<Chunk*>::iterator it;
	renderList.clear();

	for(it = visibilityList.begin(); it != visibilityList.end(); ++it)
	{
		Chunk* chunk = (*it);
		if(chunk->isFlaggedForRender())
		{
			//TODO: Do frustum check
			if(pRenderer->chunkInFrustum(chunk))
				renderList.push_back(chunk);
		}
	}
}

void ChunkManager::updateVisibleChunks(Camera* camera)
{
	visibilityList.clear();
	std::vector<Chunk*>::iterator it;
	for(it = chunkList.begin(); it != chunkList.end(); ++it)
	{
		Chunk* chunk = (*it);
		/*glm::vec3 pos = camera->getPos();

		float camera_x = pos.x;
		float camera_y = pos.y;
		float camera_z = pos.z;

		int chunk_x, chunk_y, chunk_z;
		getChunkCoordinates(camera_x, camera_y, camera_z, &chunk_x, &chunk_y, &chunk_z);*/
		visibilityList.push_back(chunk);
	}
}

void ChunkManager::renderChunks()
{
	std::vector<Chunk*>::iterator it;
	for(it = renderList.begin(); it != renderList.end(); ++it)
	{
		(*it)->render(pRenderer);
	}
	renderFlagList.clear();
}

Chunk* ChunkManager::getChunk(int x, int y, int z)
{
	int size = ChunkManager::ACTIVE_CHUNKS_SIZE;
	int index = (x-low_x) + (y-low_y)*size + (z-low_z)*size*size;

	if(index >= chunkList.size() || index < 0 )
		return NULL;
	return chunkList[index];
}

//Get a block from block-space coordinates
Block* ChunkManager::getBlock(int x, int y, int z)
{
	int sx, sy, sz, bx, by, bz;
	sx = 0; sy = 0; sz = 0;
	getChunkCoordinates(x, y, z, &sx, &sy, &sz);
	
	Chunk* chunk = getChunk(sx, sy, sz);

	int size = Chunk::CHUNK_SIZE;

	if(chunk != NULL)
	{
		bx = x - sx*size;
		by = y - sy*size;
		bz = z - sz*size;
		
		return chunk->getBlock(bx, by, bz);
	}
	return NULL;
}

// Convert block-space coordinates into chunk-space coordinates
void ChunkManager::getChunkCoordinates(float x, float y, float z, int* sx, int* sy, int* sz)
{
	*sx = x == 0 ? 0 : x > 0 ? (int)x/Chunk::CHUNK_SIZE : (int)x/Chunk::CHUNK_SIZE - 1;	
	*sy = y == 0 ? 0 : y > 0 ? (int)y/Chunk::CHUNK_SIZE : (int)y/Chunk::CHUNK_SIZE - 1;	
	*sz = z == 0 ? 0 : z > 0 ? (int)z/Chunk::CHUNK_SIZE : (int)z/Chunk::CHUNK_SIZE - 1;	
} 

TerrainGenerator* ChunkManager::getTerrainGenerator()
{
	return mGenerator;
}

GLRenderer* ChunkManager::getRenderer()
{
	return pRenderer;
}