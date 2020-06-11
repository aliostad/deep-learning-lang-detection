using Mentula.General;
using System.Diagnostics;

namespace Mentula.SurvivalGameServer
{

    public class ChunkData
    {
        public IntVector2 ChunkPos;
        public int ChunkType;

        public ChunkData()
        {
            ChunkPos = IntVector2.Zero;
            ChunkType = 0;
        }

        public ChunkData(IntVector2 chunkPos)
        {
            ChunkPos = chunkPos;
            ChunkType = 0;
        }

        public ChunkData(IntVector2 chunkPos,int chunkType)
        {
            ChunkPos = chunkPos;
            ChunkType = chunkType;
        }
    }
}