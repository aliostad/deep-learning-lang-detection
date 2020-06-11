using System.Collections;
using System.Diagnostics;
using System.Collections.Concurrent;

namespace Sean.World
{
	internal class Chunks : IEnumerable
	{
		public Chunks()
		{
            _chunks = new ConcurrentDictionary<long, Chunk> ();
		}

        private ConcurrentDictionary<long, Chunk> _chunks;

        private ChunkCoords XzToChunkCoords(int x, int z)
        {
            return new ChunkCoords(x,z);
        }
        private ChunkCoords CoordToChunkCoords(Coords coord)
        {
            int x = coord.Xblock / Chunk.CHUNK_SIZE;
            int z = coord.Zblock / Chunk.CHUNK_SIZE;
            return new ChunkCoords(x,z);
        }
        private ChunkCoords PositionToChunkCoords(Position position)
        {
            int x = position.X / Chunk.CHUNK_SIZE;
            int z = position.Z / Chunk.CHUNK_SIZE;
            return new ChunkCoords(x,z);
        }

        private Chunk GetOrCreate(ChunkCoords chunkCoords)
        {
            long chunkHash = ((long)chunkCoords.X << 32) + (long)chunkCoords.Z;
            Chunk chunk = _chunks [chunkHash];
            if (chunk == null) {
                chunk = new Chunk (chunkCoords);
                _chunks[chunkHash] = chunk;
            }
            return chunk;
        }
		/// <summary>Get a chunk from the array. Based on world coords.</summary>
		public Chunk this[Coords coords]
		{
            get { return GetOrCreate(CoordToChunkCoords(coords)); }
		}

		/// <summary>Get a chunk from the array. Based on world coords.</summary>
		public Chunk this[Position position]
		{
            get { return GetOrCreate(PositionToChunkCoords(position)); }
		}

		/// <summary>Get a chunk from the array. Based on the x,z of the chunk in the world. Note these are chunk coords not block coords.</summary>
		public Chunk this[int x, int z]
		{
            get { return GetOrCreate(XzToChunkCoords(x, z)); }
            //private set { _chunks[XzToChunkHash(x, z)] = value; }
		}

		//internal uint UpdateCounter;

		public IEnumerator GetEnumerator()
		{
			return _chunks.GetEnumerator();
		}
	}
}
