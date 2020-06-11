#include "baselayer.h"

long mod(long a, long b)
{
	return (a%b + b) % b;
}

BaseLayer::BaseLayer()
{
	chunkSize = 1024; // Default value for chunkSize
}

float BaseLayer::get(long x, long y)
{
	int chunk_x = (int)floor((float)x/ chunkSize);
	int chunk_y = (int)floor((float)y/ chunkSize);
	float value;
	std::pair<int, int> chunk_coordinates = std::make_pair(chunk_x, chunk_y);
	long in_chunk_coordinates = (mod(x, chunkSize)) * chunkSize + mod(y, chunkSize);
	if (chunk_map.find(chunk_coordinates) != chunk_map.end()) // If chunk already exists
	{
		value = chunk_map[chunk_coordinates]->data[in_chunk_coordinates]; // Get value
	}
	else
	{
	  std::shared_ptr<ChunkData> chunk_ptr = preGenerateChunk(chunk_x, chunk_y);
	  chunk_map.insert({chunk_coordinates, chunk_ptr});
	  value = chunk_map[chunk_coordinates]->data[in_chunk_coordinates];
	}
	return value;
}

void BaseLayer::listchunks()
{
	std::cout << "Currently loaded chunks:" << std::endl;
	for(auto it=chunk_map.begin(); it!=chunk_map.end(); ++it)
	{
		std::pair<int, int> coordinates = it->first;
		std::cout << " - " << coordinates.first << ";" << coordinates.second << std::endl;
	}
}

unsigned long BaseLayer::nbChunks()
{
	return (unsigned long)chunk_map.size();
}

std::shared_ptr<ChunkData> BaseLayer::getChunk(int chunk_x, int chunk_y)
{
	std::pair<int, int> chunk_coordinates = std::make_pair(chunk_x, chunk_y);
	return chunk_map.at(chunk_coordinates);
}