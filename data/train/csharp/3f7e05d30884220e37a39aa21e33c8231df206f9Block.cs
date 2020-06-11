using UnityEngine;
using System.Collections;
/**
 *  Block class
 */
public enum Block_Type{
	DIRT
}


public class Block{
	// block type 
	protected Block_Type type;

	// block transform relative to chunk.
	// so its world coordinate should be x + this.chunk.x * chunk_x_size
	public int x; 
	public int y;
	public int z; 

	// block coordinates in chunk
	public int chunk_x;
	public int chunk_y; 
	public int chunk_z;

	// block size
	public int block_size; 
	

	// chunk 
	protected Chunk chunk;

	//protected MeshCollider coll;

	// meshdata
	public MeshData meshdata;

	// tile 
	public Tile tile;

	// constructor
	public Block(Block_Type type, int x, int y, int z, Chunk chunk, int chunk_x, int chunk_y, int chunk_z, Tile tile){
		// init properties
		this.type = type;
		this.x = x; 
		this.y = y;
		this.z = z; 
		this.chunk = chunk;
		this.block_size = chunk.world.block_size;
		this.chunk_x = chunk_x;
		this.chunk_y = chunk_y; 
		this.chunk_z = chunk_z;
		this.tile = tile;
	}

	// check whether a block at (chunk_x, chunk_y, chunk_z) is solid
	public bool isSolid(int chunk_x, int chunk_y, int chunk_z){
		Block b = this.chunk.GetBlock (chunk_x, chunk_y, chunk_z);
		if (b == null)
			return false; 
		return true;
	}

	// generate mesh 
	public void generateMesh(MeshData meshdata){
		if (isSolid (chunk_x - 1, chunk_y, chunk_z) == false) {
			meshdata.FaceDataXNegative (this);
		}

		if (isSolid (chunk_x + 1, chunk_y, chunk_z) == false) {
			meshdata.FaceDataXPositive (this);
		}
		if (isSolid (chunk_x, chunk_y - 1, chunk_z) == false) {
			meshdata.FaceDataYNegative (this);
		}

		if (isSolid (chunk_x, chunk_y + 1, chunk_z) == false) {
			meshdata.FaceDataYPositive (this);
		}

		if (isSolid (chunk_x, chunk_y, chunk_z + 1) == false) {
			meshdata.FaceDataZNegative (this);
		}

		if (isSolid (chunk_x, chunk_y, chunk_z - 1) == false) {
			meshdata.FaceDataZPositive (this);
		}
	}
}
