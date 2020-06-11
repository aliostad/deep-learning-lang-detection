using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
namespace Client
{
    public sealed partial class World
    {
        public readonly int Length;
        public readonly int Width;
        public readonly int Height;
        private Chunk[, ,] Chunks;
        public BlockID this[Vector3I pos]
        {
            get { return this[pos.X, pos.Y, pos.Z]; }
            set { this[pos.X, pos.Y, pos.Z] = value; }
        }
        public BlockID this[int x, int y, int z]
        {
            get
            {
                // Determine what chunk holds this block.
                int chunkX = x / Chunk.Size.X;
                int chunkY = y / Chunk.Size.Y;
                int chunkZ = z / Chunk.Size.Z;

                // Check bounds
                if (chunkX < 0 || chunkX >= Chunks.GetLength(0)
                    || chunkY < 0 || chunkY >= Chunks.GetLength(1)
                    || chunkZ < 0 || chunkZ >= Chunks.GetLength(2))
                    return BlockID.None; // Chunk outside of bounds.

                Chunk chunk = Chunks[chunkX, chunkY, chunkZ];
                // This figures out the coordinate of the block relative to chunk.
                int levelX = x % Chunk.Size.X;
                int levelY = y % Chunk.Size.Y;
                int levelZ = z % Chunk.Size.Z;
                return chunk[levelX, levelY, levelZ];
            }
            set
            {
                if (!InBounds(x, y, z)) // Not within world bounds.
                    return;
                // first calculate which chunk we are talking about:
                int chunkX = (x / Chunk.Size.X);
                int chunkY = (y / Chunk.Size.Y);
                int chunkZ = (z / Chunk.Size.Z);

                // cannot modify chunks that are not within the visible area
                if (chunkX < 0 || chunkX > Chunks.GetLength(0))
                    throw new Exception("Cannot modify world outside visible area");
                if (chunkY < 0 || chunkY > Chunks.GetLength(1))
                    throw new Exception("Cannot modify world outside visible area");
                if (chunkZ < 0 || chunkZ > Chunks.GetLength(2))
                    throw new Exception("Cannot modify world outside visible area");
                Chunk chunk = Chunks[chunkX, chunkY, chunkZ];

                // this figures out the coordinate of the block relative to
                // chunk origin.
                int lx = x % Chunk.Size.X;
                int ly = y % Chunk.Size.Y;
                int lz = z % Chunk.Size.Z;

                chunk[lx, ly, lz] = value;
            }
        }
        public World(int length, int width, int height)
        {
            Length = length;
            Width = width;
            Height = height;

            Chunks = new Chunk[Length / Chunk.Size.X, Width / Chunk.Size.Y, Height / Chunk.Size.Z];
            for (int x = 0; x < Chunks.GetLength(0); x++)
                for (int y = 0; y < Chunks.GetLength(1); y++)
                    for (int z = 0; z < Chunks.GetLength(2); z++)
                    {
                        Chunks[x, y, z] = new Chunk(this, new Vector3I(x * Chunk.Size.X, y * Chunk.Size.Y, z * Chunk.Size.Z));
                        //Chunks[x, y, z].CreateMesh();
                    }
            
            Spawn = new Vector3I(Length / 2 + 5, Width / 2 + 5, 5);

            Client.OnUpdate += Update;
            Client.OnDraw3D += Draw;
        }
        public Vector3I Spawn
        {
            get;
            private set;
        }
        public void Update(object sender, UpdateEventArgs e)
        {
            for (int x = 0; x < Chunks.GetLength(0); x++)
                for (int y = 0; y < Chunks.GetLength(1); y++)
                    for (int z = 0; z < Chunks.GetLength(2); z++)
                            Chunks[x, y, z].Update();
        }
        public bool InBounds(Vector3I pos)
        {
            return InBounds(pos.X, pos.Y, pos.Z);
        }
        public bool InBounds(int x, int y, int z)
        {
            bool checkX = x < 0 || x >= Length;
            bool checkY = y < 0 || y >= Width;
            bool checkZ = z < 0 || z >= Height;
            return !(checkX || checkY || checkZ);
        }
    }
}
