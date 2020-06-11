#include <Client/EmbeddedTilemap.hpp>
#include <Client/EmbeddedChunk.hpp>
#include <easylogging++.h>

namespace Client
{
    EmbeddedTilemap::EmbeddedTilemap()
    {
        for(std::size_t i = 0; i < layerCount; ++i)
        {
            m_layers[i] = std::map<int, std::map<int, std::unique_ptr<EmbeddedChunk> > >();
        }
    }
    EmbeddedTilemap::~EmbeddedTilemap()
    {

    }
    void EmbeddedTilemap::clear()
    {
        for(auto &layer : m_layers)
        {
            for(auto &chunks : layer)
            {
                for(auto &chunk : chunks.second)
                {
                    chunk.second->reset();
                }
            }
        }
    }
    void EmbeddedTilemap::setTile(int x, int y, int z, uint8_t tile)
    {
        int chunkX = x / EmbeddedChunk::width, chunkY = y / EmbeddedChunk::width;
        int tileX = x % EmbeddedChunk::width, tileY = y % EmbeddedChunk::width;
        if(!chunkExists(chunkX, chunkY, z))
        {
            createChunk(chunkX, chunkY, z);
        }
        m_layers[z][chunkX][chunkY]->setTile(tileX, tileY, tile);
    }
    uint8_t EmbeddedTilemap::getTile(int x, int y, int z)
    {
        int chunkX = x / EmbeddedChunk::width, chunkY = y / EmbeddedChunk::width;
        if(chunkExists(chunkX, chunkY, z))
        {
            int tileX = x % EmbeddedChunk::width, tileY = y % EmbeddedChunk::width;
            return m_layers[z][chunkX][chunkY]->getTile(tileX, tileY);
        }
        return 0;
    }
    void EmbeddedTilemap::setTileUserdata(int x, int y, int z, uint8_t tile)
    {
        int chunkX = x / EmbeddedChunk::width, chunkY = y / EmbeddedChunk::width;
        int tileX = x % EmbeddedChunk::width, tileY = y % EmbeddedChunk::width;
        if(!chunkExists(chunkX, chunkY, z))
        {
            createChunk(chunkX, chunkY, z);
        }
        m_layers[z][chunkX][chunkY]->setTileUserdata(tileX, tileY, tile);
    }
    uint8_t EmbeddedTilemap::getTileUserdata(int x, int y, int z)
    {
        int chunkX = x / EmbeddedChunk::width, chunkY = y / EmbeddedChunk::width;
        if(chunkExists(chunkX, chunkY, z))
        {
            int tileX = x % EmbeddedChunk::width, tileY = y % EmbeddedChunk::width;
            return m_layers[z][chunkX][chunkY]->getTileUserdata(tileX, tileY);
        }
        return 0;
    }
    void EmbeddedTilemap::render(Window *window, const glm::ivec2 &offset)
    {
        for(std::size_t z = 0; z < layerCount - 1; ++z)
        {
            for(auto &chunks : m_layers[z])
            {
                for(auto &chunk : chunks.second)
                {
                    chunk.second->render(window, chunks.first * EmbeddedChunk::width * EmbeddedChunk::tileWidth + offset.x,
                                         chunk.first * EmbeddedChunk::width * EmbeddedChunk::tileWidth + offset.y);
                }
            }
        }
    }
    EmbeddedTilemap::CollisionTypes EmbeddedTilemap::getCollisionOf(int x, int y)
    {
        //Return the uppest layer tile at that position - this layer is reserved for collision data.
        return static_cast<CollisionTypes>((unsigned int) getTile(x, y, layerCount - 1));
    }
    void EmbeddedTilemap::setCollisionOf(int x, int y, CollisionTypes collisionType)
    {
        setTile(x, y, layerCount - 1, static_cast<uint8_t>((unsigned int) collisionType));
    }
    void EmbeddedTilemap::setTextureForLayer(std::shared_ptr<Texture> texture, int z)
    {
        if(z >= 0 && z < layerCount - 1)
        {
            m_textures[z] = texture;
            for(auto &chunks : m_layers[z])
            {
                for(auto &chunk : chunks.second)
                {
                    chunk.second->setTexture(texture);
                }
            }
        }
    }
    bool EmbeddedTilemap::chunkExists(int chunkX, int chunkY, int z)
    {
        if(z >= 0 && z < m_layers.size())
        {
            if(m_layers[z].count(chunkX) > 0)
            {
                if(m_layers[z][chunkX].count(chunkY) > 0)
                {
                    return true;
                }
            }
        }
        return false;
    }
    void EmbeddedTilemap::createChunk(int chunkX, int chunkY, int z)
    {
        if(m_layers[z].count(chunkX) == 0)
        {
            m_layers[z][chunkX] = std::map<int, std::unique_ptr<EmbeddedChunk> >();
        }
        std::unique_ptr<EmbeddedChunk> chunk(new EmbeddedChunk());
        if(z < layerCount - 1)
        {
            chunk->setTexture(m_textures[z]);
            if(z > 0)
                chunk->setTransparent(true);
        }
        m_layers[z][chunkX][chunkY] = std::move(chunk);
    }
}
