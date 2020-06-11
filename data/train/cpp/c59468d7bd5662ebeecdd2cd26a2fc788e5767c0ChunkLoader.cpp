#include <Daedalus.h>
#include "ChunkLoader.h"

namespace terrain {
	using namespace utils;
	using ChunkCache = ChunkLoader::ChunkCache;

	ChunkLoader::~ChunkLoader() {
		LoadedChunkCache.empty();
	}

	bool ChunkLoader::IsChunkGenerated(const ChunkOffsetVector & offset) const {
		// TODO: implement some form of tracking which chunks have been generated
		return LoadedChunkCache.find(offset) != LoadedChunkCache.end();
	}

	ChunkDataPtr ChunkLoader::GetGeneratedChunk(const ChunkOffsetVector & offset) {
		auto found = LoadedChunkCache.find(offset);
		if (found != LoadedChunkCache.end())
			return found->second;
		else
			return LoadChunkFromDisk(offset);
	}

	ChunkDataPtr ChunkLoader::LoadChunkFromDisk(const ChunkOffsetVector & offset) {
		// implement disk loading
		return NULL;
	}

	ChunkDataPtr ChunkLoader::GenerateMissingChunk(const ChunkOffsetVector & offset) {
		const auto & props = BRLoader->GetGeneratorParameters();
		const auto point = TerrainGenParams.ToRealCoordSpace(offset).Truncate();
		const auto biomeTri = BRLoader->FindContainingBiomeTriangle(point);
		const auto regionPos = props.ToBiomeRegionCoordinates(point);
		const UVWVector uvw = biomeTri.InterpolatePoint(regionPos);
		double height = ((
			biomeTri[1]->GetElevation() * uvw.X +
			biomeTri[2]->GetElevation() * uvw.Y +
			biomeTri[0]->GetElevation() * uvw.Z) - 0.75) * 10000;
		auto data = new ChunkData(TerrainGenParams.GridCellCount, offset);
		SetDefaultHeight(*data, (Int32) height);
		// TODO: implement disk saving
		auto cd = ChunkDataPtr(data);
		LoadedChunkCache.insert({ offset, cd });
		return cd;
	}

	ChunkDataPtr ChunkLoader::GetChunkAt(const ChunkOffsetVector & offset) {
		//UE_LOG(LogTemp, Error, TEXT("Loading chunk at offset: %d %d %d"), offset.X, offset.Y, offset.Z);
		auto loaded = GetGeneratedChunk(offset);
		if (!loaded) {
			// Chunk has not been generated yet
			loaded = GenerateMissingChunk(offset);
		}

		return loaded;
	}

	const TerrainGeneratorParameters & ChunkLoader::GetGeneratorParameters() const {
		return TerrainGenParams;
	}

	void ChunkLoader::SetDefaultHeight(ChunkData & data, const Int32 height) {
		// TODO: if the chunk height ended on a chunk division line, no triangles are generated
		auto chunkHeight = TerrainGenParams.ChunkScale;
		if (((data.ChunkOffset.Z + 1) * (Int64) chunkHeight) < height) {
			data.DensityData.Fill(1.0);			// Completely filled block
			//UE_LOG(LogTemp, Error, TEXT("Ground chunk"));
		} else if ((data.ChunkOffset.Z * (Int64) chunkHeight) > height) {
			data.DensityData.Fill(0.0);			// Completely empty block
			//UE_LOG(LogTemp, Error, TEXT("Air chunk"));
		} else {
			//UE_LOG(LogTemp, Error, TEXT("Mixed chunk"));
			auto localHeight = TerrainGenParams.GridCellCount * (height / chunkHeight - data.ChunkOffset.Z);
			for (Uint32 x = 0; x < data.ChunkFieldSize; x++) {
				for (Uint32 y = 0; y < data.ChunkFieldSize; y++) {
					for (Uint32 z = 0; z < data.ChunkFieldSize && z < localHeight; z++)
						data.DensityData.Set(x, y, z, 1);
				}
			}
		}
	}
}
