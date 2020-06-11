using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using BeeGame.Terrain.Chunks;
using BeeGame.Blocks;

namespace BeeGame.Terrain.LandGeneration
{
    /// <summary>
    /// Allows inter <see cref="Chunk"/> communication as it stores a list of active chunks
    /// </summary>
    public class World : MonoBehaviour
    {
        #region Data
        /// <summary>
        /// All of the currently loaded chunks
        /// </summary>
        public Dictionary<ChunkWorldPos, Chunk> chunks = new Dictionary<ChunkWorldPos, Chunk>();

        /// <summary>
        /// The chunk prefab
        /// </summary>
        public GameObject chunkPrefab;

        /// <summary>
        /// Has a <see cref="Chunk"/> made a collision mesh?
        /// </summary>
        public bool chunkHasMadeCollisionMesh = false;
        #endregion

        #region Creation and Destruction
        #region Chunk
        /// <summary>
        /// Creates a chunk at the given x, y, z
        /// </summary>
        /// <param name="x">X pos to make the new chunk</param>
        /// <param name="y">Y pos to make the new chunk</param>
        /// <param name="z">Z pos to make the new chunk</param>
        public void CreateChunk(int x, int y, int z)
        {
            //* pos of the chunk
            ChunkWorldPos pos = new ChunkWorldPos(x, y, z);

            //* makes the chunk at the given position
            GameObject newChunk = Instantiate(chunkPrefab, new Vector3(x, y, z), Quaternion.identity);
            
            Chunk chunk = newChunk.GetComponent<Chunk>();

            //* setting the chunks pos and a reference to this
            chunk.chunkWorldPos = pos;
            chunk.world = this;

            //* adds the nwe chunk to the dictionary
            chunks.Add(pos, chunk);

            //* generates the new chunks blocks
            chunk = new TerrainGeneration().ChunkGen(chunk);
            
            //loads any blocks that the chunk has had modified
            Serialization.Serialization.LoadChunk(chunk);

            //* updates all chunks around this one to reduce drawing of unecisary faces
            chunks.TryGetValue(new ChunkWorldPos(x, y - 16, z), out chunk);
            if (chunk != null)
                chunk.update = true;

            chunks.TryGetValue(new ChunkWorldPos(x, y, z - 16), out chunk);
            if (chunk != null)
                chunk.update = true;

            chunks.TryGetValue(new ChunkWorldPos(x - 16, y, z), out chunk);
            if (chunk != null)
                chunk.update = true;

            chunks.TryGetValue(new ChunkWorldPos(x, y + 16, z), out chunk);
            if (chunk != null)
                chunk.update = true;

            chunks.TryGetValue(new ChunkWorldPos(x, y, z + 16), out chunk);
            if (chunk != null)
                chunk.update = true;

            chunks.TryGetValue(new ChunkWorldPos(x + 16, y, z), out chunk);
            if (chunk != null)
                chunk.update = true;
            //* the chunk will then make its meshes
        }

        /// <summary>
        /// Destroys a <see cref="Chunk"/> st the given x, y, z postion
        /// </summary>
        /// <param name="x">X pos if the chunk</param>
        /// <param name="y">Y pos if the chunk</param>
        /// <param name="z">Z pos if the chunk</param>
        public void DestroyChunk(int x, int y, int z)
        {
            //* if teh chnks exists destroy it
            if (chunks.TryGetValue(new ChunkWorldPos(x, y, z), out Chunk chunk))
            {
                //* saves the chunk before destroying it incase any block were changed in it
                Serialization.Serialization.SaveChunk(chunk);
                Destroy(chunk.gameObject);
                chunks.Remove(new ChunkWorldPos(x, y, z));
            }
        }
        #endregion

        #region Block
        /// <summary>
        /// Sets a <see cref="Block"/> at the given position
        /// </summary>
        /// <param name="x">X pos of the block</param>
        /// <param name="y">Y pos of the block</param>
        /// <param name="z">Z pos of the block</param>
        /// <param name="block"><see cref="Block"/> to be placed</param>
        public void SetBlock(int x, int y, int z, Block block, bool saveChunk = false)
        {
            //*gets the chunk for the block to be placed in
            Chunk chunk = GetChunk(x, y, z);

            //*if the chunk is not null and the block trying to be replaced is replaceable, replace it
            if(chunk != null && chunk.blocks[x - chunk.chunkWorldPos.x, y - chunk.chunkWorldPos.y, z - chunk.chunkWorldPos.z].breakable)
            {

                chunk.SetBlock(x - chunk.chunkWorldPos.x, y - chunk.chunkWorldPos.y, z - chunk.chunkWorldPos.z, block);
                chunk.update = true;

                //*updates the nebouring chunks as when a block is broken it may be in the edje of the chunk so their meshes also need to be updated
                //*only updates chunks that need to be updated as not every chunk will need to be and sometines none of them will need to be
                
                //*checks if the block chaged is in the edge if the x value for the chunk
                UpdateIfEqual(x - chunk.chunkWorldPos.x, 0, new ChunkWorldPos(x - 1, y, z));
                UpdateIfEqual(x - chunk.chunkWorldPos.x, Chunk.chunkSize - 1, new ChunkWorldPos(x + 1, y, z));

                //*checks if the block chaged is in the edge if the y value for the chunk
                UpdateIfEqual(y - chunk.chunkWorldPos.y, 0, new ChunkWorldPos(x, y - 1, z));
                UpdateIfEqual(y - chunk.chunkWorldPos.y, Chunk.chunkSize - 1, new ChunkWorldPos(x, y + 1, z));

                //*checks if the block chaged is in the edge if the z value for the chunk
                UpdateIfEqual(z - chunk.chunkWorldPos.z, 0, new ChunkWorldPos(x, y, z - 1));
                UpdateIfEqual(z - chunk.chunkWorldPos.z, Chunk.chunkSize - 1, new ChunkWorldPos(x, y, z + 1));

                if (saveChunk)
                    Serialization.Serialization.SaveChunk(chunk);
            }
        }
        #endregion
        #endregion

        #region Get Things
        /// <summary>
        /// Gets a chunk at eh given x, y, z
        /// </summary>
        /// <param name="x">X pos of the chunk</param>
        /// <param name="y">Y pos of the chunk</param>
        /// <param name="z">Z pos of the chunk</param>
        /// <returns><see cref="Chunk"/> at given x, y, z</returns>
        public Chunk GetChunk(int x, int y, int z)
        {
            float multiple = Chunk.chunkSize;
            //* rounds the given x, y, z to a multiple of 16 as chunks are 16x16x16 in size
            ChunkWorldPos pos = new ChunkWorldPos()
            {
                x = Mathf.FloorToInt(x / multiple) * Chunk.chunkSize,
                y = Mathf.FloorToInt(y / multiple) * Chunk.chunkSize,
                z = Mathf.FloorToInt(z / multiple) * Chunk.chunkSize
            };
            
            //* gets the chunk if it exists
            chunks.TryGetValue(pos, out Chunk chunk);
            //* if the chunk does not exist will return null
            return chunk;
        }
        
        /// <summary>
        /// Gets a <see cref="Block"/> at the given position
        /// </summary>
        /// <param name="x">X pos of the block</param>
        /// <param name="y">Y pos of the block</param>
        /// <param name="z">Z pos of the block</param>
        /// <returns><see cref="Block"/> at given x, y, z position</returns>
        public Block GetBlock(int x, int y, int z)
        {
            //* gets the chunk that the block is in
            Chunk chunk = GetChunk(x, y, z);

            if(chunk != null)
            {
                //* gets the block in the chunk
                return chunk.GetBlock(x - chunk.chunkWorldPos.x, y - chunk.chunkWorldPos.y, z - chunk.chunkWorldPos.z) ?? new Air();
            }

            //* returns an empty block is the chunk was not found
            return new Air();
        }
        #endregion
        
        /// <summary>
        /// Updates a chunk if <paramref name="value1"/> and <paramref name="value2"/> are equal
        /// </summary>
        /// <param name="value1">First value to check</param>
        /// <param name="value2">Second value to check</param>
        /// <param name="pos">Position of chunk to update if values are equal</param>
        void UpdateIfEqual(int value1, int value2, ChunkWorldPos pos)
        {
            if(value1 == value2)
            {
                Chunk chunk = GetChunk(pos.x, pos.y, pos.z);

                if (chunk != null)
                    chunk.update = true;
            }
        }
    }
}
