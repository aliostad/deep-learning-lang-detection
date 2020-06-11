// ----------------------------------------------------------------------------
// <copyright file="TerrainChunk.cs" company="Acidwashed Games">
//     Copyright 2012 Acidwashed Games. All right reserved.
// </copyright>
// ----------------------------------------------------------------------------
namespace Dwarves.Core.Terrain
{
    using Dwarves.Core.Math;

    /// <summary>
    /// A terrain chunk.
    /// </summary>
    public class TerrainChunk
    {
        /// <summary>
        /// Initialises a new instance of the TerrainChunk class.
        /// </summary>
        /// <param name="chunkIndex">The chunk index.</param>
        public TerrainChunk(Vector2I chunkIndex)
        {
            this.Index = chunkIndex;
            this.Points = new TerrainPoint[Metrics.ChunkWidth, Metrics.ChunkHeight];
            this.Mesh = new TerrainChunkMesh();

            // Initialise the points
            for (int x = 0; x < Metrics.ChunkWidth; x++)
            {
                for (int y = 0; y < Metrics.ChunkHeight; y++)
                {
                    this.Points[x, y] = new TerrainPoint();
                }
            }
        }

        /// <summary>
        /// Gets the chunk index.
        /// </summary>
        public Vector2I Index { get; private set; }

        /// <summary>
        /// Gets the points in the chunk.
        /// </summary>
        public TerrainPoint[,] Points { get; private set; }

        /// <summary>
        /// Gets the surface position relative to this chunk.
        /// </summary>
        public SurfacePosition SurfacePosition { get; internal set; }

        /// <summary>
        /// Gets the mesh.
        /// </summary>
        public TerrainChunkMesh Mesh { get; private set; }

        /// <summary>
        /// Gets the chunk indices of the given chunk and its 8 neighbours.
        /// </summary>
        /// <param name="chunk">The chunk.</param>
        /// <returns>The chunk index and its neighbours.</returns>
        public static Vector2I[] GetNeighboursIncluding(Vector2I chunk)
        {
            return new Vector2I[]
                {
                    chunk,
                    new Vector2I(chunk.X + 1, chunk.Y),
                    new Vector2I(chunk.X + 1, chunk.Y + 1),
                    new Vector2I(chunk.X, chunk.Y + 1),
                    new Vector2I(chunk.X - 1, chunk.Y + 1),
                    new Vector2I(chunk.X - 1, chunk.Y),
                    new Vector2I(chunk.X - 1, chunk.Y - 1),
                    new Vector2I(chunk.X, chunk.Y - 1),
                    new Vector2I(chunk.X + 1, chunk.Y - 1)
                };
        }

        /// <summary>
        /// Gets the 8 neighbours.
        /// </summary>
        /// <param name="chunk">The chunk.</param>
        /// <returns>The chunk neighbours.</returns>
        public static Vector2I[] GetNeighboursExcluding(Vector2I chunk)
        {
            return new Vector2I[]
                {
                    new Vector2I(chunk.X + 1, chunk.Y),
                    new Vector2I(chunk.X + 1, chunk.Y + 1),
                    new Vector2I(chunk.X, chunk.Y + 1),
                    new Vector2I(chunk.X - 1, chunk.Y + 1),
                    new Vector2I(chunk.X - 1, chunk.Y),
                    new Vector2I(chunk.X - 1, chunk.Y - 1),
                    new Vector2I(chunk.X, chunk.Y - 1),
                    new Vector2I(chunk.X + 1, chunk.Y - 1)
                };
        }

        /// <summary>
        /// Gets the chunk indices within the given bounds.
        /// </summary>
        /// <param name="bounds">The bounds.</param>
        /// <returns>The chunk indices.</returns>
        public static Vector2I[] GetChunks(RectangleI bounds)
        {
            var chunks = new Vector2I[bounds.Width * bounds.Height];

            int i = 0;
            for (int x = bounds.X; x < bounds.X + bounds.Width; x++)
            {
                for (int y = bounds.Y; y > bounds.Y - bounds.Height; y--)
                {
                    chunks[i++] = new Vector2I(x, y);
                }
            }

            return chunks;
        }

        /// <summary>
        /// Gets the point at the given chunk position.
        /// </summary>
        /// <param name="pos">The chunk position.</param>
        /// <returns>The point.</returns>
        public TerrainPoint GetPoint(Vector3I pos)
        {
            return this.Points[pos.X, pos.Y];
        }

        /// <summary>
        /// Gets the density at the given chunk position.
        /// </summary>
        /// <param name="pos">The chunk position.</param>
        /// <returns>The density.</returns>
        public byte GetDensity(Vector3I pos)
        {
            TerrainPoint point = this.Points[pos.X, pos.Y];
            if (point != null)
            {
                return point.GetDensity(pos.Z);
            }
            else
            {
                return TerrainPoint.DensityMax;
            }
        }
    }
}