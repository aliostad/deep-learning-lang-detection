using System;
using System.Collections.Generic;
using UnityEngine;
using BeeGame.Terrain.LandGeneration;

namespace BeeGame.Terrain.Chunks
{
    /// <summary>
    /// Loads the <see cref="Chunk"/>s around the player
    /// </summary>
    public class LoadChunks : MonoBehaviour
    {
        #region Data
        /// <summary>
        /// The world the player is in
        /// </summary>
        public World world;

        /// <summary>
        /// List if chunks to build
        /// </summary>
        private List<ChunkWorldPos> buildList = new List<ChunkWorldPos>();

        /// <summary>
        /// Positions to make chunks aroud the player
        /// /// </summary>
        private static ChunkWorldPos[] chunkPositions = new ChunkWorldPos[] {   new ChunkWorldPos( 0, 0,  0), new ChunkWorldPos(-1, 0,  0), new ChunkWorldPos( 0, 0, -1), new ChunkWorldPos( 0, 0,  1), new ChunkWorldPos( 1, 0,  0),
                             new ChunkWorldPos(-1, 0, -1), new ChunkWorldPos(-1, 0,  1), new ChunkWorldPos( 1, 0, -1), new ChunkWorldPos( 1, 0,  1), new ChunkWorldPos(-2, 0,  0),
                             new ChunkWorldPos( 0, 0, -2), new ChunkWorldPos( 0, 0,  2), new ChunkWorldPos( 2, 0,  0), new ChunkWorldPos(-2, 0, -1), new ChunkWorldPos(-2, 0,  1),
                             new ChunkWorldPos(-1, 0, -2), new ChunkWorldPos(-1, 0,  2), new ChunkWorldPos( 1, 0, -2), new ChunkWorldPos( 1, 0,  2), new ChunkWorldPos( 2, 0, -1),
                             new ChunkWorldPos( 2, 0,  1), new ChunkWorldPos(-2, 0, -2), new ChunkWorldPos(-2, 0,  2), new ChunkWorldPos( 2, 0, -2), new ChunkWorldPos( 2, 0,  2),
                             new ChunkWorldPos(-3, 0,  0), new ChunkWorldPos( 0, 0, -3), new ChunkWorldPos( 0, 0,  3), new ChunkWorldPos( 3, 0,  0), new ChunkWorldPos(-3, 0, -1),
                             new ChunkWorldPos(-3, 0,  1), new ChunkWorldPos(-1, 0, -3), new ChunkWorldPos(-1, 0,  3), new ChunkWorldPos( 1, 0, -3), new ChunkWorldPos( 1, 0,  3),
                             new ChunkWorldPos( 3, 0, -1), new ChunkWorldPos( 3, 0,  1), new ChunkWorldPos(-3, 0, -2), new ChunkWorldPos(-3, 0,  2), new ChunkWorldPos(-2, 0, -3),
                             new ChunkWorldPos(-2, 0,  3), new ChunkWorldPos( 2, 0, -3), new ChunkWorldPos( 2, 0,  3), new ChunkWorldPos( 3, 0, -2), new ChunkWorldPos( 3, 0,  2),
                             new ChunkWorldPos(-4, 0,  0), new ChunkWorldPos( 0, 0, -4), new ChunkWorldPos( 0, 0,  4), new ChunkWorldPos( 4, 0,  0), new ChunkWorldPos(-4, 0, -1),
                             new ChunkWorldPos(-4, 0,  1), new ChunkWorldPos(-1, 0, -4), new ChunkWorldPos(-1, 0,  4), new ChunkWorldPos( 1, 0, -4), new ChunkWorldPos( 1, 0,  4),
                             new ChunkWorldPos( 4, 0, -1), new ChunkWorldPos( 4, 0,  1), new ChunkWorldPos(-3, 0, -3), new ChunkWorldPos(-3, 0,  3), new ChunkWorldPos( 3, 0, -3),
                             new ChunkWorldPos( 3, 0,  3), new ChunkWorldPos(-4, 0, -2), new ChunkWorldPos(-4, 0,  2), new ChunkWorldPos(-2, 0, -4), new ChunkWorldPos(-2, 0,  4),
                             new ChunkWorldPos( 2, 0, -4), new ChunkWorldPos( 2, 0,  4), new ChunkWorldPos( 4, 0, -2), new ChunkWorldPos( 4, 0,  2), new ChunkWorldPos(-5, 0,  0),
                             new ChunkWorldPos(-4, 0, -3), new ChunkWorldPos(-4, 0,  3), new ChunkWorldPos(-3, 0, -4), new ChunkWorldPos(-3, 0,  4), new ChunkWorldPos( 0, 0, -5),
                             new ChunkWorldPos( 0, 0,  5), new ChunkWorldPos( 3, 0, -4), new ChunkWorldPos( 3, 0,  4), new ChunkWorldPos( 4, 0, -3), new ChunkWorldPos( 4, 0,  3),
                             new ChunkWorldPos( 5, 0,  0), new ChunkWorldPos(-5, 0, -1), new ChunkWorldPos(-5, 0,  1), new ChunkWorldPos(-1, 0, -5), new ChunkWorldPos(-1, 0,  5),
                             new ChunkWorldPos( 1, 0, -5), new ChunkWorldPos( 1, 0,  5), new ChunkWorldPos( 5, 0, -1), new ChunkWorldPos( 5, 0,  1), new ChunkWorldPos(-5, 0, -2),
                             new ChunkWorldPos(-5, 0,  2), new ChunkWorldPos(-2, 0, -5), new ChunkWorldPos(-2, 0,  5), new ChunkWorldPos( 2, 0, -5), new ChunkWorldPos( 2, 0,  5),
                             new ChunkWorldPos( 5, 0, -2), new ChunkWorldPos( 5, 0,  2), new ChunkWorldPos(-4, 0, -4), new ChunkWorldPos(-4, 0,  4), new ChunkWorldPos( 4, 0, -4),
                             new ChunkWorldPos( 4, 0,  4), new ChunkWorldPos(-5, 0, -3), new ChunkWorldPos(-5, 0,  3), new ChunkWorldPos(-3, 0, -5), new ChunkWorldPos(-3, 0,  5),
                             new ChunkWorldPos( 3, 0, -5), new ChunkWorldPos( 3, 0,  5), new ChunkWorldPos( 5, 0, -3), new ChunkWorldPos( 5, 0,  3), new ChunkWorldPos(-6, 0,  0),
                             new ChunkWorldPos( 0, 0, -6), new ChunkWorldPos( 0, 0,  6), new ChunkWorldPos( 6, 0,  0), new ChunkWorldPos(-6, 0, -1), new ChunkWorldPos(-6, 0,  1),
                             new ChunkWorldPos(-1, 0, -6), new ChunkWorldPos(-1, 0,  6), new ChunkWorldPos( 1, 0, -6), new ChunkWorldPos( 1, 0,  6), new ChunkWorldPos( 6, 0, -1),
                             new ChunkWorldPos( 6, 0,  1), new ChunkWorldPos(-6, 0, -2), new ChunkWorldPos(-6, 0,  2), new ChunkWorldPos(-2, 0, -6), new ChunkWorldPos(-2, 0,  6),
                             new ChunkWorldPos( 2, 0, -6), new ChunkWorldPos( 2, 0,  6), new ChunkWorldPos( 6, 0, -2), new ChunkWorldPos( 6, 0,  2), new ChunkWorldPos(-5, 0, -4),
                             new ChunkWorldPos(-5, 0,  4), new ChunkWorldPos(-4, 0, -5), new ChunkWorldPos(-4, 0,  5), new ChunkWorldPos( 4, 0, -5), new ChunkWorldPos( 4, 0,  5),
                             new ChunkWorldPos( 5, 0, -4), new ChunkWorldPos( 5, 0,  4), new ChunkWorldPos(-6, 0, -3), new ChunkWorldPos(-6, 0,  3), new ChunkWorldPos(-3, 0, -6),
                             new ChunkWorldPos(-3, 0,  6), new ChunkWorldPos( 3, 0, -6), new ChunkWorldPos( 3, 0,  6), new ChunkWorldPos( 6, 0, -3), new ChunkWorldPos( 6, 0,  3),
                             new ChunkWorldPos(-7, 0,  0), new ChunkWorldPos( 0, 0, -7), new ChunkWorldPos( 0, 0,  7), new ChunkWorldPos( 7, 0,  0), new ChunkWorldPos(-7, 0, -1),
                             new ChunkWorldPos(-7, 0,  1), new ChunkWorldPos(-5, 0, -5), new ChunkWorldPos(-5, 0,  5), new ChunkWorldPos(-1, 0, -7), new ChunkWorldPos(-1, 0,  7),
                             new ChunkWorldPos( 1, 0, -7), new ChunkWorldPos( 1, 0,  7), new ChunkWorldPos( 5, 0, -5), new ChunkWorldPos( 5, 0,  5), new ChunkWorldPos( 7, 0, -1),
                             new ChunkWorldPos( 7, 0,  1), new ChunkWorldPos(-6, 0, -4), new ChunkWorldPos(-6, 0,  4), new ChunkWorldPos(-4, 0, -6), new ChunkWorldPos(-4, 0,  6),
                             new ChunkWorldPos( 4, 0, -6), new ChunkWorldPos( 4, 0,  6), new ChunkWorldPos( 6, 0, -4), new ChunkWorldPos( 6, 0,  4), new ChunkWorldPos(-7, 0, -2),
                             new ChunkWorldPos(-7, 0,  2), new ChunkWorldPos(-2, 0, -7), new ChunkWorldPos(-2, 0,  7), new ChunkWorldPos( 2, 0, -7), new ChunkWorldPos( 2, 0,  7),
                             new ChunkWorldPos( 7, 0, -2), new ChunkWorldPos( 7, 0,  2), new ChunkWorldPos(-7, 0, -3), new ChunkWorldPos(-7, 0,  3), new ChunkWorldPos(-3, 0, -7),
                             new ChunkWorldPos(-3, 0,  7), new ChunkWorldPos( 3, 0, -7), new ChunkWorldPos( 3, 0,  7), new ChunkWorldPos( 7, 0, -3), new ChunkWorldPos( 7, 0,  3),
                             new ChunkWorldPos(-6, 0, -5), new ChunkWorldPos(-6, 0,  5), new ChunkWorldPos(-5, 0, -6), new ChunkWorldPos(-5, 0,  6), new ChunkWorldPos( 5, 0, -6),
                             new ChunkWorldPos( 5, 0,  6), new ChunkWorldPos( 6, 0, -5), new ChunkWorldPos( 6, 0,  5) };

        /// <summary>
        /// <see cref="Chunk"/>s in a 3x3 radius around the player that should have a collision mesh
        /// </summary>
        private static ChunkWorldPos[] nearbyChunks = new ChunkWorldPos[] { new ChunkWorldPos(0, 0, 0), new ChunkWorldPos(1, 0, 0), new ChunkWorldPos(-1, 0, 0), new ChunkWorldPos(0, 0, 1), new ChunkWorldPos(0, 0, -1),
                                                                            new ChunkWorldPos(1, 0, 1), new ChunkWorldPos(1, 0, -1), new ChunkWorldPos(-1, 0, 1), new ChunkWorldPos(-1, 0, -1)};

        /// <summary>
        /// Timer for chunk removal
        /// </summary>
        private static int timer = 0;
        #endregion

        /// <summary>
        /// Sets the world
        /// </summary>
        private void Start()
        {
            LandGeneration.Terrain.world = world;
        }

        /// <summary>
        /// Builds, Renders, and Remmoves <see cref="Chunk"/>s
        /// </summary>
        void Update()
        {
            if (DeleteChunks())
                return;
            if (!world.chunkHasMadeCollisionMesh)
            {
                FindChunksToLoad();
                LoadAndRenderChunks();
                ApplyCollsionMeshToNearbyChunks();
            }
            //* stops chunks being made and collision meshes being made at the same time
            world.chunkHasMadeCollisionMesh = false;
        }

        /// <summary>
        /// Makes a collsion mesh for the <see cref="Chunk"/>s nearest to the player to reduce lag created by PhysX mesh bakeing
        /// </summary>
        /// <remarks>
        /// We dont need to worry about removeing <see cref="Chunk"/> collision meshes as once PhysX has baked then they have minimal performance impact
        /// Doing things this wayt also spreads out the PhysX mesh bakeing
        /// </remarks>
        void ApplyCollsionMeshToNearbyChunks()
        {
            //* gets the player position in chunk coordinates
            ChunkWorldPos playerPos = new ChunkWorldPos(Mathf.FloorToInt(transform.position.x / Chunk.chunkSize) * Chunk.chunkSize, Mathf.FloorToInt(transform.position.y / Chunk.chunkSize) * Chunk.chunkSize, Mathf.FloorToInt(transform.position.z / Chunk.chunkSize) * Chunk.chunkSize);

            for (int i = 0; i < nearbyChunks.Length; i++)
            {
                ChunkWorldPos chunkPos = new ChunkWorldPos(nearbyChunks[i].x * Chunk.chunkSize + playerPos.x, 0, nearbyChunks[i].z * Chunk.chunkSize + playerPos.z);

                for (int j = -1; j < 2; j++)
                {
                    Chunk nearbyChunk = world.GetChunk(chunkPos.x, j * Chunk.chunkSize, chunkPos.z);

                    if (nearbyChunk != null)
                        nearbyChunk.applyCollisionMesh = true;
                }
            }
        }

        /// <summary>
        /// Gets the chunks that sould be built and renders then renders them
        /// </summary>
        void LoadAndRenderChunks()
        {
            //* if their is somethign in the build list new chunks can be made
            if (buildList.Count != 0)
            {
                //* makes all of the chunks in the build list. Works backwards through the list so that no chunk is missed because chunks are removed from the list as they are made
                for (int i = buildList.Count - 1, j = 0; i >= 0 && j < 8; i--, j++)
                {
                    BuildChunk(buildList[0]);
                    buildList.RemoveAt(0);
                }
            }
        }

        /// <summary>
        /// Finds the <see cref="Chunk"/>s that should be rendered
        /// </summary>
        void FindChunksToLoad()
        {
            if (buildList.Count == 0)
            {
                //* gets the player position in chunk coordinates
                ChunkWorldPos playerPos = new ChunkWorldPos(Mathf.FloorToInt(transform.position.x / Chunk.chunkSize) * Chunk.chunkSize, Mathf.FloorToInt(transform.position.y / Chunk.chunkSize) * Chunk.chunkSize, Mathf.FloorToInt(transform.position.z / Chunk.chunkSize) * Chunk.chunkSize);

                //* check all of the chunk positions and if that position does not have a chunk in it make it
                for (int i = 0; i < chunkPositions.Length; i++)
                {
                    ChunkWorldPos newChunkPos = new ChunkWorldPos(chunkPositions[i].x * Chunk.chunkSize + playerPos.x, 0, chunkPositions[i].z * Chunk.chunkSize + playerPos.z);

                    Chunk newChunk = world.GetChunk(newChunkPos.x, newChunkPos.y, newChunkPos.z);
                    
                    if (newChunk != null && (newChunk.rendered || buildList.Contains(newChunkPos)))
                        continue;
                    
                    for (int y = -1; y < 2; y++)
                    {
                        for (int x = newChunkPos.x - Chunk.chunkSize; x < newChunkPos.x + Chunk.chunkSize; x += Chunk.chunkSize)
                        {
                            for (int z = newChunkPos.z - Chunk.chunkSize; z < newChunkPos.z + Chunk.chunkSize; z += Chunk.chunkSize)
                            {
                                buildList.Add(new ChunkWorldPos(x, y * Chunk.chunkSize, z));
                            }
                        }
                    }
                    return;
                }
            }
        }

        /// <summary>
        /// Makes a chunk in the given positon if it does not already exist
        /// </summary>
        /// <param name="pos">hte positon of the new chunk</param>
        void BuildChunk(ChunkWorldPos pos)
        {
            if (world.GetChunk(pos.x, pos.y, pos.z) == null)
                world.CreateChunk(pos.x, pos.y, pos.z);
        }

        /// <summary>
        /// Destroys <see cref="Chunk"/>s every 10 calls
        /// </summary>
        /// <returns>true if <see cref="Chunk"/>s were destroyed</returns>
        bool DeleteChunks()
        {
            //* destroys every 10 call to reduce load on CPU so that chunks are not destroyed and created at the same time
            if(timer == 10)
            {
                timer = 0;
                var chunksToDelete = new List<ChunkWorldPos>();

                // *go through all of the built chunks and if the chunk is 256 units away it is assumed to be out of sight so is added to the destroy list
                foreach (var chunk in world.chunks)
                {
                    float distance = Vector3.Distance(chunk.Value.transform.position, transform.position);

                    if (distance > 256)
                        chunksToDelete.Add(chunk.Key);
                }

                foreach (var chunk in chunksToDelete)
                {
                    world.DestroyChunk(chunk.x, chunk.y, chunk.z);
                }

                return true;
            }

            timer++;

            return false;
        }
    }
}