using System;
using System.Linq;
using System.Collections.Generic;
using Assets.Scripts.BlockTypes;
using Assets.Scripts.Player;
using UnityEngine;

namespace Assets.Scripts
{
    public class World : MonoBehaviour
    {
        public GameObject chunkPrefab;
        public List<Chunk> Chunks = new List<Chunk>();

        private void Start()
        {
            GenerateChunks();
        }

        private void GenerateChunks()
        {
            for (var x = 0; x < 4; x++)
            {
                for (var z = 0; z < 4; z++)
                {
                    var chunkPos = new Vector3(x * Chunk.Width, 0, z * Chunk.Width);

                    var chunkObj = Instantiate(chunkPrefab, chunkPos, Quaternion.identity, transform);
                    chunkObj.name = string.Format("Chunk ({0}, {1})", x, z);

                    var chunk = chunkObj.GetComponent<Chunk>();
                    chunk.World = this;
                    chunk.Position = chunkPos;
                    chunk.GenerateBlocks();
                    Chunks.Add(chunk);
                }
            }
        }

        #region Block manipulation

        public Block GetBlock(int x, int y, int z)
        {
            var chunk = GetChunk(x, y, z);
            if (chunk == null) return new BlockAir();
            var block = chunk.GetBlock(
                x - (int)chunk.Position.x,
                y - (int)chunk.Position.y,
                z - (int)chunk.Position.z);

            return block;
        }

        public Block GetBlock(RaycastHit hit, bool adjacent = false)
        {
            var chunk = hit.collider.GetComponent<Chunk>();
            if (chunk == null)
                return null;

            var position = BlockManipulation.GetBlockPosition(hit, adjacent);
            var block = chunk.World.GetBlock((int) position.x, (int) position.y, (int) position.z);
            return block;
        }

        public void SetBlock(Block block, int x, int y, int z)
        {
            var chunk = GetChunk(x, y, z);
            if (chunk != null)
            {
                chunk.SetBlock(
                    block, 
                    x - (int)chunk.Position.x, 
                    y - (int)chunk.Position.y, 
                    z - (int)chunk.Position.z);

                chunk.NeedUpdate = true;
            }
        }

        public Chunk GetChunk(int x, int y, int z)
        {
            return Chunks.SingleOrDefault(c =>
            {
                var position = new Vector3(
                    Mathf.FloorToInt(x / Chunk.Width) * Chunk.Width,
                    Mathf.FloorToInt(y / Chunk.Height) * Chunk.Height,
                    Mathf.FloorToInt(z / Chunk.Width) * Chunk.Width);

                return c.Position == position;
            });
        }

        #endregion
    }
}