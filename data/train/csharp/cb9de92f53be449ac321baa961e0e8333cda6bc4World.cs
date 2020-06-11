using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Voxels
{
    public class World : MonoBehaviour
    {
        public GameObject chunkPrefab;

        Dictionary<WorldPos, Chunk> chunks = new Dictionary<WorldPos, Chunk>();

        [HideInInspector]
        public WorldData data;

        public Chunk CreateChunk(int x, int y, int z)
        {
            var chunkData = data.CreateChunk(x, y, z);
            var worldPos = chunkData.pos;

            // Instantiate the chunk at the coordinates using the chunk prefab
            // var go = Instantiate(chunkPrefab, worldPos.ToVector3(), Quaternion.identity);
            var go = Instantiate(chunkPrefab, Vector3.zero, Quaternion.identity);
            go.transform.SetParent(transform);

            var chunk = go.GetComponent<Chunk>();
            chunk.pos = worldPos;
            chunk.world = this;
            chunk.data = chunkData;
            chunk.Render();

            chunks.Add(worldPos, chunk);

            return chunk;
        }

        public void DestroyChunk(int x, int y, int z)
        {
            var chunk = GetChunk(x, y, z);

            if (chunk == null) return;

            chunks.Remove(chunk.pos);
            GameObject.Destroy(chunk.gameObject);
        }

        private Chunk GetChunk(int x, int y, int z)
        {
            var pos = data.GetChunkPos(x, y, z);

            Chunk chunk;
            chunks.TryGetValue(pos, out chunk);

            return chunk;
        }

        public void SetBlock(int x, int y, int z, BlockId block)
        {
            Chunk chunk = GetChunk(x, y, z);
            if (chunk == null)
            {
                chunk = CreateChunk(x, y, z);
            }

            data.SetBlock(x, y, z, block);
            chunk.Render();

            var xx = x - chunk.pos.x;
            var yy = y - chunk.pos.y;
            var zz = z - chunk.pos.z;
            var cs1 = MapConstants.ChunkSize - 1;

            UpdateIfEqual(xx, 0, new WorldPos(x - 1, y + 0, z + 0));
            UpdateIfEqual(xx, cs1, new WorldPos(x + 1, y + 0, z + 0));
            UpdateIfEqual(yy, 0, new WorldPos(x + 0, y - 1, z + 0));
            UpdateIfEqual(yy, cs1, new WorldPos(x + 0, y + 1, z + 0));
            UpdateIfEqual(zz, 0, new WorldPos(x + 0, y + 0, z - 1));
            UpdateIfEqual(zz, cs1, new WorldPos(x + 0, y + 0, z + 1));
        }

        void UpdateIfEqual(int value1, int value2, WorldPos pos)
        {
            if (value1 != value2)
            {
                return;
            }

            Chunk chunk = GetChunk(pos.x, pos.y, pos.z);
            if (chunk != null)
            {
                chunk.Render();
            }
        }
    }
}
