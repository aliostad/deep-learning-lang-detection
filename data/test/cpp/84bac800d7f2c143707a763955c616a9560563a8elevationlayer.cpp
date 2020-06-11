#include "elevationlayer.h"

ElevationLayer::ElevationLayer(long s) : seed(s), noiseInstance(Noise(s))
{
}

std::shared_ptr<ChunkData> ElevationLayer::preGenerateChunk(int chunk_x, int chunk_y)
{
	auto chunk = std::make_shared<ChunkData>(chunkSize);
	chunk->chunk_x = chunk_x;
	chunk->chunk_y = chunk_y;
	long x_offset = chunk_x*chunkSize;
	long y_offset = chunk_y*chunkSize;
	for (int i_y = 0; i_y < chunkSize; ++i_y)
	{
		for (int i_x = 0; i_x < chunkSize; ++i_x)
		{
			long in_chunk_coordinates = i_y * chunkSize + i_x;
			chunk->data[in_chunk_coordinates] = (float)noiseInstance.outputValue(i_x + x_offset, i_y + y_offset);
		}
	}
	return chunk;
}
