using UnityEngine;
using System.Collections;

public class ChunkObject : MonoBehaviour 
{
	public MeshFilter _chunkMesh;
	public MeshCollider _chunkCollider;

	public MeshFilter   ChunkMesh 	  { get { return _chunkMesh; } set { _chunkMesh = value; } }
	public MeshCollider ChunkCollider { get { return _chunkCollider; } set { _chunkCollider = value; } }
	
	private Chunk _chunk;
	private bool _dirty = false;
	
	public void SetChunk(Chunk chunk)
	{
		_chunk = chunk;
	}
	
	public void SetDirty()
	{
		_dirty = true;
	}
	
	public void LateUpdate()
	{
		if (_dirty == true)
		{
			_dirty = false;
			_chunk.RefreshChunkMesh();
		}
	}
}
