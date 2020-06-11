using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class World : MonoBehaviour {
	public Dictionary<WorldPos, Chunk> chunks = new Dictionary<WorldPos, Chunk>();
	public Dictionary<WorldPos, Dynamic_Object> ground_objects = new Dictionary<WorldPos, Dynamic_Object>();
	public GameObject chunk_prefab;
	
	public void Create_Chunk(int x, int y, int z) {
		WorldPos world_pos = new WorldPos(x, y, z);
		
		GameObject new_chunk_object = Instantiate(chunk_prefab, new Vector3(x, y, z), Quaternion.Euler(Vector3.zero)) as GameObject;
		Chunk new_chunk = new_chunk_object.GetComponent<Chunk>();
		
		new_chunk.pos = world_pos;
		new_chunk.world = this;
		
		chunks.Add(world_pos, new_chunk);
		
		var terrain_gen = new TerrainGen();
		new_chunk = terrain_gen.Chunk_Gen(new_chunk);
	}
	
	public void Destroy_Chunk(int x, int y, int z) {
		Chunk chunk = null;
		if(chunks.TryGetValue(new WorldPos(x, y, z), out chunk)) {
			Object.Destroy(chunk.gameObject);
			chunks.Remove(new WorldPos(x, y, z));
		}
	}
	
	public Chunk Get_Chunk(int x, int y, int z) {
		WorldPos pos = new WorldPos();
		float multiple = Chunk.chunk_size;
		pos.x = Mathf.FloorToInt(x / multiple) * Chunk.chunk_size;
		pos.y = Mathf.FloorToInt(y / multiple) * Chunk.chunk_size;
		pos.z = Mathf.FloorToInt(z / multiple) * Chunk.chunk_size;
		
		Chunk container_chunk = null;
		
		chunks.TryGetValue(pos, out container_chunk);
		
		return container_chunk;
	}
	
	public void Set_Block(int x, int y, int z, Block block) {
		Chunk chunk = Get_Chunk(x, y, z);
		
		if (chunk != null) {
			chunk.Set_Block(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, block);
			chunk.update = true;
		}
	}
	
	public Block Get_Block(int x, int y, int z) {
		Chunk container_chunk = Get_Chunk(x, y, z);
		
		if(container_chunk != null) {
			Block block = container_chunk.Get_Block(
				x - container_chunk.pos.x,
				y - container_chunk.pos.y,
				z - container_chunk.pos.z);
			return block;
		} else {
			return new CenterGrass();
		}
	}
	
}
