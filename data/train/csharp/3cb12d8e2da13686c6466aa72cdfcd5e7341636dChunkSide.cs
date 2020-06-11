using System.Collections.Generic;

using Voxels.Util;

namespace Voxels.Universe.Chunks {

    public class ChunkSide {

        private bool loaded = false;

        private Chunk chunk;
        private ChunkType chunkType;
        private ChunkProvider provider;

        private Dictionary<CubeFace, Chunk> chunks;
        private Dictionary<CubeFace, Position> positions;

        public ChunkSide(Chunk chunk, ChunkProvider provider) {
            this.chunk = chunk;
            this.provider = provider;

            chunks = new Dictionary<CubeFace, Chunk>() {
                { CubeFace.TOP,     null },
                { CubeFace.BOTTOM,  null },
                { CubeFace.FRONT,   null },
                { CubeFace.BACK,    null },
                { CubeFace.LEFT,    null },
                { CubeFace.RIGHT,   null },
            };

            positions = new Dictionary<CubeFace, Position>() {
                { CubeFace.TOP,     chunk.Position + Position.Up },
                { CubeFace.BOTTOM,  chunk.Position + Position.Down },
                { CubeFace.FRONT,   chunk.Position + Position.Forward },
                { CubeFace.BACK,    chunk.Position + Position.Back },
                { CubeFace.LEFT,    chunk.Position + Position.Left },
                { CubeFace.RIGHT,   chunk.Position + Position.Right },
            };

            chunkType = chunk.ChunkType;
        }

        public Chunk Fetch(CubeFace side) {
            return chunks[side];
        }

        public void Attach() {
            loaded = true;

            foreach (KeyValuePair<CubeFace, Position> keyValue in positions) {

                if (chunks[keyValue.Key] != null)
                    continue;

                Chunk side = provider.GetChunk(keyValue.Value);

                if (side != null && side.IsAvailable) {

                    // check the chunk fill type based on the side
                    if (chunkType != side.ChunkType)
                        chunkType = side.ChunkType;

                    // attach the side
                    chunks[keyValue.Key] = side;

                    // notify the other chunk
                    side.Attach();

                } else {
                    loaded = false;
                }

            }

            if (chunkType == ChunkType.MIXED)
                chunk.Dirty = true;

            if (loaded)
                chunk.ChunkState = ChunkState.ATTACHED;
        }

    }

}