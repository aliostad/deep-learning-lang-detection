#ifndef __TILEMAP_TILEMAP_H_INCLUDED__
#define __TILEMAP_TILEMAP_H_INCLUDED__

#include "../framework/common.h"

#include "tile.h"
#include "tilechunk.h"
#include "tilelightdefs.h"
#include "../framework/math/boundingbox.h"
#include "../framework/math/vector3.h"

#include <stl/vector.h>

class ChunkVertexGenerator;
class GraphicsDevice;
class TileChunk;
class TileMapLighter;
class TileMesh;
class TileMeshCollection;
struct RectF;
struct Ray;
struct Tile;

class TileMap
{
public:
	TileMap(TileMeshCollection *tileMeshes, ChunkVertexGenerator *vertexGenerator, TileMapLighter *lighter, GraphicsDevice *graphicsDevice);
	virtual ~TileMap();

	void SetSize(uint numChunksX, uint numChunksY, uint numChunksZ, uint chunkSizeX, uint chunkSizeY, uint chunkSizeZ);

	TileMeshCollection* GetMeshes() const              { return m_tileMeshes; }
	ChunkVertexGenerator* GetVertexGenerator() const   { return m_vertexGenerator; }
	TileMapLighter* GetLighter() const                 { return m_lighter; }

	Tile* Get(uint x, uint y, uint z) const;
	Tile* GetSafe(uint x, uint y, uint z) const;
	TileChunk* GetChunk(uint chunkX, uint chunkY, uint chunkZ) const;
	TileChunk* GetChunkSafe(uint chunkX, uint chunkY, uint chunkZ) const;
	TileChunk* GetChunkNextTo(TileChunk *chunk, int offsetX, int offsetY, int offsetZ) const;
	TileChunk* GetChunkContaining(uint x, uint y, uint z) const;

	void GetBoundingBoxFor(uint x, uint y, uint z, BoundingBox *box) const;
	BoundingBox GetBoundingBoxFor(uint x, uint y, uint z) const;

	bool CheckForCollision(const Ray &ray, uint &x, uint &y, uint &z) const;
	bool CheckForCollision(const Ray &ray, Vector3 &point, uint &x, uint &y, uint &z) const;
	bool CheckForCollisionWithTile(const Ray &ray, Vector3 &point, uint x, uint y, uint z) const;
	bool GetOverlappedTiles(const BoundingBox &box, uint &x1, uint &y1, uint &z1, uint &x2, uint &y2, uint &z2) const;
	bool GetOverlappedChunks(const BoundingBox &box, uint &x1, uint &y1, uint &z1, uint &x2, uint &y2, uint &z2) const;

	void UpdateChunkVertices(uint chunkX, uint chunkY, uint chunkZ);
	void UpdateVertices();

	void UpdateLighting();

	bool IsWithinBounds(int x, int y, int z) const;

	uint GetWidth() const                                  { return m_widthInChunks * m_chunkWidth; }
	uint GetHeight() const                                 { return m_heightInChunks * m_chunkHeight; }
	uint GetDepth() const                                  { return m_depthInChunks * m_chunkDepth; }

	uint GetChunkWidth() const                             { return m_chunkWidth; }
	uint GetChunkHeight() const                            { return m_chunkHeight; }
	uint GetChunkDepth() const                             { return m_chunkDepth; }

	uint GetWidthInChunks() const                          { return m_widthInChunks; }
	uint GetHeightInChunks() const                         { return m_heightInChunks; }
	uint GetDepthInChunks() const                          { return m_depthInChunks; }
	const BoundingBox& GetBounds() const                   { return m_bounds; }

	uint GetNumChunks() const                              { return m_numChunks; }

	void SetAmbientLightValue(TILE_LIGHT_VALUE value)      { m_ambientLightValue = value; }
	TILE_LIGHT_VALUE GetAmbientLightValue() const          { return m_ambientLightValue; }
	void SetSkyLightValue(TILE_LIGHT_VALUE value)          { m_skyLightValue = value; }
	TILE_LIGHT_VALUE GetSkyLightValue() const              { return m_skyLightValue; }

private:
	void Clear();

	uint GetChunkIndexAt(uint x, uint y, uint z) const;
	uint GetChunkIndex(uint chunkX, uint chunkY, uint chunkZ) const;

	void UpdateChunkVertices(TileChunk *chunk);

	TileMeshCollection *m_tileMeshes;
	TileChunk **m_chunks;
	GraphicsDevice *m_graphicsDevice;
	ChunkVertexGenerator *m_vertexGenerator;
	TileMapLighter *m_lighter;

	uint m_chunkWidth;
	uint m_chunkHeight;
	uint m_chunkDepth;

	uint m_widthInChunks;
	uint m_heightInChunks;
	uint m_depthInChunks;
	BoundingBox m_bounds;

	uint m_numChunks;

	TILE_LIGHT_VALUE m_ambientLightValue;
	TILE_LIGHT_VALUE m_skyLightValue;
};

inline Tile* TileMap::Get(uint x, uint y, uint z) const
{
	TileChunk *chunk = GetChunkContaining(x, y, z);
	uint chunkX = x - chunk->GetX();
	uint chunkY = y - chunk->GetY();
	uint chunkZ = z - chunk->GetZ();

	return chunk->Get(chunkX, chunkY, chunkZ);
}

inline Tile* TileMap::GetSafe(uint x, uint y, uint z) const
{
	if (!IsWithinBounds((int)x, (int)y, (int)z))
		return NULL;
	else
		return Get(x, y, z);
}

inline TileChunk* TileMap::GetChunk(uint chunkX, uint chunkY, uint chunkZ) const
{
	uint index = GetChunkIndex(chunkX, chunkY, chunkZ);
	return m_chunks[index];
}

inline TileChunk* TileMap::GetChunkSafe(uint chunkX, uint chunkY, uint chunkZ) const
{
	if (
		(chunkX >= m_widthInChunks) ||
		(chunkY >= m_heightInChunks) ||
		(chunkZ >= m_depthInChunks)
		)
		return NULL;
	else
		return GetChunk(chunkX, chunkY, chunkZ);
}

inline TileChunk* TileMap::GetChunkNextTo(TileChunk *chunk, int offsetX, int offsetY, int offsetZ) const
{
	int checkX = chunk->GetX() + offsetX;
	int checkY = chunk->GetY() + offsetY;
	int checkZ = chunk->GetZ() + offsetZ;

	if (
		(checkX < 0 || (uint)checkX >= m_widthInChunks) ||
		(checkY < 0 || (uint)checkY >= m_heightInChunks) ||
		(checkZ < 0 || (uint)checkZ >= m_depthInChunks)
		)
		return NULL;
	else
		return GetChunk(checkX, checkY, checkZ);
}

inline TileChunk* TileMap::GetChunkContaining(uint x, uint y, uint z) const
{
	uint index = GetChunkIndexAt(x, y, z);
	return m_chunks[index];
}

inline void TileMap::GetBoundingBoxFor(uint x, uint y, uint z, BoundingBox *box) const
{
	TileChunk *chunk = GetChunkContaining(x, y, z);
	uint chunkX = x - chunk->GetX();
	uint chunkY = y - chunk->GetY();
	uint chunkZ = z - chunk->GetZ();

	chunk->GetBoundingBoxFor(chunkX, chunkY, chunkZ, box);
}

inline BoundingBox TileMap::GetBoundingBoxFor(uint x, uint y, uint z) const
{
	BoundingBox box;
	GetBoundingBoxFor(x, y, z, &box);
	return box;
}

inline void TileMap::UpdateChunkVertices(uint chunkX, uint chunkY, uint chunkZ)
{
	uint index = GetChunkIndex(chunkX, chunkY, chunkZ);
	TileChunk *chunk = m_chunks[index];
	UpdateChunkVertices(chunk);
}

inline uint TileMap::GetChunkIndexAt(uint x, uint y, uint z) const
{
	return GetChunkIndex(x / m_chunkWidth, y / m_chunkHeight, z / m_chunkDepth);
}

inline uint TileMap::GetChunkIndex(uint chunkX, uint chunkY, uint chunkZ) const
{
	return (chunkY * m_widthInChunks * m_depthInChunks) + (chunkZ * m_widthInChunks) + chunkX;
}

inline bool TileMap::IsWithinBounds(int x, int y, int z) const
{
	if (x < 0 || x >= (int)GetWidth())
		return false;
	if (y < 0 || y >= (int)GetHeight())
		return false;
	if (z < 0 || z >= (int)GetDepth())
		return false;

	return true;
}
#endif

