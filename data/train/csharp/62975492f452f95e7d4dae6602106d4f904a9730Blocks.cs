using Sean.Shared;
using System;

namespace Sean.WorldClient.Hosts.World
{
    /// <summary>
    /// Note that the data is stored as [Y,X,Z]. When we Buffer.BlockCopy, we want the data accessed Y-by-Y. This improves compression and results in a ~10% smaller world
    /// </summary>
    public struct Blocks
    {
        internal Blocks(int chunkSizeX, int chunkHeight, int chunkSizeZ)
        {
            Array = new ushort[chunkHeight, chunkSizeX, chunkSizeZ];
        }

        internal Block this[Coords coords]
        {
            get { return new Block(Array[coords.Yblock, coords.Xblock % Chunk.CHUNK_SIZE, coords.Zblock % Chunk.CHUNK_SIZE]); }
            set { Array[coords.Yblock, coords.Xblock % Chunk.CHUNK_SIZE, coords.Zblock % Chunk.CHUNK_SIZE] = value.BlockData; }
        }

        internal Block this[Position position]
        {
            get { return new Block(Array[position.Y, position.X % Chunk.CHUNK_SIZE, position.Z % Chunk.CHUNK_SIZE]); }
            set { Array[position.Y, position.X % Chunk.CHUNK_SIZE, position.Z % Chunk.CHUNK_SIZE] = value.BlockData; }
        }

        /// <summary>Get a block from the array.</summary>
        /// <param name="x">Chunk relative X.</param>
        /// <param name="y">Chunk relative Y.</param>
        /// <param name="z">Chunk relative Z.</param>
        internal Block this[int x, int y, int z]
        {
            get { return new Block(Array[y, x, z]); }
            set { Array[y, x, z] = value.BlockData; }
        }

        internal readonly ushort[, ,] Array;

        [Obsolete("This was for world diffs. Not being used currently.")]
        internal ushort[,,] DiffArray
        {
            get
            {
                var diffArray = new ushort[Chunk.CHUNK_HEIGHT,Chunk.CHUNK_SIZE,Chunk.CHUNK_SIZE];
                for (var y = 0; y < Chunk.CHUNK_HEIGHT; y++)
                {
                    for (var x = 0; x < Chunk.CHUNK_SIZE; x++)
                    {
                        for (var z = 0; z < Chunk.CHUNK_SIZE; z++)
                        {
                            //only copy the dirty blocks
                            if ((Array[y, x, z] & 0x8000) != 0) diffArray[y, x, z] = Array[y, x, z];
                        }
                    }
                }
                return diffArray;
            }
        }
    }
}
