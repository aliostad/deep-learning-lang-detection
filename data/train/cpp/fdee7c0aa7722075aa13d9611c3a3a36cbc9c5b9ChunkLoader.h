#pragma once

#include <Models/Terrain/ChunkData.h>
#include <Models/Terrain/TerrainDataStructures.h>
#include <Models/Terrain/BiomeRegionLoader.h>
#include <Utilities/Algebra/Algebra3D.h>

#include <memory>
#include <unordered_map>

namespace terrain {

	/**
	 * This class will load data related to a particular chunk, or serve it from
	 * memory if it has been cached. It will also invoke the terrain generator if
	 * the chunk hasn't be generated yet. This class will most likely run on
	 * the server-side.
	 */
	class ChunkLoader {
	public:
		using ChunkCache = std::unordered_map<ChunkOffsetVector, ChunkDataPtr>;

	private:
		ChunkCache LoadedChunkCache;

		TerrainGeneratorParameters TerrainGenParams;
		BiomeRegionLoaderPtr BRLoader;

		bool IsChunkGenerated(const ChunkOffsetVector & offset) const;
		
		/**
		 * @return Null pointer if the chunk has not yet been generated, otherwise
		 *         retrieve the chunk from cache, or load the chunk from disk if it
		 *         hasn't been cached yet.
		 */
		ChunkDataPtr GetGeneratedChunk(const ChunkOffsetVector & offset);
		ChunkDataPtr LoadChunkFromDisk(const ChunkOffsetVector & offset);
		ChunkDataPtr GenerateMissingChunk(const ChunkOffsetVector & offset);

		//void RunDiamondSquare(ChunkData & data);
		void SetDefaultHeight(ChunkData & data, Int32 height);

	public:
		ChunkLoader(
			const TerrainGeneratorParameters & params,
			const BiomeRegionLoaderPtr & brLoader
		) : TerrainGenParams(params), BRLoader(brLoader)
		{}
		~ChunkLoader();

		const TerrainGeneratorParameters & GetGeneratorParameters() const;
		ChunkDataPtr GetChunkAt(const ChunkOffsetVector & offset);
	};

	using ChunkLoaderPtr = std::shared_ptr<ChunkLoader>;
}
