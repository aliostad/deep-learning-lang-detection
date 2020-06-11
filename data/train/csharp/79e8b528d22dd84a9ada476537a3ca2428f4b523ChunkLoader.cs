using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Assets.Core.Coordinates;


namespace Assets.Core
{
    

    public class ChunkLoader : MonoBehaviour
    {
        public Plane plane;


        private List<ChunkPos> updateList = new List<ChunkPos>();
        private List<ChunkPos> buildList = new List<ChunkPos>();

        /// Static check order for chunks in an expanding circle.
        static ChunkPos[] neighbourOrder = {    new ChunkPos( 0, 0,  0), new ChunkPos(-1, 0,  0), new ChunkPos( 0, 0, -1), new ChunkPos( 0, 0,  1), new ChunkPos( 1, 0,  0),
                                                new ChunkPos(-1, 0, -1), new ChunkPos(-1, 0,  1), new ChunkPos( 1, 0, -1), new ChunkPos( 1, 0,  1), new ChunkPos(-2, 0,  0),
                                                new ChunkPos( 0, 0, -2), new ChunkPos( 0, 0,  2), new ChunkPos( 2, 0,  0), new ChunkPos(-2, 0, -1), new ChunkPos(-2, 0,  1),
                                                new ChunkPos(-1, 0, -2), new ChunkPos(-1, 0,  2), new ChunkPos( 1, 0, -2), new ChunkPos( 1, 0,  2), new ChunkPos( 2, 0, -1),
                                                new ChunkPos( 2, 0,  1), new ChunkPos(-2, 0, -2), new ChunkPos(-2, 0,  2), new ChunkPos( 2, 0, -2), new ChunkPos( 2, 0,  2),
                                                new ChunkPos(-3, 0,  0), new ChunkPos( 0, 0, -3), new ChunkPos( 0, 0,  3), new ChunkPos( 3, 0,  0), new ChunkPos(-3, 0, -1),
                                                new ChunkPos(-3, 0,  1), new ChunkPos(-1, 0, -3), new ChunkPos(-1, 0,  3), new ChunkPos( 1, 0, -3), new ChunkPos( 1, 0,  3),
                                                new ChunkPos( 3, 0, -1), new ChunkPos( 3, 0,  1), new ChunkPos(-3, 0, -2), new ChunkPos(-3, 0,  2), new ChunkPos(-2, 0, -3),
                                                new ChunkPos(-2, 0,  3), new ChunkPos( 2, 0, -3), new ChunkPos( 2, 0,  3), new ChunkPos( 3, 0, -2), new ChunkPos( 3, 0,  2),
                                                new ChunkPos(-4, 0,  0), new ChunkPos( 0, 0, -4), new ChunkPos( 0, 0,  4), new ChunkPos( 4, 0,  0), new ChunkPos(-4, 0, -1),
                                                new ChunkPos(-4, 0,  1), new ChunkPos(-1, 0, -4), new ChunkPos(-1, 0,  4), new ChunkPos( 1, 0, -4), new ChunkPos( 1, 0,  4),
                                                new ChunkPos( 4, 0, -1), new ChunkPos( 4, 0,  1), new ChunkPos(-3, 0, -3), new ChunkPos(-3, 0,  3), new ChunkPos( 3, 0, -3),
                                                new ChunkPos( 3, 0,  3), new ChunkPos(-4, 0, -2), new ChunkPos(-4, 0,  2), new ChunkPos(-2, 0, -4), new ChunkPos(-2, 0,  4),
                                                new ChunkPos( 2, 0, -4), new ChunkPos( 2, 0,  4), new ChunkPos( 4, 0, -2), new ChunkPos( 4, 0,  2), new ChunkPos(-5, 0,  0),
                                                new ChunkPos(-4, 0, -3), new ChunkPos(-4, 0,  3), new ChunkPos(-3, 0, -4), new ChunkPos(-3, 0,  4), new ChunkPos( 0, 0, -5),
                                                new ChunkPos( 0, 0,  5), new ChunkPos( 3, 0, -4), new ChunkPos( 3, 0,  4), new ChunkPos( 4, 0, -3), new ChunkPos( 4, 0,  3),
                                                new ChunkPos( 5, 0,  0), new ChunkPos(-5, 0, -1), new ChunkPos(-5, 0,  1), new ChunkPos(-1, 0, -5), new ChunkPos(-1, 0,  5),
                                                new ChunkPos( 1, 0, -5), new ChunkPos( 1, 0,  5), new ChunkPos( 5, 0, -1), new ChunkPos( 5, 0,  1), new ChunkPos(-5, 0, -2),
                                                new ChunkPos(-5, 0,  2), new ChunkPos(-2, 0, -5), new ChunkPos(-2, 0,  5), new ChunkPos( 2, 0, -5), new ChunkPos( 2, 0,  5),
                                                new ChunkPos( 5, 0, -2), new ChunkPos( 5, 0,  2), new ChunkPos(-4, 0, -4), new ChunkPos(-4, 0,  4), new ChunkPos( 4, 0, -4),
                                                new ChunkPos( 4, 0,  4), new ChunkPos(-5, 0, -3), new ChunkPos(-5, 0,  3), new ChunkPos(-3, 0, -5), new ChunkPos(-3, 0,  5),
                                                new ChunkPos( 3, 0, -5), new ChunkPos( 3, 0,  5), new ChunkPos( 5, 0, -3), new ChunkPos( 5, 0,  3), new ChunkPos(-6, 0,  0),
                                                new ChunkPos( 0, 0, -6), new ChunkPos( 0, 0,  6), new ChunkPos( 6, 0,  0), new ChunkPos(-6, 0, -1), new ChunkPos(-6, 0,  1),
                                                new ChunkPos(-1, 0, -6), new ChunkPos(-1, 0,  6), new ChunkPos( 1, 0, -6), new ChunkPos( 1, 0,  6), new ChunkPos( 6, 0, -1),
                                                new ChunkPos( 6, 0,  1), new ChunkPos(-6, 0, -2), new ChunkPos(-6, 0,  2), new ChunkPos(-2, 0, -6), new ChunkPos(-2, 0,  6),
                                                new ChunkPos( 2, 0, -6), new ChunkPos( 2, 0,  6), new ChunkPos( 6, 0, -2), new ChunkPos( 6, 0,  2), new ChunkPos(-5, 0, -4),
                                                new ChunkPos(-5, 0,  4), new ChunkPos(-4, 0, -5), new ChunkPos(-4, 0,  5), new ChunkPos( 4, 0, -5), new ChunkPos( 4, 0,  5),
                                                new ChunkPos( 5, 0, -4), new ChunkPos( 5, 0,  4), new ChunkPos(-6, 0, -3), new ChunkPos(-6, 0,  3), new ChunkPos(-3, 0, -6),
                                                new ChunkPos(-3, 0,  6), new ChunkPos( 3, 0, -6), new ChunkPos( 3, 0,  6), new ChunkPos( 6, 0, -3), new ChunkPos( 6, 0,  3),
                                                new ChunkPos(-7, 0,  0), new ChunkPos( 0, 0, -7), new ChunkPos( 0, 0,  7), new ChunkPos( 7, 0,  0), new ChunkPos(-7, 0, -1),
                                                new ChunkPos(-7, 0,  1), new ChunkPos(-5, 0, -5), new ChunkPos(-5, 0,  5), new ChunkPos(-1, 0, -7), new ChunkPos(-1, 0,  7),
                                                new ChunkPos( 1, 0, -7), new ChunkPos( 1, 0,  7), new ChunkPos( 5, 0, -5), new ChunkPos( 5, 0,  5), new ChunkPos( 7, 0, -1),
                                                new ChunkPos( 7, 0,  1), new ChunkPos(-6, 0, -4), new ChunkPos(-6, 0,  4), new ChunkPos(-4, 0, -6), new ChunkPos(-4, 0,  6),
                                                new ChunkPos( 4, 0, -6), new ChunkPos( 4, 0,  6), new ChunkPos( 6, 0, -4), new ChunkPos( 6, 0,  4), new ChunkPos(-7, 0, -2),
                                                new ChunkPos(-7, 0,  2), new ChunkPos(-2, 0, -7), new ChunkPos(-2, 0,  7), new ChunkPos( 2, 0, -7), new ChunkPos( 2, 0,  7),
                                                new ChunkPos( 7, 0, -2), new ChunkPos( 7, 0,  2), new ChunkPos(-7, 0, -3), new ChunkPos(-7, 0,  3), new ChunkPos(-3, 0, -7),
                                                new ChunkPos(-3, 0,  7), new ChunkPos( 3, 0, -7), new ChunkPos( 3, 0,  7), new ChunkPos( 7, 0, -3), new ChunkPos( 7, 0,  3),
                                                new ChunkPos(-6, 0, -5), new ChunkPos(-6, 0,  5), new ChunkPos(-5, 0, -6), new ChunkPos(-5, 0,  6), new ChunkPos( 5, 0, -6),
                                                new ChunkPos( 5, 0,  6), new ChunkPos( 6, 0, -5), new ChunkPos( 6, 0,  5) };


        private int garbageCollectionTimer = 0;
        // Number of frames until garbae colelction occurs.
        private readonly int garbageCollectionPeriod = 10;
        // Distance in chunks until a chunk should be deleted.
        private readonly int garbageCollectionDistance = 10;


        /// <summary>
        /// Update is called every frame, if the MonoBehaviour is enabled.
        /// </summary>
        public void Update()
        {
            GarbageCollectChunks();
            FindChunksToLoad();
            LoadChunks();
            RenderChunks();
        }


        ///<summary>
        /// 
        ///<summary>
        private void FindChunksToLoad()
        {
            // Get the position of this gameobject to generate around
            ChunkPos playerChunkPos = ChunkPos.FromWorldPos(transform.position);

            if (buildList.Count == 0) {
                // Cycle through the neighbouring chunks
                for (int i = 0; i < neighbourOrder.Length; i++) {
                    ChunkPos chunkPos = new ChunkPos(
                        neighbourOrder[i].x + playerChunkPos.x,
                        playerChunkPos.y,
                        neighbourOrder[i].z + playerChunkPos.z
                        );
                    
                    Chunk chunk = plane.GetChunk(chunkPos.x, chunkPos.y, chunkPos.z);
                    // If the chunk already exists and it's already rendered or in queue - continue
                    if (chunk != null && (chunk.rendered || updateList.Contains(chunkPos)))
                        continue; 
                    // Render a column of chunks, 4 below and 4 above.
                    for (int y = -4; y < 4; y++) 
                        buildList.Add(new ChunkPos(chunkPos.x, chunkPos.y + y, chunkPos.z));
                    return;
                }
            }
        }


        ///<summary>
        /// Calls upon the plane to build/create the chunk and all it's neighbours, in order to ensure
        /// that it can render correctly (needs information from neighbouring chunks).
        ///<summary>
        private void BuildChunk(ChunkPos pos)
        {
            for (int y = pos.y - 1; y <= pos.y + 1; y++) {
                if (y < Plane.YMIN || y > Plane.YMAX) continue;

                for (int x = pos.x - 1; x <= pos.x + 1; x++) {
                    if (x < Plane.XMIN || x > Plane.XMAX) continue;

                    for (int z = pos.z - 1; z <= pos.z + 1; z++) {
                        if (z < Plane.ZMIN || z > Plane.ZMAX) continue;
                        
                        if (plane.GetChunk(x, y, z) == null)
                            plane.CreateChunk(x, y, z);
                    }
                }                
            }
            updateList.Add(pos);
        }


        private void LoadChunks()
        {
            for (int i = 0; i < 2; i++) {
                if (buildList.Count != 0) {
                    BuildChunk(buildList[0]);
                    buildList.RemoveAt(0);
                }
            }
        }


        private void RenderChunks()
        {
            for (int i = 0; i < updateList.Count; i++) {
                Chunk chunk = plane.GetChunk(updateList[0].x, updateList[0].y, updateList[0].z);
                if (chunk != null) chunk.toUpdate = true;
                updateList.RemoveAt(0);
            }
        }


        private void GarbageCollectChunks()
        {
            if (garbageCollectionTimer == garbageCollectionPeriod) {
                List<ChunkPos> toDelete = new List<ChunkPos>();
                ChunkPos playerChunkPos = ChunkPos.FromWorldPos(transform.position);
                foreach (var chunk in plane.chunks) {
                    int dx = Mathf.Abs(playerChunkPos.x - chunk.Value.chunkPos.x); 
                    int dy = Mathf.Abs(playerChunkPos.y - chunk.Value.chunkPos.y); 
                    int dz = Mathf.Abs(playerChunkPos.z - chunk.Value.chunkPos.z);
                    if (dx >= garbageCollectionDistance ||
                        dy >= garbageCollectionDistance ||
                        dz >= garbageCollectionDistance)
                        toDelete.Add(chunk.Key);
                }

                foreach (var chunkPos in toDelete) {
                    plane.DestroyChunk(chunkPos.x, chunkPos.y, chunkPos.z);
                }
                garbageCollectionTimer = 0;
            } else {
                garbageCollectionTimer++;
            }
        }

    }
}