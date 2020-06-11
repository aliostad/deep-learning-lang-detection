using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;

public class WorldChunkHashTable {
	
	int totalBuckets;
	WorldChunkHTBucket[] buckets;
	
	public WorldChunkHashTable() {
		totalBuckets = Mathf.FloorToInt (GameSettings.LoadedConfig.getTotalChunks() / GameSettings.LoadedConfig.ChunkHT_BucketSize);
		buckets = new WorldChunkHTBucket[totalBuckets];
		for (int i = 0; i < totalBuckets; ++i) {
			buckets[i] = new WorldChunkHTBucket();
		}
	}

	public void addChunk(WorldChunk chunk) {
		if (!getBucket(WorldChunk.GetAbsoluteIndex (chunk.getX(), chunk.getZ())).elementExists(WorldChunk.GetAbsoluteIndex (chunk.getX(), chunk.getZ())))
			getBucket(WorldChunk.GetAbsoluteIndex (chunk.getX(), chunk.getZ())).addElement(chunk);
	}

	public void removeChunk(int chunk_x, int chunk_z) {
		getBucket(WorldChunk.GetAbsoluteIndex (chunk_x, chunk_z)).removeElement(WorldChunk.GetAbsoluteIndex (chunk_x, chunk_z));
	}

	public bool chunkExists(int abs_chunk_index) {
		return getBucket (abs_chunk_index).elementExists (abs_chunk_index);
	}

	public WorldChunk findChunk(int abs_chunk_index) {
		return getBucket (abs_chunk_index).findElement (abs_chunk_index);
	}

	WorldChunkHTBucket getBucket(int abs_chunk_index) {
		return buckets [hash (abs_chunk_index)];
	}

	int hash(int abs_chunk_index) {
		return abs_chunk_index % totalBuckets;
	}

	public List<WorldChunk> getAllChunks() {
		List<WorldChunk> chunks = new List<WorldChunk> ();
		for (int i = 0; i < buckets.Length; ++i) {
			List<WorldChunk> bucketElements = buckets[i].getAllElements ();
			for(int j = 0; j < bucketElements.Count; ++j) {
				chunks.Add(bucketElements[j]);
			}
		}
		return chunks;
	}
	
}

public class WorldChunkHTBucket {
	
	List<WorldChunk> elements;
	
	public WorldChunkHTBucket() {
		elements = new List<WorldChunk> ();
	}
	
	public void addElement(WorldChunk elem) {
		if (elements.Count >= GameSettings.LoadedConfig.ChunkHT_BucketSize)
			Debug.LogWarning ("Loaded chunk HT bucket has exceeded it's max size.");

		elements.Add (elem);
	}
	
	public void removeElement(int abs_chunk_index) {
		for (int i = 0; i < elements.Count; ++i) {
			if (WorldChunk.GetAbsoluteIndex (elements [i].getX (), elements [i].getZ ()) == abs_chunk_index) {
				elements.RemoveAt (i);
				break;
			}
		}
	}

	public bool elementExists(int abs_chunk_index) {
		for (int i = 0; i < elements.Count; ++i) {
			if (WorldChunk.GetAbsoluteIndex(elements[i].getX(), elements[i].getZ()) == abs_chunk_index)
				return true;
		}
		return false;
	}

	public WorldChunk findElement(int abs_chunk_index) {
		for (int i = 0; i < elements.Count; ++i) {
			if (WorldChunk.GetAbsoluteIndex(elements[i].getX(), elements[i].getZ()) == abs_chunk_index)
				return elements[i];
		}
		return null;
	}

	public List<WorldChunk> getAllElements() {
		return elements;
	}
	
}