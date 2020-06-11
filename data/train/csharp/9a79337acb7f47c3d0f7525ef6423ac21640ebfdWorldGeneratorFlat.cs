using UnityEngine;
using VoxelEngine.Blocks;
using VoxelEngine.ChunkLoaders;
using VoxelEngine.Entities;
using VoxelEngine.Generation.Island.Feature;
using VoxelEngine.Level;

namespace VoxelEngine.Generation {

    public class WorldGeneratorFlat : WorldGeneratorBase {

        private FeatureTreeBasic tree;

        public WorldGeneratorFlat(World world, int seed) : base(world, seed) {
            this.tree = new FeatureTreeBasic();
        }

        public override Vector3 getSpawnPoint(World world) {
            return new Vector3(7.5f, 25, 7.5f);
        }

        public override void generateChunk(Chunk chunk) {
            for (int x = 0; x < Chunk.SIZE; x++) {
                for (int z = 0; z < Chunk.SIZE; z++) {
                    for (int y = 0; y < Chunk.SIZE; y++) {
                        chunk.setBlock(x, y, z, this.getBlockForHeight(y + chunk.worldPos.y));
                    }
                }
            }
        }

        public override ChunkLoaderBase getChunkLoader(EntityPlayer player) {
            return new ChunkLoaderInfinite(player.world, player);
        }

        public override void populateChunk(Chunk chunk) {
            if(chunk.chunkPos.x == 0 && chunk.chunkPos.z == 0 && chunk.chunkPos.y == 1) {
                this.column(chunk, 2, 2);
                this.column(chunk, 2, 13);
                this.column(chunk, 13, 2);
                this.column(chunk, 13, 13);
            } else {
                this.tree.generate(chunk, new System.Random(seed ^ chunk.chunkPos.GetHashCode()));
            }
        }

        private void column(Chunk chunk, int x, int z) {
            chunk.setBlock(x, 4, z, Block.cobblestone);
            chunk.setBlock(x, 5, z, Block.lanternOn);
            chunk.setBlock(x, 6, z, Block.cobblestoneSlab);
            chunk.setMeta(x, 6, z, 5);
        }

        private Block getBlockForHeight(int y) {
            if (y < 16) {
                return Block.stone;
            } else if (y < 18) {
                return Block.dirt;
            } else if (y < 19) {
                return Block.grass;
            } else {
                return Block.air;
            }
        }
    }
}
