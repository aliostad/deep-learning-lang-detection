using System.Collections.Generic;
using Assets.Scripts.voxel.Blocks;
using Assets.Scripts.voxel.Structs;
using UnityEngine;

namespace Assets.Scripts.voxel
{
    public class World : MonoBehaviour
    {
        public GameObject ChunkPreFab;
        public Dictionary<WorldPos, Chunk> Chunks = new Dictionary<WorldPos, Chunk>();
        public string WorldName = "world";

        public void CreateChunk(int x, int y, int z)
        {
            //Debug.Log(string.Format("World - CreateChunk: Pos - {0} {1} {2}", x, y, z));

            var worldPos = new WorldPos(x, y, z);
            var newChunkObject =
                Instantiate(ChunkPreFab, new Vector3(x, y, z), Quaternion.Euler(Vector3.zero)) as GameObject;

            if (newChunkObject == null) return;

            var newChunk = newChunkObject.GetComponent<Chunk>();

            newChunk.WorldPos = worldPos;
            newChunk.World = this;
            Chunks.Add(worldPos, newChunk);

            var terrainGen = new TerrainGen();
            newChunk = terrainGen.ChunkGen(newChunk);

            newChunk.SetBlocksUnModified();
            var loaded = Serialization.LoadChunk(newChunk);
        }

        private void DestroyChunk(WorldPos pos)
        {
            DestroyChunk(pos.X, pos.Y, pos.Z);
        }

        public int ChunksInMemory
        {
            get
            {
                return Chunks.Count;
            }
        }

        public void DestroyChunk(int x, int y, int z)
        {
            Chunk chunk;
            if (!Chunks.TryGetValue(new WorldPos(x, y, z), out chunk))
                return;

            Serialization.SaveChunk(chunk);
            Destroy(chunk.gameObject);
            Chunks.Remove(new WorldPos(x, y, z));
        }

        public Chunk GetChunk(WorldPos pos)
        {
            return GetChunk(pos.X, pos.Y, pos.Z);
        }

        public Chunk GetChunk(int x, int y, int z)
        {
            float multiple = Chunk.ChunkSize;
            var pos = new WorldPos
            {
                X = Mathf.FloorToInt(x/multiple)*Chunk.ChunkSize,
                Y = Mathf.FloorToInt(y/multiple)*Chunk.ChunkSize,
                Z = Mathf.FloorToInt(z/multiple)*Chunk.ChunkSize
            };

            Chunk containerChunk;
            Chunks.TryGetValue(pos, out containerChunk);

            return containerChunk;
        }

        public Block GetBlock(int x, int y, int z)
        {
            var containerChunk = GetChunk(x, y, z);

            if (containerChunk == null)
                return new BlockAir();

            var block = containerChunk.GetBlock(
                x - containerChunk.WorldPos.X,
                y - containerChunk.WorldPos.Y,
                z - containerChunk.WorldPos.Z);

            return block;
        }

        public void SetBlock(int x, int y, int z, Block block)
        {
            var chunk = GetChunk(x, y, z);

            if (chunk == null)
                return;

            chunk.SetBlock(x - chunk.WorldPos.X, y - chunk.WorldPos.Y, z - chunk.WorldPos.Z, block);
            chunk.ShouldUpdate = true;

            UpdateIfEqual(x - chunk.WorldPos.X, 0, new WorldPos(x - 1, y, z));
            UpdateIfEqual(x - chunk.WorldPos.X, Chunk.ChunkSize - 1, new WorldPos(x + 1, y, z));
            UpdateIfEqual(y - chunk.WorldPos.Y, 0, new WorldPos(x, y - 1, z));
            UpdateIfEqual(y - chunk.WorldPos.Y, Chunk.ChunkSize - 1, new WorldPos(x, y + 1, z));
            UpdateIfEqual(z - chunk.WorldPos.Z, 0, new WorldPos(x, y, z - 1));
            UpdateIfEqual(z - chunk.WorldPos.Z, Chunk.ChunkSize - 1, new WorldPos(x, y, z + 1));
        }

        private void UpdateIfEqual(int value1, int value2, WorldPos pos)
        {
            if (value1 != value2)
                return;

            var chunk = GetChunk(pos);
            if (chunk != null)
                chunk.ShouldUpdate = true;
        }
    }
}