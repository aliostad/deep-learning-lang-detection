using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace Bright
{
    public class ChunkHolder : MonoBehaviour
    {
		[SerializeField]
		private List<Chunk> initialChunkPrefabs;

        [SerializeField]
        private List<Chunk> chunkPrefabs;

		public Chunk InitialChunk
		{
			get
			{
				var random = Random.Range(0, this.initialChunkPrefabs.Count);
				return this.initialChunkPrefabs[random];
			}
		}

		public Chunk GetChunk(BlankChunk blankChunk)
		{
			var doorway = blankChunk.OpenedDoorway;
			var findChunk = this.chunkPrefabs.FindAll(c => c.IsOpen(doorway));

			return findChunk[Random.Range(0, findChunk.Count)];
		}
    }
}
