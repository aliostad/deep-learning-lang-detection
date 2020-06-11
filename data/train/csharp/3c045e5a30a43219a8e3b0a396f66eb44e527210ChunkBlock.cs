#region Using

using System;
using Libra;

#endregion

namespace Noctua.Models
{
    /// <summary>
    /// チャンクを跨いだ隣接ブロック探索を支援する構造体です。
    /// </summary>
    public struct ChunkBlock
    {
        Chunk chunk;

        IntVector3 position;

        public Chunk Chunk
        {
            get { return chunk; }
        }

        public IntVector3 Position
        {
            get { return position; }
        }

        public ChunkBlock(Chunk chunk, IntVector3 position)
        {
            if (chunk == null) throw new ArgumentNullException("chunk");
            if (!chunk.Contains(position)) throw new ArgumentOutOfRangeException("position");

            this.chunk = chunk;
            this.position = position;
        }

        public ChunkBlock GetNeighbor(Side side)
        {
            if (chunk == null)
                throw new InvalidOperationException("Chunk is null.");

            ChunkBlock neighbor;

            neighbor.chunk = chunk;
            neighbor.position = position + side.Direction;

            if (!neighbor.chunk.Contains(neighbor.position))
            {
                neighbor.chunk = chunk.GetNeighborChunk(side);
                neighbor.position += chunk.Size * side.Reverse().Direction;
            }

            return neighbor;
        }

        public byte? GetBlockIndex()
        {
            if (chunk == null)
                return null;

            return chunk.GetBlockIndex(position);
        }
    }
}
