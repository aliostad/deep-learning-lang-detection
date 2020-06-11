using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class TerrainChunk : Chunk {

	public SolidSubChunk groundChunk;
	public AlphaWaveSubChunk grassChunk;
	
	//protected 	
	// Use this for initialization
	public override void Start () {
		updateChunk = true;
	}
	public override void poolStart() {
		blockWorld = new short[chunkWidth,chunkHeight,chunkDepth];
		for(int x = 0; x<chunkWidth; x++ )
			for(int y=0; y<chunkHeight; y++)
				for(int z=0; z<chunkDepth; z++)
					blockWorld[x,y,z] = 0;
		updateChunk = false;
		subChunk.Clear();
		StartCoroutine(Generate());
	}

	public override IEnumerator Generate() {
		
		SolidSubChunk Ground = groundChunk.GetPooledInstance<SolidSubChunk> ();	
		Ground.parentChunk = this;	
		Ground.chunkWidth = chunkWidth;
		Ground.chunkHeight = chunkHeight;
		Ground.chunkDepth = chunkDepth;
		Ground.index = 0;
		Ground.transform.position = position;
		subChunk.Add(Ground);
		
		AlphaWaveSubChunk Grass = grassChunk.GetPooledInstance<AlphaWaveSubChunk> ();	
		Grass.parentChunk = this;	
		Grass.chunkWidth = chunkWidth;
		Grass.chunkHeight = chunkHeight;
		Grass.chunkDepth = chunkDepth;
		Grass.index = 1;
		Grass.transform.position = position;
		subChunk.Add(Grass);
		
		Ground.poolStart();
		Grass.poolStart();
		Ground.ReadyToGenerate();
		Grass.ReadyToGenerate();
		
		yield return 0;
	}

	public override IEnumerator ReDraw() {
		yield return 0;
	}

	public override IEnumerator renderMesh(ChunkMesh data) {
		yield return 0;
	}
	
	// Update is called once per frame
	protected override void Update () {
		if(updateChunk) {
			updateChunk = false;
			StartCoroutine(ReDraw());
		}
	}
}
