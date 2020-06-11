using VoxelEngine.Blocks;
using VoxelEngine.Level;

namespace VoxelEngine.Util {

    public class CachedChunk3x3 {

        private static CachedChunk3x3 region;

        private Chunk[] chunks;

        private CachedChunk3x3() {
            this.chunks = new Chunk[27];
        }

        public static CachedChunk3x3 getNewRegion(World world, Chunk chunk) {
            if(region == null) {
                region = new CachedChunk3x3();
            }

            Chunk c;
            int x1 = chunk.chunkPos.x;
            int y1 = chunk.chunkPos.y;
            int z1 = chunk.chunkPos.z; 
            for(int x = -1; x <= 1; x++) {
                for (int y = -1; y <= 1; y++) {
                    for (int z = -1; z <= 1; z++) {
                        //if(x != 0 && y != 0 && z != 0) { // Don't lookup middle chunk.
                            c = world.getChunk(new ChunkPos(x + x1, y + y1, z + z1));
                            region.chunks[((y + 1) * 3 * 3) + ((z + 1) * 3) + (x + 1)] = c;
                        //}
                    }
                }
            }

            return region;
        }

        /// <summary>
        /// Returns true is all the adjacent chunks are loaded.
        /// </summary>
        public bool allChunksLoaded() {
            for(int i = 0; i < this.chunks.Length; i++) {
                //if (i != 13) { // Don't lookup middle chunk.
                    if(chunks[i] == null) {
                        return false;
                    }
                //}
            }
            return true;
        }
        
        /// <summary>
        /// Gets a block from the region.  NOTE!  Coords are 0-15 to use the middle chunk,
        /// with negative and position to get the surrounding ones.  0, -2, 0 would get the
        /// chunk down from the middle/orgin chunk.
        /// </summary>
        public Block getBlock(int x, int y, int z) {
            int localX = x + (x < 0 ? Chunk.SIZE : x >= Chunk.SIZE ? -Chunk.SIZE : 0);
            int localY = y + (y < 0 ? Chunk.SIZE : y >= Chunk.SIZE ? -Chunk.SIZE : 0);
            int localZ = z + (z < 0 ? Chunk.SIZE : z >= Chunk.SIZE ? -Chunk.SIZE : 0);
            return this.getChunk(x, y, z).getBlock(localX, localY, localZ);
        }

        private Chunk c;

        public void setBlock(int x, int y, int z, Block block, int meta = -1) {
            int localX = x + (x < 0 ? Chunk.SIZE : x >= Chunk.SIZE ? -Chunk.SIZE : 0);
            int localY = y + (y < 0 ? Chunk.SIZE : y >= Chunk.SIZE ? -Chunk.SIZE : 0);
            int localZ = z + (z < 0 ? Chunk.SIZE : z >= Chunk.SIZE ? -Chunk.SIZE : 0);
            c = this.getChunk(x, y, z);
            c.setBlock(localX, localY, localZ, block);
            if(meta != -1) {
                c.setMeta(localX, localY, localZ, meta);
            }
        }

        public int getLight(int x, int y, int z) {
            int localX = x + (x < 0 ? Chunk.SIZE : x >= Chunk.SIZE ? -Chunk.SIZE : 0);
            int localY = y + (y < 0 ? Chunk.SIZE : y >= Chunk.SIZE ? -Chunk.SIZE : 0);
            int localZ = z + (z < 0 ? Chunk.SIZE : z >= Chunk.SIZE ? -Chunk.SIZE : 0);
            return this.getChunk(x, y, z).getLight(localX, localY, localZ);
        }

        /// <summary>
        /// Returns the correct chunk from local chunk coords.  If the coords are out of the orgin chunk, this returns an adjacent chunk.
        /// </summary>
        public Chunk getChunk(int x, int y, int z) {
            int xOffset = x >= Chunk.SIZE ? 1 : (x < 0 ? -1 : 0);
            int yOffset = y >= Chunk.SIZE ? 1 : (y < 0 ? -1 : 0);
            int zOffset = z >= Chunk.SIZE ? 1 : (z < 0 ? -1 : 0);

            return this.chunks[((yOffset + 1) * 3 * 3) + ((zOffset + 1) * 3) + (xOffset + 1)];
        }
    }
}
