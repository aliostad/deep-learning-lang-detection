using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;

namespace Routecraft.Minecraft
{
    public class Dimension
    {
        private World World;
        public DimensionType Type { get; private set; }

        public string Path { get; private set; }

        private Region[,] Regions = new Region[1024, 1024];

        private Dictionary<Vector2I, Chunk> LoadedChunkMap = new Dictionary<Vector2I, Chunk>();

        public Dimension(World world, DimensionType type)
        {
            this.World = world;
            this.Type = type;

            switch (this.Type)
            {
                case DimensionType.Normal:
                    this.Path = this.World.Path;
                    break;
                case DimensionType.Nether:
                    this.Path = this.World.Path + "\\DIM-1";
                    break;
                case DimensionType.End:
                    this.Path = this.World.Path + "\\DIM1";
                    break;
            }
        }

        #region Serialization
        /// <summary>
        /// Saves any loaded regions.
        /// </summary>
        public void Save()
        {
            for (int y = 0; y < 1024; y++)
            {
                for (int x = 0; x < 1024; x++)
                {
                    if (this.Regions[y, x] != null)
                    {
                        this.Regions[y, x].Save();
                    }
                }
            }

            Debug.WriteLine("Dimension " + this.Type.ToString() + " saved.");
        }
        #endregion

        #region Regions
        private Region GetRegion(Vector2I regionPos)
        {
            Vector2I indexedPos = regionPos + new Vector2I(512, 512);
            if (this.Regions[indexedPos.y, indexedPos.x] == null)
            {
                Region Region = new Region(this.World, this, regionPos);
                this.Regions[indexedPos.y, indexedPos.x] = Region;
            }
            return this.Regions[indexedPos.y, indexedPos.x];
        }

        public bool IsRegionLoaded(Vector2I regionPos)
        {
            Vector2I indexedPos = regionPos + new Vector2I(512, 512);
            return this.Regions[indexedPos.y, indexedPos.x] != null;
        }

        public void UnloadRegion(Vector2I regionPos)
        {
            Vector2I indexedPos = regionPos + new Vector2I(512, 512);
            if (this.Regions[indexedPos.y, indexedPos.x] == null)
            {
                return;
            }

            this.Regions[indexedPos.y, indexedPos.x].Save();
            this.Regions[indexedPos.y, indexedPos.x] = null;
        }
        #endregion

        #region Chunks
        public Chunk GetChunk(Vector2I chunkPos)
        {
            if (!this.IsChunkLoaded(chunkPos))
            {
                return this.LoadChunk(chunkPos);
            }

            Vector2I regionPos = this.ChunkPosToRegionPos(chunkPos);
            Vector2I localChunkPos = this.WorldChunkPosToRegionChunkPos(chunkPos);

            Region Region = this.GetRegion(regionPos);
            return Region.GetChunk(localChunkPos);
        }

        public bool IsChunkLoaded(Vector2I chunkPos)
        {
            Vector2I regionPos = this.ChunkPosToRegionPos(chunkPos);
            Vector2I localChunkPos = this.WorldChunkPosToRegionChunkPos(chunkPos);

            if (!this.IsRegionLoaded(regionPos)) { return false; }
            return this.GetRegion(regionPos).IsChunkLoaded(localChunkPos);
        }

        public Chunk LoadChunk(Vector2I chunkPos)
        {
            Vector2I regionPos = this.ChunkPosToRegionPos(chunkPos);
            Vector2I localChunkPos = this.WorldChunkPosToRegionChunkPos(chunkPos);

            Region Region = this.GetRegion(regionPos);
            Chunk Chunk = Region.GetChunk(localChunkPos);

            if (!Region.IsChunkLoaded(localChunkPos))
            {
                Chunk.AddRef();
                Chunk.Decompress();

                if (!this.LoadedChunkMap.ContainsKey(Chunk.WorldChunkPos))
                {
                    this.LoadedChunkMap.Add(Chunk.WorldChunkPos, Chunk);
                }
            }
            else
            {
                Chunk.AddRef();
            }

            return Chunk;
        }

        public IEnumerable<Chunk> LoadedChunks
        {
            get
            {
                return this.LoadedChunkMap.Values;
            }
        }

        public void UnloadChunk(Vector2I chunkPos)
        {
            if (!this.IsChunkLoaded(chunkPos))
            {
                return;
            }

            Vector2I regionPos = this.ChunkPosToRegionPos(chunkPos);
            Vector2I localChunkPos = this.WorldChunkPosToRegionChunkPos(chunkPos);

            Region Region = this.GetRegion(regionPos);
            Chunk Chunk = Region.GetChunk(localChunkPos);
            Chunk.Release();

            if (Chunk.RefCount == 0)
            {
                this.LoadedChunkMap.Remove(Chunk.WorldChunkPos);
            }

            if (Region.RefCount == 0)
            {
                this.UnloadRegion(regionPos);
            }
        }
        #endregion

        public override string ToString()
        {
            return this.Type.ToString();
        }

        #region Position Conversion
        public Vector2I ChunkPosToRegionPos(Vector2I chunkPos)
        {
            return chunkPos >> 5;
        }

        public Vector2I WorldChunkPosToRegionChunkPos(Vector2I chunkPos)
        {
            return chunkPos & 0x1F;
        }

        public Vector2I WorldPosToChunkPos(Vector3I worldPos)
        {
            return new Vector2I(worldPos.x >> 4, worldPos.y >> 4);
        }

        public Vector3I WorldPosToChunkLocalPos(Vector3I worldPos)
        {
            return new Vector3I(worldPos.x & 0x0F, worldPos.y & 0x0F, worldPos.z & 0x7F);
        }
        #endregion
    }
}
