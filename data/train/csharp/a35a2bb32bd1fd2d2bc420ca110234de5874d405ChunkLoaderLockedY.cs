using System;
using VoxelEngine.Entities;
using VoxelEngine.Level;
using VoxelEngine.Util;

namespace VoxelEngine.ChunkLoaders {

    [Obsolete("May contain bugs!", true)]
    public class ChunkLoaderLockedY : ChunkLoaderBase {

        private int worldHeight = 4;

        public ChunkLoaderLockedY(World world, EntityPlayer player) : base(world, player, 2) {}

        protected override bool isOutOfBounds(ChunkPos occupiedChunkPos, Chunk chunk) {
            if (this.toFar(occupiedChunkPos.x, chunk.chunkPos.x) || this.toFar(occupiedChunkPos.z, chunk.chunkPos.z)) {
                return true;
            }
            return false;
        }

        protected override void loadYAxis(ChunkPos occupiedChunkPos, int x, int z, bool isReadOnly) {
            for (int y = 0; y < this.worldHeight; y++) {
                NewChunkInstructions instructions = new NewChunkInstructions(x + occupiedChunkPos.x, y + occupiedChunkPos.y, z + occupiedChunkPos.z, isReadOnly);
                Chunk chunk = world.getChunk(instructions.chunkPos);

                if (chunk == null) {
                    if(!this.buildQueue.Contains(instructions)) {
                        this.buildQueue.Enqueue(instructions);
                    }
                } else {
                    chunk.isReadOnly = isReadOnly;
                }
            }
        }
    }
}
