using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace ASTutorial
{
    public class World : MonoBehaviour
    {
        public Dictionary<WorldPos, Chunk> chunks = new Dictionary<WorldPos, Chunk>();
        public GameObject chunkPrefab;
        public string worldName = "world";

        //public int newChunkX;
        //public int newChunkY;
        //public int newChunkZ;
        //public bool genChunk;
        //
        //private void Start()
        //{
        //    for (int x = -4; x < 4; x++)
        //    {
        //        for (int y = -1; y < 3; y++)
        //        {
        //            for (int z = -4; z < 4; z++)
        //            {
        //                CreateChunk(x * 16, y * 16, z * 16);
        //            }
        //        }
        //    }
        //}
        //
        //private void Update()
        //{
        //    if(genChunk)
        //    {
        //        genChunk = false;
        //        WorldPos chunkPos = new WorldPos(newChunkX, newChunkY, newChunkZ);
        //        Chunk chunk = null;
        //
        //        if(chunks.TryGetValue(chunkPos, out chunk))
        //        {
        //            DestroyChunk(chunkPos.x, chunkPos.y, chunkPos.z);
        //        }
        //        else
        //        {
        //            CreateChunk(chunkPos.x, chunkPos.y, chunkPos.z);
        //        }
        //    }
        //}

        private void UpdateIfEqual(int value1, int value2, WorldPos pos)
        {
            if(value1 == value2)
            {
                Chunk chunk = GetChunk(pos.x, pos.y, pos.z);
                if(chunk != null)
                {
                    chunk.update = true;
                }
            }
        }

        public void CreateChunk(int x, int y, int z)
        {
            WorldPos worldPos = new WorldPos(x, y, z);

            GameObject newChunkObject = Instantiate(chunkPrefab, new Vector3(x, y, z), Quaternion.Euler(Vector3.zero)) as GameObject;
            Chunk newChunk = newChunkObject.GetComponent<Chunk>();

            newChunk.pos = worldPos;
            newChunk.world = this;

            chunks.Add(worldPos, newChunk);

            //// Example Chunk Population
            //for (int xi = 0; xi < 16; xi++)
            //{
            //    for (int yi = 0; yi < 16; yi++)
            //    {
            //        for (int zi = 0; zi < 16; zi++)
            //        {
            //            if (yi <= 7)
            //            {
            //                SetBlock(x + xi, y + yi, z + zi, new BlockGrass());
            //            }
            //            else
            //            {
            //                SetBlock(x + xi, y + yi, z + zi, new BlockAir());
            //            }
            //        }
            //    }
            //}
            //// End Example Chunk Population

            TerrainGen terrainGen = new TerrainGen();
            newChunk = terrainGen.ChunkGen(newChunk);
            newChunk.SetBlocksUnmodified();
            bool loaded = Serialization.Load(newChunk);
        }

        public Chunk GetChunk(int x, int y, int z)
        {
            WorldPos pos = new WorldPos();
            float multiple = Chunk.chunkSize;
            pos.x = Mathf.FloorToInt(x / multiple) * Chunk.chunkSize;
            pos.y = Mathf.FloorToInt(y / multiple) * Chunk.chunkSize;
            pos.z = Mathf.FloorToInt(z / multiple) * Chunk.chunkSize;
            Chunk containerChunk = null;
            chunks.TryGetValue(pos, out containerChunk);
            return containerChunk;
        }

        public void DestroyChunk(int x, int y, int z)
        {
            Chunk chunk = null;
            if(chunks.TryGetValue(new WorldPos(x,y,z), out chunk))
            {
                Serialization.SaveChunk(chunk);
                Destroy(chunk.gameObject);
                chunks.Remove(new WorldPos(x, y, z));
            }
        }

        public void SetBlock(int x, int y, int z, Block block)
        {
            Chunk chunk = GetChunk(x, y, z);
            if(chunk != null)
            {
                chunk.SetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, block);
                chunk.update = true;

                UpdateIfEqual(x - chunk.pos.x, 0, new WorldPos(x - 1, y, z));
                UpdateIfEqual(x - chunk.pos.x, Chunk.chunkSize - 1, new WorldPos(x + 1, y, z));
                UpdateIfEqual(y - chunk.pos.y, 0, new WorldPos(x, y - 1, z));
                UpdateIfEqual(y - chunk.pos.y, Chunk.chunkSize - 1, new WorldPos(x, y + 1, z));
                UpdateIfEqual(z - chunk.pos.z, 0, new WorldPos(x, y, z - 1));
                UpdateIfEqual(z - chunk.pos.z, Chunk.chunkSize - 1, new WorldPos(x, y, z + 1));
            }
        }

        public Block GetBlock(int x, int y, int z)
        {
            Chunk containerChunk = GetChunk(x, y, z);
            if(containerChunk != null)
            {
                Block block = containerChunk.GetBlock(x - containerChunk.pos.x, y - containerChunk.pos.y, z - containerChunk.pos.z);
                return block;
            }
            return new BlockAir();
        }
    }
}