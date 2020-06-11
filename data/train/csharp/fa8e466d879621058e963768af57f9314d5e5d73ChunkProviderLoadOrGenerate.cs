using java.lang;

namespace CraftyServer.Core
{
    public class ChunkProviderLoadOrGenerate
        : IChunkProvider
    {
        private readonly Chunk blankChunk;
        private readonly IChunkLoader chunkLoader;
        private readonly IChunkProvider chunkProvider;
        private readonly Chunk[] chunks;
        private readonly World worldObj;
        private int field_21112_j;
        private int field_21113_i;
        private Chunk lastQueriedChunk;
        private int lastQueriedChunkXPos;
        private int lastQueriedChunkZPos;

        public ChunkProviderLoadOrGenerate(World world, IChunkLoader ichunkloader, IChunkProvider ichunkprovider)
        {
            chunks = new Chunk[1024];
            lastQueriedChunkXPos = unchecked((int) 0xc4653601);
            lastQueriedChunkZPos = unchecked((int) 0xc4653601);
            blankChunk = new EmptyChunk(world, new byte[32768], 0, 0);
            worldObj = world;
            chunkLoader = ichunkloader;
            chunkProvider = ichunkprovider;
        }

        #region IChunkProvider Members

        public bool chunkExists(int i, int j)
        {
            if (!func_21111_c(i, j))
            {
                return false;
            }
            if (i == lastQueriedChunkXPos && j == lastQueriedChunkZPos && lastQueriedChunk != null)
            {
                return true;
            }
            else
            {
                int k = i & 0x1f;
                int l = j & 0x1f;
                int i1 = k + l*32;
                return chunks[i1] != null && (chunks[i1] == blankChunk || chunks[i1].isAtLocation(i, j));
            }
        }

        public Chunk provideChunk(int i, int j)
        {
            if (i == lastQueriedChunkXPos && j == lastQueriedChunkZPos && lastQueriedChunk != null)
            {
                return lastQueriedChunk;
            }
            if (!worldObj.field_9209_x && !func_21111_c(i, j))
            {
                return blankChunk;
            }
            int k = i & 0x1f;
            int l = j & 0x1f;
            int i1 = k + l*32;
            if (!chunkExists(i, j))
            {
                if (chunks[i1] != null)
                {
                    chunks[i1].onChunkUnload();
                    saveChunk(chunks[i1]);
                    saveExtraChunkData(chunks[i1]);
                }
                Chunk chunk = func_4059_c(i, j);
                if (chunk == null)
                {
                    if (chunkProvider == null)
                    {
                        chunk = blankChunk;
                    }
                    else
                    {
                        chunk = chunkProvider.provideChunk(i, j);
                    }
                }
                chunks[i1] = chunk;
                chunk.func_4053_c();
                if (chunks[i1] != null)
                {
                    chunks[i1].onChunkLoad();
                }
                if (!chunks[i1].isTerrainPopulated && chunkExists(i + 1, j + 1) && chunkExists(i, j + 1) &&
                    chunkExists(i + 1, j))
                {
                    populate(this, i, j);
                }
                if (chunkExists(i - 1, j) && !provideChunk(i - 1, j).isTerrainPopulated && chunkExists(i - 1, j + 1) &&
                    chunkExists(i, j + 1) && chunkExists(i - 1, j))
                {
                    populate(this, i - 1, j);
                }
                if (chunkExists(i, j - 1) && !provideChunk(i, j - 1).isTerrainPopulated && chunkExists(i + 1, j - 1) &&
                    chunkExists(i, j - 1) && chunkExists(i + 1, j))
                {
                    populate(this, i, j - 1);
                }
                if (chunkExists(i - 1, j - 1) && !provideChunk(i - 1, j - 1).isTerrainPopulated &&
                    chunkExists(i - 1, j - 1) && chunkExists(i, j - 1) && chunkExists(i - 1, j))
                {
                    populate(this, i - 1, j - 1);
                }
            }
            lastQueriedChunkXPos = i;
            lastQueriedChunkZPos = j;
            lastQueriedChunk = chunks[i1];
            return chunks[i1];
        }

        public void populate(IChunkProvider ichunkprovider, int i, int j)
        {
            Chunk chunk = provideChunk(i, j);
            if (!chunk.isTerrainPopulated)
            {
                chunk.isTerrainPopulated = true;
                if (chunkProvider != null)
                {
                    chunkProvider.populate(ichunkprovider, i, j);
                    chunk.setChunkModified();
                }
            }
        }

        public bool saveChunks(bool flag, IProgressUpdate iprogressupdate)
        {
            int i = 0;
            int j = 0;
            if (iprogressupdate != null)
            {
                for (int k = 0; k < chunks.Length; k++)
                {
                    if (chunks[k] != null && chunks[k].needsSaving(flag))
                    {
                        j++;
                    }
                }
            }
            int l = 0;
            for (int i1 = 0; i1 < chunks.Length; i1++)
            {
                if (chunks[i1] == null)
                {
                    continue;
                }
                if (flag && !chunks[i1].neverSave)
                {
                    saveExtraChunkData(chunks[i1]);
                }
                if (!chunks[i1].needsSaving(flag))
                {
                    continue;
                }
                saveChunk(chunks[i1]);
                chunks[i1].isModified = false;
                if (++i == 2 && !flag)
                {
                    return false;
                }
                if (iprogressupdate != null && ++l%10 == 0)
                {
                    iprogressupdate.setLoadingProgress((l*100)/j);
                }
            }

            if (flag)
            {
                if (chunkLoader == null)
                {
                    return true;
                }
                chunkLoader.saveExtraData();
            }
            return true;
        }

        public bool func_361_a()
        {
            if (chunkLoader != null)
            {
                chunkLoader.func_661_a();
            }
            return chunkProvider.func_361_a();
        }

        public bool func_364_b()
        {
            return true;
        }

        #endregion

        public bool func_21111_c(int i, int j)
        {
            byte byte0 = 15;
            return i >= field_21113_i - byte0 && j >= field_21112_j - byte0 && i <= field_21113_i + byte0 &&
                   j <= field_21112_j + byte0;
        }

        private Chunk func_4059_c(int i, int j)
        {
            if (chunkLoader == null)
            {
                return blankChunk;
            }
            try
            {
                Chunk chunk = chunkLoader.loadChunk(worldObj, i, j);
                if (chunk != null)
                {
                    chunk.lastSaveTime = worldObj.getWorldTime();
                }
                return chunk;
            }
            catch (Exception exception)
            {
                exception.printStackTrace();
            }
            return blankChunk;
        }

        private void saveExtraChunkData(Chunk chunk)
        {
            if (chunkLoader == null)
            {
                return;
            }
            try
            {
                chunkLoader.saveExtraChunkData(worldObj, chunk);
            }
            catch (Exception exception)
            {
                exception.printStackTrace();
            }
        }

        private void saveChunk(Chunk chunk)
        {
            if (chunkLoader == null)
            {
                return;
            }
            chunk.lastSaveTime = worldObj.getWorldTime();
            chunkLoader.saveChunk(worldObj, chunk);
        }
    }
}