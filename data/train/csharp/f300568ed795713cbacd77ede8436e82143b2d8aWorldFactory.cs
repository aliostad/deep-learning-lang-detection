namespace Incubakery
{
    using UnityEngine;

    public class WorldFactory
    {
        private readonly WorldBehaviour worldBehaviour;
        private readonly GameObject chunkPrefab;

        public WorldFactory(WorldBehaviour worldBehaviour, GameObject chunkPrefab)
        {
            this.worldBehaviour = worldBehaviour;
            this.chunkPrefab = chunkPrefab;
        }

        public ChunkBehaviour InstantiateChunkBehaviour(ChunkPosition chunkPosition)
        {
            var chunk = GameObject.Instantiate(
                this.chunkPrefab,
                Vector3.zero,
                Quaternion.Euler(Vector3.zero)) as GameObject;

            chunk.name = "Chunk " + chunkPosition.X + "," + chunkPosition.Y + "," + chunkPosition.Z;
			chunk.transform.parent = this.worldBehaviour.transform;
            chunk.transform.localPosition = Vector3.zero;

            return chunk.GetComponent<ChunkBehaviour>();
        }
    }
}