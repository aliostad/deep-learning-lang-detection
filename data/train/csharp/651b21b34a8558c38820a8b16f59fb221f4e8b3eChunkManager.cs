using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ChunkManager : MonoBehaviour {

	public Dictionary<float, Transform> chunks;
	public Transform chunk;
	public int chunkWidth;
	public int chunkHeight;
	public int offset;

	void Awake () {
		offset = Random.Range (-1000000, 1000000);
		chunks = new Dictionary<float, Transform> ();
		Create ();
	}

	void Create() {
		for (int i = -3; i <= 3; i++) {
			Transform c = Instantiate (chunk, new Vector2(i * chunkWidth, 0), Quaternion.identity) as Transform;
			chunks.Add (i, c);
		}
	}

	void Update() {
		GenNextChunk(GameObject.Find ("MalePlayer").transform.position.x - chunkWidth);
		GenNextChunk(GameObject.Find ("MalePlayer").transform.position.x + chunkWidth);
		foreach (Transform chunk in chunks.Values) {
			bool active = 	(chunk == GetChunk(GameObject.Find ("MalePlayer").transform.position.x)) ||
							(chunk == GetChunk(GameObject.Find ("MalePlayer").transform.position.x - chunkWidth)) ||
							(chunk == GetChunk(GameObject.Find ("MalePlayer").transform.position.x + chunkWidth));
			chunk.gameObject.SetActive (active);
		}
	}

	public Transform GetChunk(float x) {
		float chunkPos = x / chunkWidth;
		chunkPos = Mathf.Floor (chunkPos);
		if (chunks.ContainsKey (chunkPos) == false) {
			Transform chunkToCreate = Instantiate (chunk, new Vector3(chunkPos * chunkWidth, 0, 0), Quaternion.identity) as Transform;
			chunks.Add (chunkPos, chunkToCreate);
		}
		return chunks[chunkPos];
	}

	public float BlockToWorldPosX(float x) {
		/*Vector2 clickPosOriginal = Camera.main.ScreenToWorldPoint (Input.mousePosition);
		Vector3 clickPos = new Vector3 (Mathf.Round (x), Mathf.Round (y), 0f);
		Transform chunk = GetChunk(clickPos.x);
		clickPos = chunk.TransformPoint (new Vector3 (Mathf.Round (clickPosOriginal.x) - chunk.position.x * 2, Mathf.Round (clickPosOriginal.y), 0f));*/
		Transform chunk = GetChunk (x);
		return x + chunk.position.x;

	}

	void GenNextChunk(float x) {
		float chunkPos = x / chunkWidth;
		chunkPos = Mathf.Floor (chunkPos);
		if (chunks.ContainsKey (chunkPos) == false) {
			Transform chunkToCreate = Instantiate (chunk, new Vector3(chunkPos * chunkWidth, 0, 0), Quaternion.identity) as Transform;
			chunks.Add (chunkPos, chunkToCreate);
		}
	}

	public void DamageBlock(float x, float y) {
		Vector2 position = GetPosition (x, y);
		Chunk chunk = GetChunk (x).GetComponent<Chunk>();
		chunk.DamageBlock (position.x, position.y);
	}

	public void DestroyBlock(float x, float y, bool remains) {
		Vector2 position = GetPosition (x, y);
		Chunk chunk = GetChunk (x).GetComponent<Chunk>();
		chunk.DestroyBlock (position.x, position.y, remains);
	}

	public void DestroyDirectBlock(float x, float y, bool remains) {
		Vector2 position = new Vector2(x, y);
		Chunk chunk = GetChunk (x).GetComponent<Chunk>();
		chunk.DestroyBlock (position.x - chunk.transform.position.x, position.y, remains);
	}
	
	public Transform GetBlock(float x, float y) {
		Vector2 position = GetPosition (x, y);
		Chunk chunk = GetChunk (x).GetComponent<Chunk>();
		return chunk.GetBlock (position.x, position.y);
	}

	public Vector2 GetPosition(float x, float y) {
		Vector2 clickPosOriginal = Camera.main.ScreenToWorldPoint (Input.mousePosition);
		Vector3 clickPos = new Vector3 (Mathf.Round (x), Mathf.Round (y), 0f);
		Transform chunk = GetChunk(clickPos.x);
		clickPos = chunk.TransformPoint (new Vector3 (Mathf.Round (clickPosOriginal.x) - chunk.position.x * 2, Mathf.Round (clickPosOriginal.y), 0f));
		return clickPos;
	}

	public void PlaceBlock(float x, float y, Transform block) {
		Vector2 position = GetPosition (x, y);
		Chunk chunk = GetChunk (x).GetComponent<Chunk>();
		if (GetBlock (x, y) == null) {
			chunk.PlaceBlock (position.x, position.y, block);
		}
	}

	public void PlaceDirectBlock(float x, float y, Transform block) {
		Vector2 position = new Vector2(x, y);
		Chunk chunk = GetChunk (x).GetComponent<Chunk>();
		if(chunk.GetBlock (x - chunk.transform.position.x, y) == false)
			chunk.PlaceBlock (position.x - chunk.transform.position.x, position.y, block);
	}
}
