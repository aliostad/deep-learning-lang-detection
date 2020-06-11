using System;
using System.Collections.Generic;

public class ChunkRequest
{
    public enum RequestType
    {
        Generation,
        Deletion,
        Update,
        Save,
        Load
    };

	public ChunkRequest(RequestType chunkRequestType, Chunk chunk)
    {
        this.chunkRequestType = chunkRequestType;
        this.ChunkX = 0;
        this.ChunkZ = 0;
        this.chunk = chunk;
    }

    public ChunkRequest(RequestType chunkRequestType, ChunkUpdate chunkUpdate)
    {
        this.chunkRequestType = chunkRequestType;
        this.ChunkX = 0;
        this.ChunkZ = 0;
        this.update = chunkUpdate;
    }

    public ChunkRequest(RequestType chunkRequestType, int ChunkX, int ChunkZ)
    {
        this.chunkRequestType = chunkRequestType;
        this.ChunkX = ChunkX;
        this.ChunkZ = ChunkZ;
        this.chunk = null;
    }

    public RequestType chunkRequestType;
    public int ChunkX;
    public int ChunkZ;
    public Chunk chunk;
    public ChunkUpdate update;
}
