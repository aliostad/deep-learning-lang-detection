using UnityEngine;
using System.Collections;

public class Chunk
{
    #region Variables
    public bool generated; // Used to for checking if a chunk has been created in current World space

    private Block_Base[, ,] blocks; //Array of blocks.
    private Map curWorld; //Instance of the map.
    private int chunkX, chunkZ; // Size of the chunk
    private Chunk_Object chunkObj;
    #endregion

    #region Get/Set
    public int X
    { get { return chunkX; } }
    public int Z
    { get { return chunkZ; } }
    public int WorldX
    { get { return chunkX * curWorld.ChunkX; } }
    public int WorldZ
    { get { return chunkZ * curWorld.ChunkZ; } }

    public Chunk_Object Obj
    {
        get
        {
            if (chunkObj == null)
            {
                chunkObj = Chunk_Object.Instance(curWorld, this);
            }
            return chunkObj;
        } 
    }

    #endregion

    //Constructor
    public Chunk(Map curWorld, int chunkX, int chunkZ)
    {
        this.chunkX = chunkX;
        this.chunkZ = chunkZ;
        this.curWorld = curWorld;

        blocks = new Block_Base[curWorld.ChunkX, curWorld.ChunkY, curWorld.ChunkZ];

    }

    public void SetBlockWPos(Block_Base block, int x, int y, int z)
    {
        SetBlock(block, WorldLocateX(x), y, WorldLocateZ(z));
    }
    public void SetBlock(Block_Base block, int x, int y, int z)
    {
        blocks[x, y, z] = block;
    }
    public void DelBlockWPos(int x, int y, int z)
    {
        DelBlock(WorldLocateX(x), y, WorldLocateZ(z));
    }
    public void DelBlock(int x, int y, int z)
    {
        blocks[x, y, z] = null;
    }

    public Block_Base GetBlockWPos(int x, int y, int z)
    {
        return GetBlock(WorldLocateX(x), y, WorldLocateZ(z));
    }
    public Block_Base GetBlock(int x, int y ,int z)
    {
        return blocks[x, y, z];
    }

    public int WorldLocateX(int x)
    {
        int wX = x % curWorld.ChunkX;
        if (wX < 0)
            wX = curWorld.ChunkX + wX;
        return wX;    
    }
    public int WorldLocateZ(int z)
    {
        int wZ = z % curWorld.ChunkZ;
        if (wZ < 0)
            wZ = curWorld.ChunkZ + wZ;
        return wZ;
    }
    public bool NeighboursReady()
    {
        if (curWorld.GetChunk(chunkX - 1, chunkZ).generated
                && curWorld.GetChunk(chunkX, chunkZ - 1).generated
                && curWorld.GetChunk(chunkX + 1, chunkZ).generated
                && curWorld.GetChunk(chunkX, chunkZ + 1).generated
                && curWorld.GetChunk(chunkX + 1, chunkZ + 1).generated
                && curWorld.GetChunk(chunkX - 1, chunkZ - 1).generated
                && curWorld.GetChunk(chunkX + 1, chunkZ - 1).generated
                && curWorld.GetChunk(chunkX - 1, chunkZ + 1).generated)
            return true;
        return false;
    }

}
