using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Assets.Scripts.Internal
{
    public struct ChunkVector
    {
        public byte x;
        public byte y;
        public byte z;

        public ChunkVector(byte x, byte y, byte z)
        {
            this.x = x;
            this.y = y;
            this.z = z;
        }
        public ChunkVector(int x, int y, int z)
        {
            this.x = (byte)x;
            this.y = (byte)y;
            this.z = (byte)z;
        }

        public ChunkVector Above
        {
            get
            {
                return new ChunkVector(x, y < 15 ? y + 1 : 15, z);
            }
        }
        public ChunkVector Below
        {
            get
            {
                return new ChunkVector(x, y == 0 ? 0 : y - 1, z);
            }
        }
        public ChunkVector Left
        {
            get
            {
                return new ChunkVector(x - 1, y, z);
            }
        }
        public ChunkVector Right
        {
            get
            {
                return new ChunkVector(x + 1, y, z);
            }
        }
        public ChunkVector Front
        {
            get
            {
                return new ChunkVector(x, y, z + 1);
            }
        }
        public ChunkVector Behind
        {
            get
            {
                return new ChunkVector(x, y, z - 1);
            }
        }
    }
}
