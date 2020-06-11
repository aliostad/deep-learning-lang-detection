using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Voxel
{
    // Class to encapsulate the voxel world data
    public class WorldData 
    {
	    // World & chunk sizes - set defaults
	    private IntVec3 m_WorldSizeChunks = new IntVec3(16,16,16);
	    private IntVec3 m_ChunkSizeBlocks = new IntVec3(32,32,32);
	    private IntVec3 m_WorldSize;
	
	    private Chunk[,,]	m_Chunks;
	    private Block		m_OutsideBlock;

        public delegate void ChunkDelegate(Chunk chk);

        public event ChunkDelegate OnNewChunk;

        // this list is used to store a list of dirty chunks - this will be used to rebuild the voxel meshes
        private List<Chunk>	m_DirtyChunks = new List<Chunk>();

	    // public properties
	    public IntVec3 WorldSizeBlocks { get { return m_WorldSize;}}
	    public IntVec3 WorldSizeChunks { get { return m_WorldSizeChunks;}}
	    public IntVec3 ChunkSizeBlocks { get { return m_ChunkSizeBlocks;}}
        public List<Chunk> DirtyChunks { get { return m_DirtyChunks; }}
        
        public WorldData()
	    {
		    m_OutsideBlock.m_Type = (byte)BlockType.Air;	// block used to return invalid types etc.
	    }

        // this must be called before init chunks
        public void SetDimensions(IntVec3 worldSize, IntVec3 chunkSize)
        {
            Debug.Log("WorldData - SetDimensions");
            Debug.Log("World Size in chunks: " + worldSize.ToString());
            Debug.Log("Chunk size in blocks: " + chunkSize.ToString());
            m_WorldSizeChunks = worldSize;
            m_ChunkSizeBlocks = chunkSize;
        } 

	    public void InitChunks()
	    {
		    m_Chunks = new Chunk[m_WorldSizeChunks.x,m_WorldSizeChunks.y,m_WorldSizeChunks.z];
		
		    m_WorldSize = new IntVec3(m_WorldSizeChunks.x * m_ChunkSizeBlocks.x,m_WorldSizeChunks.y * m_ChunkSizeBlocks.y,m_WorldSizeChunks.z * m_ChunkSizeBlocks.z);
        }

        public void MarkAllChunksDirty()
        {
            foreach (Chunk chunk in m_Chunks)
            {
                if (chunk.MarkDirty())
                    AddDirtyChunk(chunk);
            }
        }

        public void AddDirtyChunk(Chunk chunk)
        {
            m_DirtyChunks.Add(chunk);
        }
	
	    public bool PosOutsideWorld(int x,int y,int z)
	    {
		    if(	x < 0 || y < 0 || z < 0 || 
			    x >= m_WorldSize.x || y >= m_WorldSize.y || z >= m_WorldSize.z)
			    return true;
			
		    return false;
 	    }

	    // coords passed in air voxel world coords
	    // air block is returned for out of world or empty chunk
	    public Block GetBlock(int x,int y,int z)
        {
		    if(PosOutsideWorld(x,y,z))
            {
                //Debug.Log("GetBlock - outside world: " + pos.ToString());
			    return m_OutsideBlock;
            }
		
            // TODO: this could be sped up if chunk size were always powers of 2
            // we could use shifts & logical AND instead of div & mod
		    int chunkX = x / m_ChunkSizeBlocks.x;
            int chunkY = y / m_ChunkSizeBlocks.y;
            int chunkZ = z / m_ChunkSizeBlocks.z;
            int blockX = x % m_ChunkSizeBlocks.x;
            int blockY = y % m_ChunkSizeBlocks.y;
            int blockZ = z % m_ChunkSizeBlocks.z;

		    Chunk chunk = m_Chunks[chunkX, chunkY, chunkZ];
		    if(chunk == null)
			    return m_OutsideBlock;
		    else
			    return chunk.Blocks[blockX, blockY, blockZ];
        }

        // create a chunk at a given chunk coordinate
        public Chunk CreateChunk(int chunkX,int chunkY,int chunkZ)
        {
            if(m_Chunks[chunkX, chunkY, chunkZ]  != null)   // if one already there return it
                return m_Chunks[chunkX, chunkY, chunkZ];

            Chunk chunk = new Chunk(this,new IntVec3(chunkX * m_ChunkSizeBlocks.x,chunkY * m_ChunkSizeBlocks.y,chunkZ * m_ChunkSizeBlocks.z));
            chunk.ChunkPos = new IntVec3(chunkX, chunkY, chunkZ);
            chunk.InitBlocks(m_ChunkSizeBlocks);
            OnNewChunk(chunk);  // call event

            m_Chunks[chunkX, chunkY, chunkZ] = chunk;
            return chunk;
        }

        public void SetBlock(int x,int y,int z, byte blockType, bool bMarkDirty = true)
        {
		    if(PosOutsideWorld(x,y,z))
            {
                Debug.Log(string.Format("SetBlock failed point outside world: {0},{1},{2}",x,y,z));
                return;
            }
			  
		    // calc chunk and block coords
		    int chunkX = x / m_ChunkSizeBlocks.x;
            int chunkY = y / m_ChunkSizeBlocks.y;
            int chunkZ = z / m_ChunkSizeBlocks.z;
            int blockX = x % m_ChunkSizeBlocks.x;
            int blockY = y % m_ChunkSizeBlocks.y;
            int blockZ = z % m_ChunkSizeBlocks.z;

		    Chunk chunk = m_Chunks[chunkX, chunkY, chunkZ];

            //Debug.Log(string.Format("Setting chunk at {0},{1},{2}",chunkX, chunkY, chunkZ));
		
		    // create new chunk if this one is empty 
		    // (we could check against setting air as block type and early out ?)
		    if(chunk == null)	
		    {
			    chunk = CreateChunk(chunkX, chunkY, chunkZ);
		    }
		
		    chunk.Blocks[blockX, blockY, blockZ].m_Type = blockType;

            // Mark block dirty and process surrounding blocks if needed
            if (!bMarkDirty)
                return;
        
            if (chunk.MarkDirty())
                AddDirtyChunk(chunk);

            // If we set a block on the chunk edge set neigbouring chunk as dirty
            if (blockX == 0 && chunkX > 0)
            {
                Chunk neighbour = m_Chunks[chunkX - 1, chunkY, chunkZ];
                if (neighbour != null && neighbour.MarkDirty())
                    AddDirtyChunk(neighbour);
            }

            if (blockX == m_ChunkSizeBlocks.x - 1 && chunkX < m_WorldSizeChunks.x - 1)
            {
                Chunk neighbour = m_Chunks[chunkX + 1, chunkY, chunkZ];
                if (neighbour != null && neighbour.MarkDirty())
                    AddDirtyChunk(neighbour);
            }

            //  Y neigbours
            if (blockY == 0 && chunkY > 0)
            {
                Chunk neighbour = m_Chunks[chunkX, chunkY - 1, chunkZ];
                if (neighbour != null && neighbour.MarkDirty())
                    AddDirtyChunk(neighbour);
            }

            if (blockY == m_ChunkSizeBlocks.y - 1 && chunkY < m_WorldSizeChunks.y - 1)
            {
                Chunk neighbour = m_Chunks[chunkX, chunkY + 1, chunkZ];
                if (neighbour != null && neighbour.MarkDirty())
                    AddDirtyChunk(neighbour);
            }

            // Z neigbours
            if (blockZ == 0 && chunkZ > 0)
            {
                Chunk neighbour = m_Chunks[chunkX, chunkY, chunkZ - 1];
                if (neighbour != null && neighbour.MarkDirty())
                    AddDirtyChunk(neighbour);
            }

            if (blockZ == m_ChunkSizeBlocks.z - 1 && chunkZ < m_WorldSizeChunks.z - 1)
            {
                Chunk neighbour = m_Chunks[chunkX, chunkY, chunkZ + 1];
                if (neighbour != null && neighbour.MarkDirty())
                    AddDirtyChunk(neighbour);
            }
        }
    }

}//namespace Voxel
