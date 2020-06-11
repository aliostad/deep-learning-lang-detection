using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Trix
{
    public static class Constants
    {
        public const int GRID_SIZE = 8;
        public const int CHUNK_SIZE = 16;
        public const int CHUNK_SIZE2 = CHUNK_SIZE * CHUNK_SIZE;
        public const int CHUNK_SIZE3 = CHUNK_SIZE * CHUNK_SIZE * CHUNK_SIZE;
        public const int CHUNK_HEIGHT = 128;
        public const int CHUNKS_PER_COLUMN = CHUNK_HEIGHT / CHUNK_SIZE;

        public const int worldSize = GRID_SIZE * CHUNK_SIZE;

    }
}
