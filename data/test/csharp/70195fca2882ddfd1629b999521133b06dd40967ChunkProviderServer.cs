using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ChunkProviderServer : IChunkProvider {


	private Dictionary<long,Chunk> id2ChunkDic = new Dictionary<long,Chunk> ();
	private List<Chunk> loadedChunks = new List<Chunk> ();
	private WorldServer worldObj;

	/**
     * chunk generator object. Calls to load nonexistent chunks are forwarded to this object.
     */
	private IChunkProvider serverChunkGenerator;

	public ChunkProviderServer(WorldServer worldServer, IChunkProvider chunkProvider)
	{
		worldObj = worldServer;
		serverChunkGenerator = chunkProvider;
	}

	/**
     * Will return back a chunk, if it doesn't exist and its not a MP client it will generates all the blocks for the
     * specified chunk from the map seed and chunk seed
     */
	public Chunk provideChunk(int x, int z)
	{
		Chunk chunk = (Chunk)id2ChunkDic [ChunkCoordIntPair.chunkXZ2Int (x, z)];
		return chunk == null ? loadChunk (x, z) : chunk;
	}

	/**
     * loads or generates the chunk at the chunk location specified
     */
	public Chunk loadChunk(int x, int z)
	{
		long chunkID = ChunkCoordIntPair.chunkXZ2Int (x, z);
		Chunk chunk = null;

		if (!id2ChunkDic.ContainsKey(chunkID)) {

			if (serverChunkGenerator == null) {

			} else {
				chunk = serverChunkGenerator.provideChunk (x, z);
			}

			id2ChunkDic.Add (chunkID, chunk);
			loadedChunks.Add (chunk);
			chunk.onChunkLoad ();
			chunk.populateChunk (this, this, x, z);
		}

		chunk = (Chunk)id2ChunkDic [chunkID];

		return chunk;
	}

	private Chunk loadChunkFromFile(int x, int z)
	{
		return null;
	}

	/**
     * Checks to see if a chunk exists at x, z
     */
	public bool chunkExists(int x, int z)
	{
		return id2ChunkDic.ContainsKey (ChunkCoordIntPair.chunkXZ2Int (x, z));
	}

	public Chunk provideChunk(BlockPos blockPosIn)
	{
		return this.provideChunk (blockPosIn.x >> 4, blockPosIn.y >> 4);
	}

	/**
     * Populates chunk with ores etc etc
     */
	public void populate(IChunkProvider chunkProvider, int x, int z)
	{
		Chunk chunk = provideChunk (x, z);

		if (serverChunkGenerator != null) {
			serverChunkGenerator.populate (chunkProvider, x, z);
		}
	}

	public bool func_177460_a(IChunkProvider chunkProvider, Chunk chunk, int x, int z)
	{
		if (serverChunkGenerator != null && serverChunkGenerator.func_177460_a (chunkProvider, chunk, x, z)) {
			Chunk newChunk = provideChunk (x, z);
			return true;
		} else {
			return false;
		}
	}

	/**
     * Two modes of operation: if passed true, save all Chunks in one go.  If passed false, save up to two chunks.
     * Return true if all chunks have been saved.
     */
	public bool saveChunks(bool p_73151_1, IProgressUpdate progressCallback)
	{
		int i = 0;
		for (int j = 0; j < loadedChunks.Count; ++j) {
			Chunk chunk = loadedChunks [j];

			if (p_73151_1) {
				
			}

			savaChunkData (chunk);
			++i;

			if (i == 24 && !p_73151_1) {
				return false;
			}
		}

		return true;
	}

	private void savaChunkData(Chunk chunk)
	{
		
	}

	/**
     * Unloads chunks that are marked to be unloaded. This is not guaranteed to unload every such chunk.
     */
	public bool unloadQueuedChunks()
	{
		return serverChunkGenerator.unloadQueuedChunks ();
	}

	/**
     * Returns if the IChunkProvider supports saving.
     */
	public bool canSave()
	{
		return true;
	}

	/**
     * Converts the instance data to a readable string.
     */
	public string makeString()
	{
		return "";
	}

	public void recreateStructures(Chunk chunk, int x, int z)
	{
	}



}
