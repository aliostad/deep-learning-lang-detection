using UnityEngine;
using System.Collections;
using Prime31.MessageKit;

public class Player : MonoBehaviour {
	public ChunkInfo currentChunk;
	private ChunkInfo oldChunk;
	public int x, z;

	void Update () {

		x = Mathf.FloorToInt((transform.position.x + ChunkManager.i.side * 0.5f) / ChunkManager.i.side);
		z = Mathf.FloorToInt((transform.position.z + ChunkManager.i.side * 0.5f) / ChunkManager.i.side);
		ChunkManager.i.currentChunk = ChunkManager.i.GetChunk(x, z);
		if (oldChunk == null) oldChunk = currentChunk;
		currentChunk = ChunkManager.i.currentChunk.info;
		if (currentChunk != oldChunk) {
			print("PlayerChangedChunk");
			MessageKit<ChunkInfo>.post(MsgType.PlayerChangedChunk, currentChunk);
		}
		oldChunk = currentChunk;
	}
}
