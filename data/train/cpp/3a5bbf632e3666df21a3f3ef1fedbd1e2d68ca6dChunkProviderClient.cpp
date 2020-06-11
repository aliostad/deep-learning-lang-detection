#include "ChunkProviderClient.h"


ChunkProviderClient(World ChunkProviderClient::world) 
{
        chunkMapping = new HashMap();
        field_889_c = new ArrayList();
        blankChunk = new EmptyChunk(world, new byte[32768], 0, 0);
        worldObj = world;
}

boolean ChunkProviderClient::chunkExists(int i, int j) 
{
        ChunkCoordIntPair chunkcoordintpair = new ChunkCoordIntPair(i, j);
        return chunkMapping.containsKey(chunkcoordintpair);
}

void ChunkProviderClient::func_539_c(int i, int j) 
{
        Chunk chunk = provideChunk(i, j);
        if(!chunk.func_21167_h())
        {
            chunk.onChunkUnload();
        }
        chunkMapping.remove(new ChunkCoordIntPair(i, j));
        field_889_c.remove(chunk);
}

Chunk ChunkProviderClient::func_538_d(int i, int j) 
{
        ChunkCoordIntPair chunkcoordintpair = new ChunkCoordIntPair(i, j);
        BYTE abyte0[] = new byte[32768];
        Chunk chunk = new Chunk(worldObj, abyte0, i, j);
        Arrays.fill(chunk.skylightMap.data, (byte)-1);
        chunkMapping.put(chunkcoordintpair, chunk);
        chunk.isChunkLoaded = true;
        return chunk;
}

Chunk ChunkProviderClient::provideChunk(int i, int j) 
{
        ChunkCoordIntPair chunkcoordintpair = new ChunkCoordIntPair(i, j);
        Chunk chunk = (Chunk)chunkMapping.get(chunkcoordintpair);
        if(chunk == null)
        {
            return blankChunk;
        } else
        {
            return chunk;
        }
}

boolean ChunkProviderClient::saveChunks(boolean flag, IProgressUpdate iprogressupdate) 
{
        return true;
}

boolean ChunkProviderClient::func_532_a() 
{
        return false;
}

boolean ChunkProviderClient::func_536_b() 
{
        return false;
}

void ChunkProviderClient::populate(IChunkProvider ichunkprovider, int i, int j) 
{
}

String ChunkProviderClient::makeString() 
{
        return (new StringBuilder()).append("MultiplayerChunkCache: ").append(chunkMapping.size()).toString();
}

