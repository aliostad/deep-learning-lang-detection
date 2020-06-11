using UnityEngine;
using Assets.Core.Coordinates;
using Assets.Core.Tiles;
using System.Collections.Generic;


namespace Assets.Core
{


    public class Plane : MonoBehaviour
    {
        public static int PLANE_SIZE = 4;
        
        public static int PLANE_WIDTH = 64;
        public static int PLANE_HEIGHT = 4;
        public static int PLANE_DEPTH = 64;

        public static int XMIN = -(PLANE_WIDTH / 2);
        public static int XMAX = (PLANE_WIDTH / 2) - 1;  // 0 1 2 3 [4] for a 10 wide plane

        public static int YMIN = -(PLANE_HEIGHT / 2);
        public static int YMAX = (PLANE_HEIGHT / 2) - 1;

        public static int ZMIN = -(PLANE_DEPTH / 2);
        public static int ZMAX = (PLANE_DEPTH / 2) - 1;
    


        public string planeName = "Plane 0";

        public Dictionary<ChunkPos, Chunk> chunks = new Dictionary<ChunkPos, Chunk>();

        public GameObject chunkPreFab;


        public Plane() {}


        public void SetTile(int x, int y, int z, Tile tile) 
        {
            ChunkPos chunkPos = new TilePos(x, y, z).GetChunkPos();
            if (InXRange(chunkPos.x) && InYRange(chunkPos.y) && InZRange(chunkPos.z)) {
                Chunk chunk = GetChunk(chunkPos.x, chunkPos.y, chunkPos.z);
                if (chunk == null) 
                    return;
                chunk.SetTile(x, y, z, tile);

                if (x - chunkPos.GetTilePos().x == 0) {
                    Chunk neighbour = GetChunk(chunkPos.x - 1, chunkPos.y, chunkPos.z);
                    if (neighbour != null) neighbour.toUpdate = true;
                }
                if (x - chunkPos.GetTilePos().x == Chunk.CHUNK_WIDTH - 1) {
                    Chunk neighbour = GetChunk(chunkPos.x + 1, chunkPos.y, chunkPos.z);
                    if (neighbour != null) neighbour.toUpdate = true;
                }
                if (y - chunkPos.GetTilePos().y == 0) {
                    Chunk neighbour = GetChunk(chunkPos.x, chunkPos.y - 1, chunkPos.z);
                    if (neighbour != null) neighbour.toUpdate = true;
                }
                if (y - chunkPos.GetTilePos().y == Chunk.CHUNK_HEIGHT - 1) {
                    Chunk neighbour = GetChunk(chunkPos.x, chunkPos.y + 1, chunkPos.z);
                    if (neighbour != null) neighbour.toUpdate = true;
                }
                if (z - chunkPos.GetTilePos().z == 0) {
                    Chunk neighbour = GetChunk(chunkPos.x, chunkPos.y, chunkPos.z - 1);
                    if (neighbour != null) neighbour.toUpdate = true;
                }
                if (z - chunkPos.GetTilePos().z == Chunk.CHUNK_DEPTH - 1) {
                    Chunk neighbour = GetChunk(chunkPos.x, chunkPos.y, chunkPos.z + 1);
                    if (neighbour != null) neighbour.toUpdate = true;
                }
            }
        }


        public Tile GetTile(int x, int y, int z) 
        {
            ChunkPos chunkPos = new TilePos(x, y, z).GetChunkPos();
            if (InXRange(chunkPos.x) && InYRange(chunkPos.y) && InZRange(chunkPos.z)) {
                Chunk chunk = GetChunk(chunkPos.x, chunkPos.y, chunkPos.z);
                if (chunk == null) 
                    return new AirTile(0, 0, 0);
                return chunk.GetTile(x, y, z);
            } else {
                return new AirTile(0, 0, 0);
            }
        }


        public void CreateChunk(int x, int y, int z) 
        {
            ChunkPos chunkPos = new ChunkPos(x, y, z);

            GameObject chunkGameObj = Instantiate(
                chunkPreFab,
                Vector3.zero,
                Quaternion.Euler(Vector3.zero)
                ) as GameObject;

            chunkGameObj.name = string.Format("Chunk({0},{1},{2})", x, y, z);

            Chunk chunk = chunkGameObj.GetComponent<Chunk>();
            chunk.chunkPos = chunkPos;
            chunk.plane = this;

            chunks.Add(chunkPos, chunk);

            // Modify prefab clone here to fit the plane generation.
            var terrainGenerator = new TerrainGenerator();
            chunk = terrainGenerator.GenerateChunk(chunk);

            chunk.SetTilesUnmodified();
            Serialization.Load(chunk);
        }


        public void DestroyChunk(int x, int y, int z)
        {
            Chunk chunk = null;
            ChunkPos chunkPos = new ChunkPos(x,y,z);
            if (chunks.TryGetValue(chunkPos, out chunk)) {
                Serialization.SaveChunk(chunk);
                UnityEngine.Object.Destroy(chunk.gameObject);
                chunks.Remove(chunkPos);
            }
        }


        public void SetChunk(int x, int y, int z, Chunk chunk) 
        {
            chunks.Remove(chunk.chunkPos);
            chunks.Add(chunk.chunkPos, chunk);
        }


        public Chunk GetChunk(int x, int y, int z)
        {
            Chunk chunk = null;
            chunks.TryGetValue(new ChunkPos(x, y, z), out chunk);
            return chunk;
        }


        private bool InXRange(int x) 
        {
            return XMIN <= x && x <= XMAX;
        }


        private bool InYRange(int y)
        {
            return YMIN <= y && y <= YMAX;
        }


        private bool InZRange(int z) 
        {
            return ZMIN <= z && z <= ZMAX;
        }
    }
}