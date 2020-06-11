#include "ChunkProviderLoadOrGenerate.h"


ChunkProviderLoadOrGenerate(World ChunkProviderLoadOrGenerate::world, IChunkLoader ichunkloader, IChunkProvider ichunkprovider) 
{
        chunks = new Chunk[1024];
        lastQueriedChunkXPos = 0xc4653601;
        lastQueriedChunkZPos = 0xc4653601;
        blankChunk = new EmptyChunk(world, new byte[32768], 0, 0);
        worldObj = world;
        chunkLoader = ichunkloader;
        chunkProvider = ichunkprovider;
}

void ChunkProviderLoadOrGenerate::setCurrentChunkOver(int i, int j) 
{
        curChunkX = i;
        curChunkY = j;
}

boolean ChunkProviderLoadOrGenerate::canChunkExist(int i, int j) 
{
        BYTE byte0 = 15;
        return i >= curChunkX - byte0 && j >= curChunkY - byte0 && i <= curChunkX + byte0 && j <= curChunkY + byte0;
}

boolean ChunkProviderLoadOrGenerate::chunkExists(int i, int j) 
{
        if(!canChunkExist(i, j))
        {
            return false;
        }
        if(i == lastQueriedChunkXPos && j == lastQueriedChunkZPos && lastQueriedChunk != null)
        {
            return true;
        } else
        {
            int k = i & 0x1f;
            int l = j & 0x1f;
            int i1 = k + l * 32;
            return chunks[i1] != null && (chunks[i1] == blankChunk || chunks[i1].isAtLocation(i, j));
        }
}

Chunk ChunkProviderLoadOrGenerate::func_538_d(int i, int j) 
{
        return provideChunk(i, j);
}

Chunk ChunkProviderLoadOrGenerate::provideChunk(int i, int j) 
{
        if(i == lastQueriedChunkXPos && j == lastQueriedChunkZPos && lastQueriedChunk != null)
        {
            return lastQueriedChunk;
        }
        if(!worldObj.findingSpawnPoint && !canChunkExist(i, j))
        {
            return blankChunk;
        }
        int k = i & 0x1f;
        int l = j & 0x1f;
        int i1 = k + l * 32;
        if(!chunkExists(i, j))
        {
            if(chunks[i1] != null)
            {
                chunks[i1].onChunkUnload();
                saveChunk(chunks[i1]);
                saveExtraChunkData(chunks[i1]);
            }
            Chunk chunk = func_542_c(i, j);
            if(chunk == null)
            {
                if(chunkProvider == null)
                {
                    chunk = blankChunk;
                } else
                {
                    chunk = chunkProvider.provideChunk(i, j);
                    chunk.func_25124_i();
                }
            }
            chunks[i1] = chunk;
            chunk.func_4143_d();
            if(chunks[i1] != null)
            {
                chunks[i1].onChunkLoad();
            }
            if(!chunks[i1].isTerrainPopulated && chunkExists(i + 1, j + 1) && chunkExists(i, j + 1) && chunkExists(i + 1, j))
            {
                populate(this, i, j);
            }
            if(chunkExists(i - 1, j) && !provideChunk(i - 1, j).isTerrainPopulated && chunkExists(i - 1, j + 1) && chunkExists(i, j + 1) && chunkExists(i - 1, j))
            {
                populate(this, i - 1, j);
            }
            if(chunkExists(i, j - 1) && !provideChunk(i, j - 1).isTerrainPopulated && chunkExists(i + 1, j - 1) && chunkExists(i, j - 1) && chunkExists(i + 1, j))
            {
                populate(this, i, j - 1);
            }
            if(chunkExists(i - 1, j - 1) && !provideChunk(i - 1, j - 1).isTerrainPopulated && chunkExists(i - 1, j - 1) && chunkExists(i, j - 1) && chunkExists(i - 1, j))
            {
                populate(this, i - 1, j - 1);
            }
        }
        lastQueriedChunkXPos = i;
        lastQueriedChunkZPos = j;
        lastQueriedChunk = chunks[i1];
        return chunks[i1];
}

Chunk ChunkProviderLoadOrGenerate::func_542_c(int i, int j) 
    {
        if(chunkLoader == null)
        {
            return blankChunk;
        }
        try
        {
            Chunk chunk = chunkLoader.loadChunk(worldObj, i, j);
            if(chunk != null)
            {
                chunk.lastSaveTime = worldObj.getWorldTime();
            }
            return chunk;
        }
        catch(Exception exception)
        {
            exception.printStackTrace();
        }
        return blankChunk;
}

void ChunkProviderLoadOrGenerate::saveExtraChunkData(Chunk chunk) 
    {
        if(chunkLoader == null)
        {
            return;
        }
        try
        {
            chunkLoader.saveExtraChunkData(worldObj, chunk);
        }
        catch(Exception exception)
        {
            exception.printStackTrace();
        }
}

void ChunkProviderLoadOrGenerate::saveChunk(Chunk chunk) 
    {
        if(chunkLoader == null)
        {
            return;
        }
        try
        {
            chunk.lastSaveTime = worldObj.getWorldTime();
            chunkLoader.saveChunk(worldObj, chunk);
        }
        catch(IOException ioexception)
        {
            ioexception.printStackTrace();
        }
}

void ChunkProviderLoadOrGenerate::populate(IChunkProvider ichunkprovider, int i, int j) 
{
        Chunk chunk = provideChunk(i, j);
        if(!chunk.isTerrainPopulated)
        {
            chunk.isTerrainPopulated = true;
            if(chunkProvider != null)
            {
                chunkProvider.populate(ichunkprovider, i, j);
                chunk.setChunkModified();
            }
        }
}

boolean ChunkProviderLoadOrGenerate::saveChunks(boolean flag, IProgressUpdate iprogressupdate) 
{
        int i = 0;
        int j = 0;
        if(iprogressupdate != null)
        {
            for(int k = 0; k < chunks.length; k++)
            {
                if(chunks[k] != null && chunks[k].needsSaving(flag))
                {
                    j++;
                }
            }

        }
        int l = 0;
        for(int i1 = 0; i1 < chunks.length; i1++)
        {
            if(chunks[i1] == null)
            {
                continue;
            }
            if(flag && !chunks[i1].neverSave)
            {
                saveExtraChunkData(chunks[i1]);
            }
            if(!chunks[i1].needsSaving(flag))
            {
                continue;
            }
            saveChunk(chunks[i1]);
            chunks[i1].isModified = false;
            if(++i == 2 && !flag)
            {
                return false;
            }
            if(iprogressupdate != null && ++l % 10 == 0)
            {
                iprogressupdate.setLoadingProgress((l * 100) / j);
            }
        }

        if(flag)
        {
            if(chunkLoader == null)
            {
                return true;
            }
            chunkLoader.saveExtraData();
        }
        return true;
}

boolean ChunkProviderLoadOrGenerate::func_532_a() 
{
        if(chunkLoader != null)
        {
            chunkLoader.func_814_a();
        }
        return chunkProvider.func_532_a();
}

boolean ChunkProviderLoadOrGenerate::func_536_b() 
{
        return true;
}

String ChunkProviderLoadOrGenerate::makeString() 
{
        return (new StringBuilder()).append("ChunkCache: ").append(chunks.length).toString();
}

