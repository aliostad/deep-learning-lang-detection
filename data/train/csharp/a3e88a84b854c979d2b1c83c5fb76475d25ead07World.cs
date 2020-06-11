using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OpenTK.Graphics.OpenGL;
using OpenTK;
using System.Threading;

namespace OpenTKTest
{
    public class World
    {
        Dictionary<Vector3i, Chunk> chunks = new Dictionary<Vector3i, Chunk>();
        Chunk c1 = new Chunk(), c2 = new Chunk();
        public World()
        {
            c1.GenerateTerrain(1);
            c2.GenerateTerrain(0);
            c1.GenerateBuffers();
            c2.GenerateBuffers();

            chunks[Vector3i.Zero] = c1;
            chunks[new Vector3i(1, 0, 0)] = c2;            
        }

        public void AddNewChunkAt(Vector3i location)
        {

        }

        public void DrawChunks(Matrix4 modelViewMatrix)
        {
            foreach (var kvp in chunks)
            {
                GL.LoadMatrix(ref modelViewMatrix);
                GL.Translate(kvp.Key.X * Chunk.CHUNK_SIZE_1D,
                    kvp.Key.Y * Chunk.CHUNK_SIZE_1D,
                    kvp.Key.Z * Chunk.CHUNK_SIZE_1D);
                kvp.Value.Draw();
            }
        }

        public void SetBlock(Vector3i location, BlockType type)
        {
            Chunk chunk = GetChunkContainingBlockCoordinates(this, location);
            if (chunk == null) return;
            Vector3i blockPositionWithinChunk = location % Chunk.CHUNK_SIZE_1D;
            chunk.setBlockTypeAt(blockPositionWithinChunk, type);
            chunk.GenerateBuffers();
        }

        public Block GetBlockAt(Vector3i location) // todo make alias to direct coords
        {
            Chunk chunk = GetChunkContainingBlockCoordinates(this, location);
            if (chunk == null) return null;
            Vector3i blockPositionWithinChunk = location % Chunk.CHUNK_SIZE_1D;
            return new Block(location, chunk.getBlockTypeAt(blockPositionWithinChunk));
        }

        public Chunk GetChunkContainingBlockCoordinates(Vector3i blockCoordinates)
        {
            Vector3i chunkPosition = new Vector3i(blockCoordinates.X < 0 ? blockCoordinates.X - Chunk.CHUNK_SIZE_1D : blockCoordinates.X, blockCoordinates.Y < 0 ? blockCoordinates.Y - Chunk.CHUNK_SIZE_1D : blockCoordinates.Y, blockCoordinates.Z < 0 ? blockCoordinates.Z - Chunk.CHUNK_SIZE_1D : blockCoordinates.Z) / Chunk.CHUNK_SIZE_1D;
            
            Chunk chunk;
            if (!chunks.TryGetValue(chunkPosition, out chunk))
            {
                return null;
            } 
            return chunk;
        }

        public static Chunk GetChunkContainingBlockCoordinates(World world, Vector3i blockCoordinates)
        {
            Vector3i chunkPosition = new Vector3i(blockCoordinates.X < 0 ? blockCoordinates.X - Chunk.CHUNK_SIZE_1D : blockCoordinates.X, blockCoordinates.Y < 0 ? blockCoordinates.Y - Chunk.CHUNK_SIZE_1D : blockCoordinates.Y, blockCoordinates.Z < 0 ? blockCoordinates.Z - Chunk.CHUNK_SIZE_1D : blockCoordinates.Z) / Chunk.CHUNK_SIZE_1D;
            
            Chunk chunk;
            if (!world.chunks.TryGetValue(chunkPosition, out chunk)) return null;
            return chunk;
        }
    }
}
