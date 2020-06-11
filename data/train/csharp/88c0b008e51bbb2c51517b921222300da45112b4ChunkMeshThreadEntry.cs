using UnityEngine;
using System.Collections;
using System.Threading;
using ChunkRendering;

public class ChunkMeshThreadEntry {

	private Chunk chunkToBeRendered;
	
	public ChunkMeshThreadEntry(Chunk chunk)
	{
		chunkToBeRendered = chunk;
	}
	
	public void Init()
	{
		chunkToBeRendered.InitGameObject();
		chunkToBeRendered.InitRenderableSlices();
	}
	
	public void ThreadCallback(object threadContext)
	{
		ChunkRenderer chunkRenderer = new ChunkRenderer();
		chunkRenderer.RenderChunk(chunkToBeRendered);
	}
}
