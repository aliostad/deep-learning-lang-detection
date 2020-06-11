#include "Spawner.hpp"
#include "Unused.hpp"

#include "Unused.hpp"

Spawner::Spawner(World &world) : _world(world)
{
}

Spawner::~Spawner()
{
}

int			Spawner::isChunkSpawnable(Chunk *chunk,
						  const std::vector<Client *> &clients UNUSED)
// for the future clients will be used so the new player isnt spawn to a dangerous zone
{
  const Vector2i	&pos = chunk->getPosition();

  for (unsigned int idx = 0; idx < Chunk::lod; ++idx)
    {
      const t_ChunkInfo	&cInfo = chunk->getChunkInfo(idx);
      int		dist = (cInfo.avHeight + MIDDLEHEIGHT)
	- (pos.y * static_cast<int>(Chunk::pHeight));

      if (dist >= 0 && dist < static_cast<int>(Chunk::pHeight))
	return idx;
    }
  return -1;
}

bool		Spawner::placePlayerOnSurface(Chunk *chunk,
						     unsigned int chunkPart,
						     Vector2u &chunkPos)
{
  const std::vector<TileType>	&tiles = chunk->getTiles();
  unsigned int	xPad;
  unsigned int	lodSize;

  lodSize = Chunk::width / Chunk::lod;
  xPad = chunkPart * lodSize;
  std::cout << "XPAD: " << xPad << std::endl;
  for (unsigned int pos = xPad; pos < xPad + lodSize; ++pos)
    {
      if (tiles[pos] != TileType::Empty)
	continue ;
      for (unsigned int y = Chunk::height - 1; y > 0; --y)
	{
	  if (tiles[y * Chunk::width + pos] == TileType::Empty &&
	      tiles[(y - 1) * Chunk::width + pos] != TileType::Empty)
	    {
	      chunkPos = {pos, y};
	      return true;
	    }
	}
    }
  return false;
}

void		Spawner::moveToSurface(Vector2i &chunkId,
					      const std::vector<Client *> &clients) const
{
  Chunk		*chunk;
  float		chunkMidDist;
  int		dist;

  while (true)
    {
      if (!_world.isChunkLoaded(chunkId))
	chunk = _world.loadChunk(chunkId, clients, chunkId);
      else
	chunk = _world.getChunk(chunkId);
      chunkMidDist = 0;

      for (unsigned int idx = 0; idx < Chunk::lod; ++idx)
	{
	  const t_ChunkInfo	&cInfo = chunk->getChunkInfo(idx);

	  dist = (cInfo.avHeight + MIDDLEHEIGHT)
	    - (chunkId.y * static_cast<int>(Chunk::pHeight));
	  chunkMidDist += dist;
	  if (dist >= 0 && dist < static_cast<int>(Chunk::pHeight))
	    return ;
	}
      chunkMidDist /= static_cast<float>(Chunk::lod);
      chunkMidDist /= static_cast<float>(Chunk::pHeight);
      if (chunkMidDist < 0)
	chunkMidDist -= 1;
      chunkMidDist = std::ceil(chunkMidDist);
      chunkId.y += chunkMidDist;
      std::cout << chunkId.y << " " << chunkMidDist << std::endl;
    }
}

void		Spawner::spawnClient(const std::vector<Client *> &clients,
					    Client *client)
{
  ClientEntity	&clEnt = client->getEntity();
  Vector2i	chunkId(0,0);
  Vector2u	plPos;
  Chunk		*chunk;
  int		chunkPart;

  std::cout << "New client -> Spawn init" << std::endl;
  for (int dist = 0; true; dist++)
    {
      for (int side = -dist; side <= dist; side += (dist * 2))
	{
	  chunkId.x = side;
	  moveToSurface(chunkId, clients);
	  chunk = _world.getChunk(chunkId);
	  if ((chunkPart = isChunkSpawnable(chunk, clients)) != -1)
	    if (placePlayerOnSurface(chunk, chunkPart, plPos) == true)
	      {
		clEnt.setChunkId(chunk->getPosition());
		clEnt.setPosition(Vector2f(static_cast<float>(plPos.x) / Chunk::width,
					   static_cast<float>(plPos.y) / Chunk::height));
		return ;
	      }
	  if (dist == 0)
	    break ;
	}
    }
}
