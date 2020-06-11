

using LibMCRcon.Nbt;

namespace LibMCRcon.WorldData
{
    public class Region : Voxel
    {

        public Region() : base() { Chunk = OffsetVoxel(16, 16); }
        public Region(Voxel Voxel) : base(Voxel) { Chunk = OffsetVoxel(16, 16); }

        public Voxel Chunk { get; private set; }
        
        NbtChunk nbtChunk;
        NbtChunkSection[] nbtChunkSection = new NbtChunkSection[16];

        int lastChunkIdx = int.MaxValue;
        int lastYSect = int.MaxValue;

        private void ChunkLoad(RegionMCA mca, Voxel Chunk)
        {
            int idx = Chunk.ChunkIdx();
            if (idx != lastChunkIdx)
            {
                nbtChunk = new NbtChunk(mca[idx].chunkNBT);
                lastYSect = int.MaxValue;
                lastChunkIdx = idx;
            }


        }

        private void ChunkYSectLoad(RegionMCA mca, Voxel Chunk)
        {
            int idx = Chunk.Ys;

            if (idx != lastYSect)
            {
                NbtCompound nbtComp = nbtChunk.Section(idx);
                nbtChunkSection[idx] = new NbtChunkSection(nbtComp);
                lastYSect = idx;
            }
        }

        public NbtChunk NbtChunk(RegionMCA mca, Voxel Chunk)
        {

            ChunkLoad(mca, Chunk);
            return nbtChunk;

        }
        public NbtChunk NbtChunk(RegionMCA mca)
        {

            ChunkLoad(mca, Chunk);
            return nbtChunk;
        }

        public NbtChunkSection NbtChunkSection(RegionMCA mca, Voxel Chunk)
        {

            ChunkLoad(mca, Chunk);
            ChunkYSectLoad(mca, Chunk);

            return nbtChunkSection[lastYSect];
        }
        public NbtChunkSection NbtChunkSection(RegionMCA mca)
        {

            ChunkLoad(mca, Chunk);
            ChunkYSectLoad(mca, Chunk);

            return nbtChunkSection[lastYSect];
        }
        public NbtChunkSection NbtChunkLastSection() 
        {
            return nbtChunkSection[lastYSect];
        }

        public void RefreshChunk()
        {
            Chunk.SetVoxel(Y, Xo, Zo, 16, 16);
        }
        public void MergeChunk()
        {
            SetOffset(Chunk);
        }

        public void ResetData()
        {
            nbtChunk = null;
            nbtChunkSection = new NbtChunkSection[16];
            lastChunkIdx = int.MaxValue;
            lastYSect = int.MaxValue;


            Xo = 0;
            Zo = 0;
            Y = 0;

            Chunk = OffsetVoxel(16, 16);
        }
    }
}