using UnityEngine;

using System.Collections.Generic;

using Voxels.Util;
using Voxels.Workers;

namespace Voxels.Universe.Chunks {

    public class ChunkProvider : MonoBehaviour {

        public GameObject chunkPrefab;
        public Dictionary<Position, Chunk> Chunks = new Dictionary<Position, Chunk>();

        private World world;
        private Player player;

        private WorkerQueue renderQueue;
        private WorkerQueue generateQueue;

        public void Awake() {
            player = FindObjectOfType<Player>();
            world = GetComponentInParent<World>();            
        }

	    public void Start() {
            renderQueue = new WorkerQueue();
            renderQueue.Start();

            generateQueue = new WorkerQueue();
            generateQueue.Start();
		}

		public void OnApplicationQuit() {
            renderQueue.Stop();
            generateQueue.Stop();
		}

        public void LateUpdate() {
            foreach (var chunk in Chunks.Values) {

                if (chunk.Working)
                    continue;

                switch (chunk.ChunkState) {
                    case ChunkState.CREATED:
                        generateChunk(chunk);                        
                        break;
                    case ChunkState.ATTACHED:
                        rasterizeChunk(chunk);
                        break;
                    case ChunkState.TESSELATED:
                        renderChunk(chunk);
                        break;
                }

            }
        }

        private void generateChunk(Chunk chunk) {
            float distance = player.GetDistance(chunk.Position);
            generateQueue.Enqueue(distance, new GenerateWorker(chunk, world));
        }

        private void rasterizeChunk(Chunk chunk) {
            float distance = player.GetDistance(chunk.Position);
            renderQueue.Enqueue(distance, new RasterizeWorker(chunk));
        }

        private void renderChunk(Chunk chunk) {
            chunk.Render();
        }

        public void Load(Position position) {
            GameObject chunkObject = Instantiate(chunkPrefab, Vector3.zero, Quaternion.Euler(Vector3.zero));
            Chunk chunk = chunkObject.GetComponent<Chunk>();

            // set chunk position
            chunk.Position = position;
            chunk.ChunkType = ChunkType.EMPTY;
            chunk.ChunkState = ChunkState.CREATED;

            // set prefab properties
            chunkObject.transform.parent = transform;
            chunkObject.transform.name = chunk.ToString();
            chunkObject.transform.position = chunk.WorldPosition;

            // register chunk
            Chunks.Add(position, chunk);
        }

        public void Unload(Position position) {
            Chunk chunk = GetChunk(position);

            // TODO: probably should use some sort of an unload queue here
            Chunks.Remove(position);

            // TODO return to pool
            chunk.Dispose();
        }

        public Chunk GetChunk(Position position) {
            Chunk chunk;            
            Chunks.TryGetValue(position, out chunk);

            return chunk;
        }

        public bool Loaded(Position position) {
            return Chunks.ContainsKey(position);
        }
			
    }

}
 