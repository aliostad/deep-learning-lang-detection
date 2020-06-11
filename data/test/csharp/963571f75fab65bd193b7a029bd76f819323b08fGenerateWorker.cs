using UnityEngine;

using Voxels.Util;
using Voxels.Universe;
using Voxels.Universe.Chunks;
using Voxels.Universe.Blocks;

namespace Voxels.Workers {

    class GenerateWorker : Worker {

        private Chunk chunk;
        private World world;

        public GenerateWorker(Chunk target, World world) {
            chunk = target;
            chunk.Working = true;

            this.world = world;
        }

        public override void Process() {
            var generator = new Noise(world.Seed);

            for (int x = 0; x < Configuration.ChunkBlocks.x; x++) {
                for (int z = 0; z < Configuration.ChunkBlocks.z; z++) {
                    for (int y = 0; y < Configuration.ChunkBlocks.y; y++) {

                        float blockX = chunk.WorldPosition.x + (x * Configuration.BlockSize);
                        float blockZ = chunk.WorldPosition.z + (z * Configuration.BlockSize);
                        float blockY = chunk.WorldPosition.y + (y * Configuration.BlockSize);

                        var noise = (generator.Generate(blockX / 79f, 0, blockZ / 79f) + 1f) * 0.37f;
                        var limit = Mathf.Lerp(0, 64, noise);

                        if (blockY <= limit) {
                            chunk.SetBlock(x, y, z, BlockType.DIRT);

                            if (chunk.ChunkType == ChunkType.EMPTY)
                                chunk.ChunkType = ChunkType.FULL;

                        } else {

                            if (chunk.ChunkType == ChunkType.FULL)
                                chunk.ChunkType = ChunkType.MIXED;

                        }
                    }
                }
            }

            chunk.ChunkState = ChunkState.GENERATED;
            chunk.Working = false;
            chunk.Attach();
        }

    }

}