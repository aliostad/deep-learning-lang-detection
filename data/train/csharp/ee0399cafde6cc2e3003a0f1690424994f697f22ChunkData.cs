using System;
using MiNET.Worlds;

namespace MiNETDevToolsPlugin.Models
{

    [Serializable]
    public class ChunkData
    {
        public int X { get; set; }
        public int Z { get; set; }

        public ChunkColumnInfo[] ColumnInfo { get; set; }

        internal static ChunkData FromChunk(ChunkColumn chunk)
        {
            var columnInfo = new ChunkColumnInfo[16*16];

            for (int z = 0; z < 16; z++)
            {
                for (int x = 0; x < 16; x++)
                {
                    var info = new ChunkColumnInfo
                    {
                        X = x,
                        Z = z,
                        BiomeId = chunk.GetBiome(x, z),
                        Height = GetHeightFix(chunk, x, z)
                    };


                    columnInfo[z * 16 + x] = info;
                }
            }

            return new ChunkData()
            {
                X = chunk.x,
                Z = chunk.z,
                ColumnInfo = columnInfo
            };
        }

        private static byte GetHeightFix(ChunkColumn chunk, int x, int z)
        {
            for (byte y = 255; y > 0; y--)
            {
                if (chunk.GetBlock(x, y, z) > 0)
                {
                    return y;
                }
            }
            return 1;
        }

    }
}
