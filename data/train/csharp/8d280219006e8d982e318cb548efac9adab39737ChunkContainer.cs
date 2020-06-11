using UnityEngine;
using System.Collections;

[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]
[RequireComponent(typeof(MeshCollider))]
public class ChunkContainer : MonoBehaviour {

	public Chunk chunk = null;

	public void Init() {
		if(chunk == null) {
			Debug.LogError("tried to init null chunk");
			return;
		}
		chunk.filter = gameObject.GetComponent<MeshFilter>();
		chunk.coll = gameObject.GetComponent<MeshCollider>();
	}
	
	void Update() {
		if(chunk.update) {
			chunk.update = false;
			chunk.UpdateChunk();
		}
	}
}
