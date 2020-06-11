using Cubix.world;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;

namespace Assets.Scripts.world {
    public class ChunkCache : IBlockAccess {

        private int chunkX;
        private int chunkZ;
        private Chunk[,] chunkArray;
        private World world;
        private bool empty;
        private bool visible = false;

        public ChunkCache(World world, int posX, int posY, int posZ, int posXPlus, int posYPlus, int posZPlus, int plus) {
		    this.world = world;
		    this.chunkX = posX - plus >> 4;
            this.chunkZ = posZ - plus >> 4;
            int var1 = posXPlus + plus >> 4;
            int var2 = posZPlus + plus >> 4;
            this.chunkArray = new Chunk[var1 - this.chunkX + 1, var2 - this.chunkZ + 1];
            this.empty = true;
            int chunkX;
            int chunkZ;
            Chunk chunk;
        
            for(chunkX = this.chunkX; chunkX <= var1; ++chunkX) {
        	    for(chunkZ = this.chunkZ; chunkZ <= var2; ++chunkZ) {
        		    chunk = this.world.getChunkFromChunkCoords(chunkX, chunkZ);
        		    if(chunk != null) {
        			    this.chunkArray[chunkX - this.chunkX, chunkZ - this.chunkZ] = chunk;
        		    }
        	    }
            }
        
            for(chunkX = posX >> 4; chunkX <= posXPlus >> 4; ++chunkX) {
        	    for(chunkZ = posZ >> 4; chunkZ <= posZPlus >> 4; ++chunkZ) {
        		    chunk = this.chunkArray[chunkX - this.chunkX, chunkZ - this.chunkZ];
        		    if(chunk != null && !chunk.getAreLevelsEmpty(posY, posYPlus)) {
                        this.empty = false;
        		    }
        	    }
            }


            chunkX = (posX + 1) >> 4;
            chunkZ = (posZ + 1) >> 4;
            for (int testChunkX = 0; testChunkX <= 2; ++testChunkX) {
                for (int testChunkZ = 0; testChunkZ <= 2; ++testChunkZ) {
                    int var3 = chunkX + (testChunkX - 1);
                    int var4 = chunkZ + (testChunkZ - 1);
                    if (var3 == 0 && var4 == 0) {
                        int testChunkY = (posY + 1) - 16;
                        chunk = this.world.getChunkFromChunkCoords(var3, var4);
                        if (chunk.getAreLevelsFilled(testChunkY, posYPlus - 1)) {
                            this.visible = true;
                        }

                        testChunkY = (posY + 1) + 16;
                        chunk = this.world.getChunkFromChunkCoords(var3, var4);
                        if (chunk.getAreLevelsFilled(posY + 1, testChunkY)) {
                            this.visible = true;
                        }
                    } else {
                        chunk = this.world.getChunkFromChunkCoords(var3, var4);
                        if (!chunk.getAreLevelsFilled(posY + 1, posYPlus - 1)) {
                            this.visible = true;
                        }
                    }
                }
            }
	    }


        public int getBlockID(int x, int y, int z) {
            if (y < 0) {
                return 0;
            } else if (y >= 256) {
                return 0;
            } else {
                int var4 = (x >> 4) - this.chunkX;
                int var5 = (z >> 4) - this.chunkZ;
                if (var4 >= 0 && var4 < this.chunkArray.Length && var5 >= 0) {
                    Chunk var6 = this.chunkArray[var4, var5];
                    return var6 == null ? 0 : var6.getBlock(x & 15, y, z & 15);
                } else {
                    return 0;
                }
            }
        }

        public bool isVisible() {
            return this.visible;
        }

        public bool isEmpty() {
            return this.empty;
        }

    }
}
