using UnityEngine;
using System.Collections.Generic;

public class ChunkManager : SingletonBehaviour<ChunkManager> {

	public int chunkSize = 32;
	public ChunkGenerator chunkGenerator;

	//pool of existing chunk objects
	Stack<Chunk> _pool;
	Stack<Chunk> pool {
		get {
			if (_pool == null) {
				_pool = new Stack<Chunk>();
			}
			return _pool;
		}
	}

	//allocate new chunk instance from pool
	Chunk AllocateChunk() {
		Chunk chunk;
		if (pool.Count == 0) {
			chunk = new GameObject("chunk").AddComponent<Chunk>();
		}
		else {
			chunk = pool.Pop();
		}
		chunk.Activate();
		return chunk;
	}

	//deallocate old chunk instance and return to pool
	void DeallocateChunk(Chunk chunk) {
		chunk.Deactivate();
		pool.Push(chunk);
	}

	//start loading a chunk of terrain
	public Chunk LoadChunk(Vector3 offset) {
		Chunk chunk = AllocateChunk();
		chunk.offset = offset;
		BlockType[,,] chunkData = chunkGenerator.GenerateChunkData(offset, chunkSize);
		chunk.SetBlockTypes(chunkData);
		return chunk;
	}

	//unload a chunk of terrain
	public void UnloadChunk(Chunk chunk) {
		DeallocateChunk(chunk);
	}

}
