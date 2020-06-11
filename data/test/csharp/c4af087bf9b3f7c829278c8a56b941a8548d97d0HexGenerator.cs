using UnityEngine;
using System.Collections.Generic;



public class HexGenerator : MonoBehaviour 
{
	[Tooltip("For Square Chunks X Should = Y/4")]
	public int chunkScale;
	public int viewDistance;
	public float heightScale;

	void Start () 
	{
		int localView = viewDistance / 2;
		for(int ChunkX = -localView; ChunkX < localView; ++ChunkX)
			for(int ChunkZ = -localView; ChunkZ < localView; ++ChunkZ)
				GenerateChunk(ChunkX,ChunkZ);		
	}

	void GenerateChunk(int ChunkX, int ChunkZ)
	{
		ChunkX = Mathf.CeilToInt(ChunkX); // Remove -0
		ChunkZ = Mathf.CeilToInt(ChunkZ); // Remove -0

		GameParameters ins = GameParameters.Instance;
		int chunkScaleX = chunkScale / 2;
		int chunkScaleZ = chunkScale * 2;

		GameObject Chunk = new GameObject();
		Chunk.name = "Chunk :" + ChunkX + ":" + ChunkZ;
		Chunk.transform.position = new Vector3(ChunkX * chunkScaleX * 3.0f,0,(ChunkZ * chunkScaleZ * 0.87f));
		Chunk.transform.parent = transform;
		BoxCollider bc = Chunk.AddComponent<BoxCollider>();
		bc.size = new Vector3(chunkScaleX * 3.0f,128,chunkScaleZ * 0.87f);
		bc.center += new Vector3(0,0,chunkScaleZ * 0.435f);
		bc.isTrigger = true;

		for(int x = 0; x < chunkScaleX; ++x)
		{
			for(int z = 0; z < chunkScaleZ; ++z)
			{
				Perlin plains = ins.PerlinGroups[0];
				Perlin mountians = ins.PerlinGroups[1];
				Perlin blendMap = ins.PerlinGroups[2];
				
				float X = Chunk.transform.position.x + ((x * 3.0f) - ((z % 2 == 1) ? 1.5f : 0.0f));
				float Z = Chunk.transform.position.z + (z * 0.87f); 

				float Y = Mathf.Lerp( plains.GetValue(X,Z), mountians.GetValue(X,Z),blendMap.blendCurve.Evaluate(blendMap.GetValue(X,Z)));
				//float Y = mountians.GetValue(X,Z);
				
				GameObject go = GameObject.Instantiate(GameParameters.Instance.Hexagon,new Vector3(X,Y,Z),Quaternion.identity) as GameObject;
				go.transform.parent = Chunk.transform;
			}
		}
	}
}
