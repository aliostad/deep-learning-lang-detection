#include "world.h"

World::World(Player* player)
{
    
    this->player = player;

}

World::~World()
{

    std::map<std::array<int, 3>, Chunk*>::iterator it = chunks.begin();

    while(it != chunks.end())
    {

        delete it->second;
        chunks.erase(it++);

    }

}

void World::update()
{
    
    Chunk* oldChunk = getChunk(player->getOldX(), player->getOldY(), player->getOldZ());
    Chunk* currentChunk = getChunk(player->getX(), player->getY(), player->getZ());
        
    std::map<std::array<int, 3>, Chunk*>::iterator it = chunks.begin();
    
    if(currentChunk->getX() != oldChunk->getX() || currentChunk->getY() != oldChunk->getY() || currentChunk->getZ() != oldChunk->getZ())
    {
            
        while(it != chunks.end())
        {
                
            if(isInViewFrustum(*it->second))
            {
                
                if(!it->second->getGenerated())
                {
                    
                    generate(*it->second);
                    it->second->setGenerated(true);
                        
                }
                
                it->second->update();
                it++;
                
            }
            else
            {
            
                delete it->second;
                chunks.erase(it++);
                
            }
            
        }
        
        for(int i = currentChunk->getX() - 4; i <= currentChunk->getX() + 4; i++)
        {
            
            for(int j = currentChunk->getY() - 4; j <= currentChunk->getY() + 4; j++)
            {
                
                for(int k = currentChunk->getZ() - 4; k < currentChunk->getZ() + 4; k++)
                {
                
                    setChunk(i, j, k);
                    
                }
                
            }
            
        }
        
    }
    else
    {
        
        while(it != chunks.end())
        {
                
            if(isInViewFrustum(*it->second))
            {
                
                if(!it->second->getGenerated())
                {
                    
                    generate(*it->second);
                    it->second->setGenerated(true);
                        
                }
                
                it->second->update();
                
            }
            
            it++;
            
        }
        
    }

}

void World::render()
{

    for(std::map<std::array<int, 3>, Chunk*>::iterator it = chunks.begin(); it != chunks.end(); it++)
    {
        
        it->second->render();

    }

}

Chunk* World::getChunk(int x, int y, int z)
{
    
    float modifiedX = (float)x / (float)CHUNK_WIDTH;
    float modifiedY = (float)y / (float)CHUNK_WIDTH;
    float modifiedZ = (float)z / (float)CHUNK_WIDTH;

    int chunkX = (modifiedX < 0.0f) ? ceil(modifiedX - 0.5f) : floor(modifiedX + 0.5f);
    int chunkY = (modifiedY < 0.0f) ? ceil(modifiedY - 0.5f) : floor(modifiedY + 0.5f);
    int chunkZ = (modifiedZ < 0.0f) ? ceil(modifiedZ - 0.5f) : floor(modifiedZ + 0.5f);
    
    std::array<int, 3> chunkName = {chunkX, chunkY, chunkZ};
    
    if(chunks.find(chunkName) == chunks.end())
    {

        chunks[chunkName] = new Chunk(chunkX, chunkY, chunkZ);

    }

    return chunks[chunkName];

}

void World::setChunk(int x, int y, int z)
{

    std::array<int, 3> chunkName = {x, y, z};

    chunks[chunkName] = new Chunk(x, y, z);
    
}

Block* World::getBlock(int x, int y, int z)
{

    return getChunk(x, y, z)->getBlock(x, y, z);

}

void World::setBlock(int x, int y, int z, bool air)
{

    getChunk(x, y, z)->setBlock(x, y, z, air);

}

void World::generate(Chunk& chunk)
{
    
    if(chunk.getY() < 0)
    {
        
        for(int i = chunk.getX() * CHUNK_WIDTH - CHUNK_WIDTH / 2; i < chunk.getX() * CHUNK_WIDTH + CHUNK_WIDTH / 2; i++)
        {
            
            for(int j = chunk.getY() * CHUNK_WIDTH - CHUNK_WIDTH / 2; j < chunk.getY() * CHUNK_WIDTH + CHUNK_WIDTH / 2; j++)
            {
                
                for(int k = chunk.getZ() * CHUNK_WIDTH - CHUNK_WIDTH / 2; k < chunk.getZ() * CHUNK_WIDTH + CHUNK_WIDTH / 2; k++)
                {
                
                    chunk.setBlock(i, j, k, false);
                
                }
                
            }
            
        }

    }
    
}

bool World::isInViewFrustum(const Chunk& chunk) const
{
    
    return player->getFrustum().isInViewFrustum(Vector3(chunk.getX() * CHUNK_WIDTH, chunk.getY() * CHUNK_WIDTH, chunk.getZ() * CHUNK_WIDTH), CHUNK_WIDTH / 2);
    
}
