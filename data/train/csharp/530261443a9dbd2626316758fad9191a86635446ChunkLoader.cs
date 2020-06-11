using System;
using System.Threading.Tasks;

namespace Generate.Content
{
    class ChunkLoader : IDisposable
    {
        internal static int ChunkCountSide = 10;
        internal static long MovedX = 0, MovedZ = 0;

        private int ChunkCountMaxKey;
        private int ChunkCount;
        private static Chunk[,] Chunks;

        internal Chunk Mid
        {
            get
            {
                return Chunks[ChunkCountSide, ChunkCountSide];
            }
        }

        internal ChunkLoader()
        {
            ChunkCountMaxKey = 2 * ChunkCountSide;
            ChunkCount = ChunkCountMaxKey + 1;
            Chunks = new Chunk[ChunkCount, ChunkCount];

            for (int X = 0; X < ChunkCount; X++)
            {
                for (int Z = 0; Z < ChunkCount; Z++)
                {
                    Chunks[X, Z] = new Chunk(X + MovedX - ChunkCountSide, Z + MovedZ - ChunkCountSide);
                }
            }
        }

        internal void RenderVisible()
        {
            for (int X = 0; X < ChunkCount; X++)
            {
                for (int Z = 0; Z < ChunkCount; Z++)
                {
                    Chunks[X, Z].Render(X - ChunkCountSide, Z - ChunkCountSide);
                }
            }
        }

        internal void UpX()
        {
            MovedX++;
            Parallel.For(0, ChunkCount, Z =>
            {
                Chunks[0, Z].Dispose();
                for (int X = 0; X < ChunkCountMaxKey; X++)
                {
                    Chunks[X, Z] = Chunks[X + 1, Z];
                }

                Chunks[ChunkCount - 1, Z] = new Chunk(ChunkCountSide + MovedX, Z + MovedZ - ChunkCountSide);
            });
        }

        internal void DownX()
        {
            MovedX--;
            Parallel.For(0, ChunkCount, Z =>
            {
                Chunks[ChunkCountMaxKey, Z].Dispose();
                for (int X = ChunkCount - 1; X > 0; X--)
                {
                    Chunks[X, Z] = Chunks[X - 1, Z];
                }

                Chunks[0, Z] = new Chunk(MovedX - ChunkCountSide, Z + MovedZ - ChunkCountSide);
            });
        }

        internal void UpZ()
        {
            MovedZ++;
            Parallel.For(0, ChunkCount, X =>
            {
                Chunks[X, 0].Dispose();
                for (int Z = 0; Z < ChunkCountMaxKey; Z++)
                {
                    Chunks[X, Z] = Chunks[X, Z + 1];
                }

                Chunks[X, ChunkCount - 1] = new Chunk(X + MovedX - ChunkCountSide, ChunkCountSide + MovedZ);
            });
        }

        internal void DownZ()
        {
            MovedZ--;
            Parallel.For(0, ChunkCount, X =>
            {
                Chunks[X, ChunkCountMaxKey].Dispose();
                for (int Z = ChunkCountMaxKey; Z > 0; Z--)
                {
                    Chunks[X, Z] = Chunks[X, Z - 1];
                }

                Chunks[X, 0] = new Chunk(X + MovedX - ChunkCountSide, MovedZ - ChunkCountSide);
            });
        }

        public void Dispose()
        {
            foreach (var Chunk in Chunks)
            {
                Chunk.Dispose();
            }

            Model.ModelsToLoad.Clear();
        }
    }
}
