#pragma once

class TerrainGenerator final: public WorldGenerator
{
public:
	TerrainGenerator() {}
	virtual ~TerrainGenerator() {}

	virtual int3 getSpanMin() const override { return { 0, 0, 0 }; }
	virtual int3 getSpanMax() const override { return { 0, 0, 0 }; }

	virtual void generate(int seed, int chunk_x, int chunk_y, int chunk_z, const WorldManipulator &w) const override
	{
		Noise2D heightmap = getHeightMap(seed);
		heightmap.generate(chunk_x * CHUNK_SIZE, chunk_z * CHUNK_SIZE, CHUNK_SIZE, CHUNK_SIZE);

		for (int x = 0; x < CHUNK_SIZE; x++)
			for (int z = 0; z < CHUNK_SIZE; z++)
			{
				int h = heightmap.getNoise(x, z) - chunk_y * CHUNK_SIZE;
				h = min(CHUNK_SIZE, h + 1);
				for (int y = 0; y < h; y++)
					w[x][y][z].type = 1;
			}
	}
};