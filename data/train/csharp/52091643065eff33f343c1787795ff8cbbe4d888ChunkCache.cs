using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;

namespace Survivalist {
	/* The ChunkCache should deal with what chunks to keep in memory and saving of
	 * unloaded chunks */
	public class ChunkCache {
		ChunkSource source;
		ChunkGenerator generator;
		Hashtable cache = new Hashtable();

		int lastChunkX, lastChunkY;
		ChunkData lastChunk;

		public ChunkCache(ChunkSource source, ChunkGenerator generator) {
			this.source = source;
			this.generator = generator;
		}

		public ChunkData Get(int x, int y) {
			if (lastChunk != null && lastChunkX == x && lastChunkY == y)
				return lastChunk;

			ulong hashKey = BuildKey(x, y);
			ChunkData chunk = cache[hashKey] as ChunkData;
			if (chunk == null) {
				Console.WriteLine("[ChunkCache] Loading {0}, {1}", x, y);
				chunk = source.Load(x, y);
				// Failed to load chunk, generate a new one
				if (chunk == null)
					chunk = generator.GenerateNewChunk(x, y);
				cache[hashKey] = chunk;
			}

			lastChunkX = x;
			lastChunkY = y;
			lastChunk = chunk;

			return chunk;
		}

		public void Save(int x, int y) {
			var key = BuildKey(x, y);
			if (cache.ContainsKey(key)) {
				var chunk = cache[key] as ChunkData;
				source.Save(chunk);
			}
		}

		public void Unload(int x, int y) {
			var key = BuildKey(x, y);
			if (cache.ContainsKey(key)) {
				Console.WriteLine("[ChunkCache] Unloading {0}, {1}", x, y);
				var chunk = cache[key] as ChunkData;
				source.Save(chunk);
				cache.Remove(key);
			}
		}

		protected ulong BuildKey(int x, int y) {
			return (uint)x | (ulong)(uint)y << 32;
		}

		// GetTileType
		// SetTile
	}
}
