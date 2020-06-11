namespace Survive.World {

    class ChunkManager {
        
        private static float[,,] noisecache = new float[WorldChunk.Size, WorldChunk.Size + 1, WorldChunk.Size];

        public static WorldChunk GetChunk(int x, int y, int z, FastNoise fn) {
            WorldChunk chunk = new WorldChunk();
            

            for(int bx = 0; bx < WorldChunk.Size; bx++) {
                for(int by = 0; by < WorldChunk.Size + 1; by++) {
                    for(int bz = 0; bz < WorldChunk.Size; bz++) {
                        noisecache[bx, by, bz] = 0.5f - ((float)(y * WorldChunk.Size + by) / 40) + fn.GetSimplexFractal(x * WorldChunk.Size + bx, y * WorldChunk.Size + by, z * WorldChunk.Size + bz);
                    }
                }
            }

            for(int bx = 0; bx < WorldChunk.Size; bx++) {
                for(int by = 0; by < WorldChunk.Size; by++) {
                    for(int bz = 0; bz < WorldChunk.Size; bz++) {
                        chunk.SetBlockDirect(bx, by, bz, noisecache[bx, by + 1, bz] > 0 ? Blocks.Stone : noisecache[bx, by, bz] > 0 ? Blocks.Grass : Blocks.Air);
                    }
                }
            }
            
            return chunk;
        }

    }

}
