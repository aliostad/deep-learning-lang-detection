using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class World : MonoBehaviour
{
	public float size = 2f;
	public int blockResolution = 8;
	public int chunkResolution = 2;

	[SerializeField] private GameObject _chunkPrefab;

	private Chunk[] _chunks;
	private float _chunkSize;
	private float _blockSize;
	private float _halfSize;

	private void Awake ()
	{
		_chunkSize = size / chunkResolution;
		_blockSize = _chunkSize / blockResolution;

		_chunks = new Chunk[chunkResolution * chunkResolution];
		for (int i = 0, y = 0; y < chunkResolution; y++)
		{
			for (int x = 0; x < chunkResolution; x++, i++)
			{
				CreateChunk(i, x, y);
			}
		}
	}

	private void CreateChunk(int i, int x, int y)
	{
		GameObject chunk = (GameObject)Instantiate(_chunkPrefab, this.transform);
		chunk.name = string.Format("Chunk[{0},{1}]", x, y);
		chunk.transform.localPosition = new Vector3(x * _chunkSize, y * _chunkSize);

		Chunk c = chunk.GetComponent<Chunk>();
		if (c != null)
		{
			c.Init(blockResolution, _chunkSize);
		}
		else
		{
			Debug.LogErrorFormat("No Chunk Component found on {0}", c.name);
		}

		_chunks[i] = c;
	}
}
