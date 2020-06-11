using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[AddComponentMenu("Map/Map")]
public class Map : MonoBehaviour {
	
	public const int maxChunkY = 16;
	public const int maxBlockY = maxChunkY * Chunk.SIZE_Y;
	
	[SerializeField] private BlockSet blockSet;
	private Grid<ChunkData> chunks = new Grid<ChunkData>();
	private Lightmap lightmap = new Lightmap();
	
	void Awake() {
		ChunkBuilder.Init( blockSet.GetMaterials().Length );
	}
	
	public void SetBlockAndRecompute(BlockData block, Vector3i pos) {
		SetBlock( block, pos );
		
		Build( Chunk.ToChunkPosition(pos) );
		foreach( Vector3i dir in Vector3i.directions ) {
			Build( Chunk.ToChunkPosition(pos + dir) );
		}
		LightComputer.RecomputeLightAtPosition(this, pos);
	}
	
	public void BuildColumn(int cx, int cz) {
		for(int cy=chunks.GetMinY(); cy<chunks.GetMaxY(); cy++) {
			Build( new Vector3i(cx, cy, cz) );
		}
	}
	private void Build(Vector3i pos) {
		ChunkData chunk = GetChunkData( pos );
		if(chunk != null) chunk.GetChunkInstance().SetDirty();
	}
	
	private ChunkData GetChunkDataInstance(Vector3i pos) {
		if(pos.y < 0) return null;
		ChunkData chunk = GetChunkData(pos);
		if(chunk == null) {
			chunk = new ChunkData(this, pos);
			chunks.AddOrReplace(chunk, pos);
		}
		return chunk;
	}
	public ChunkData GetChunkData(Vector3i pos) {
		return chunks.SafeGet(pos);
	}
	
	
	public void SetBlock(BlockData block, Vector3i pos) {
		SetBlock(block, pos.x, pos.y, pos.z);
	}
	public void SetBlock(BlockData block, int x, int y, int z) {
		ChunkData chunk = GetChunkDataInstance( Chunk.ToChunkPosition(x, y, z) );
		if(chunk != null) chunk.SetBlock( block, Chunk.ToLocalPosition(x, y, z) );
	}
	
	public BlockData GetBlock(Vector3i pos) {
		return GetBlock(pos.x, pos.y, pos.z);
	}
	public BlockData GetBlock(int x, int y, int z) {
		ChunkData chunk = GetChunkData( Chunk.ToChunkPosition(x, y, z) );
		if(chunk == null) return default(BlockData);
		return chunk.GetBlock( Chunk.ToLocalPosition(x, y, z) );
	}
	
	public Lightmap GetLightmap() {
		return lightmap;
	}
	
	public BlockSet GetBlockSet() {
		return blockSet;
	}
	
}

