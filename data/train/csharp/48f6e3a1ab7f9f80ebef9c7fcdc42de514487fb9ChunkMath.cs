using UnityEngine;

namespace MistRidge
{
    public static class ChunkMath
    {
        public static int Depth(ChunkRequest chunkRequest)
        {
            return Mathf.FloorToInt((3 + Mathf.Sqrt((12 * chunkRequest.chunkNum) - 3)) / 6);
        }

        public static int Side(ChunkRequest chunkRequest)
        {
            int depth = Depth(chunkRequest);
            return Mathf.CeilToInt((float)chunkRequest.chunkNum / depth) - (3 * depth) + 2;
        }

        public static int DepthStartChunkNum(ChunkRequest chunkRequest)
        {
            int depth = Depth(chunkRequest);
            return (3 * depth * (depth - 1)) + 1;
        }

        public static int DepthEndChunkNum(ChunkRequest chunkRequest)
        {
            int depth = Depth(chunkRequest);
            return 3 * depth * (depth + 1);
        }

        public static int SideStartChunkNum(ChunkRequest chunkRequest)
        {
            int depth = Depth(chunkRequest);
            int side = Side(chunkRequest);
            return DepthStartChunkNum(chunkRequest) + (depth * side);
        }

        public static int SideChunkNum(ChunkRequest chunkRequest)
        {
            return chunkRequest.chunkNum - SideStartChunkNum(chunkRequest);
        }
    }
}
