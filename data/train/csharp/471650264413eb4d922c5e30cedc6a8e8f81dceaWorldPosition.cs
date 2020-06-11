using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Xna.Framework;
using Voxelist.Utilities;

namespace Voxelist.Utilities
{
    public struct WorldPosition
    {
        public int chunkX;
        public int chunkZ;

        public float inChunkX;
        public float inChunkY;
        public float inChunkZ;

        public Vector3 InChunkPosition
        {
            get { return new Vector3(inChunkX, inChunkY, inChunkZ); }
            set
            {
                inChunkX = value.X;
                inChunkY = value.Y;
                inChunkZ = value.Z;

                fixChunking();
            }
        }

        public ChunkCoordinate ChunkCoordinate
        {
            get { return new ChunkCoordinate(chunkX, chunkZ); }
            set
            {
                chunkX = value.X;
                chunkZ = value.Z;
            }
        }

        public static WorldPosition operator +(WorldPosition wp, Vector3 position)
        {
            return new WorldPosition(wp.chunkX, wp.chunkZ, wp.inChunkX + position.X, wp.inChunkY + position.Y, wp.inChunkZ + position.Z);
        }

        public static Vector3 operator -(WorldPosition a, WorldPosition b)
        {
            Vector3 change = a.InChunkPosition - b.InChunkPosition;
            change.X += GameConstants.CHUNK_X_WIDTH * (a.chunkX - b.chunkX);
            change.Z += GameConstants.CHUNK_Z_LENGTH * (a.chunkZ - b.chunkZ);

            return change;
        }

        public WorldPosition(int chunkX, int chunkZ, float inChunkX, float inChunkY, float inChunkZ)
        {
            this.chunkX = chunkX;
            this.chunkZ = chunkZ;

            this.inChunkX = inChunkX;
            this.inChunkY = inChunkY;
            this.inChunkZ = inChunkZ;

            fixChunking();
        }

        private void fixChunking()
        {
            while (inChunkX < 0)
            {
                chunkX--;
                inChunkX += GameConstants.CHUNK_X_WIDTH;
            }

            while (inChunkX >= GameConstants.CHUNK_X_WIDTH)
            {
                chunkX++;
                inChunkX -= GameConstants.CHUNK_X_WIDTH;
            }

            while (inChunkZ < 0)
            {
                chunkZ--;
                inChunkZ += GameConstants.CHUNK_Z_LENGTH;
            }

            while (inChunkZ >= GameConstants.CHUNK_Z_LENGTH)
            {
                chunkZ++;
                inChunkZ -= GameConstants.CHUNK_Z_LENGTH;
            }
        }

        public override String ToString()
        {
            return "Chunk: (" + chunkX.ToString() + "," + chunkZ.ToString() +
                ")\nPosition: (" + inChunkX.ToString() + "," + inChunkY.ToString() + "," + inChunkZ.ToString() + ")";
        }

        /*
        public Vector3 DrawPosition()
        {
            return new Vector3(
                inChunkX + GameConstants.CHUNK_X_WIDTH * (chunkX - Camera.ChunkX),
                inChunkY,
                inChunkZ + GameConstants.CHUNK_Z_LENGTH * (chunkZ - Camera.ChunkZ)
                );
        }*/
    }
}
