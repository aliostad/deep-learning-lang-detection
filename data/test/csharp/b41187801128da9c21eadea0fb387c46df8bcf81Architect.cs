using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Architect : MonoBehaviour {

	public World world;
		
	public T CreateChunk<T> (float x, float y, float z, Chunk chunk) where T : Chunk {
		Vector3 position = new Vector3(x,y,z);
		T newChunkObject = (T)chunk.GetPooledInstance<T> ();

		newChunkObject.transform.position = position;
		newChunkObject.position = position;
		newChunkObject.transform.rotation = Quaternion.Euler (Vector3.zero);
		newChunkObject.world = world;
		newChunkObject.transform.parent = world.transform;
		newChunkObject.chunkWidth = world.chunkWidth;
		newChunkObject.chunkHeight = world.chunkHeight;
		newChunkObject.chunkDepth = world.chunkDepth;
		newChunkObject.poolStart();
		
		world.AddChunk(position,newChunkObject);
		return newChunkObject;
	}
	
	public T CreateSubChunk<T> (float x, float y, float z, SubChunk sub, Chunk chunk) where T : SubChunk {
		Vector3 position = new Vector3(x,y,z);
		T newSubChunk = (T)sub.GetPooledInstance<T> ();

		newSubChunk.transform.position = position;
		newSubChunk.transform.rotation = Quaternion.Euler (Vector3.zero);
		newSubChunk.parentChunk = chunk;
		newSubChunk.transform.parent = chunk.transform;
		newSubChunk.chunkWidth = chunk.chunkWidth;
		newSubChunk.chunkHeight = chunk.chunkHeight;
		newSubChunk.chunkDepth = chunk.chunkDepth;
		newSubChunk.poolStart();

		return newSubChunk;
	}
	
	public virtual void Generate() {
		
	}
	
	public virtual Biome GenerateBiome(Biome biome) {
		return biome;		
	}
	
}
