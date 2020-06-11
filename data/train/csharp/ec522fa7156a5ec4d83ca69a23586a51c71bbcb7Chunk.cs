using UnityEngine;
using Magicolo;

public class Chunk : MonoBehaviour {

	public int chunkId;
	
	public int width;
	public int height;
	public int entreanceY;
	
	public int rightExitY = -1;
	public int upExitX = -1;
	public int downExitX = -1;
	
	public float orientation;
	
	[Disable] public ChunkFlow flow = null;
	[Disable] public bool chunkFlowPresent = false;
	[Disable] public Chunk nextChunk;
	[Disable] public Chunk lastChunk;
	[Disable] public bool playerPassedThrought;
	
	[Disable] public bool isStraight = true;
	
	[Disable] public bool startingChunk = false;
	[Disable] public Vector2 checkPointLocation;

	public Color32 backgroundColor;
	
	
	public int randomToGenerate = -1;

	public ProceduralGeneratorOfChunk proceduralGenerator;
	
	void OnTriggerEnter2D(Collider2D other) {
		if (other.tag == "Player" && chunkId > proceduralGenerator.currentChunkId) {
			proceduralGenerator.setCurrentChunk(this);
			Camera cam = References.RunnerCamera.camera;
			CameraEffet ce = new CameraEffet(cam.backgroundColor, backgroundColor, cam, 2, References.EffectManager);
			References.EffectManager.addEffect(ce);
			playerPassedThrought = true;
			if(randomToGenerate != -1){
				GameData.seed = randomToGenerate;
				GameData.chunkId = chunkId;
			}
		}
	}
	
	public void copyTo(Chunk chunk){
		chunk.chunkId = this.chunkId;
	
		chunk.width = this.width;
		chunk.height = this.height;
		chunk.entreanceY = this.entreanceY;
		
		chunk.rightExitY = this.rightExitY;
		chunk.upExitX = this.upExitX;
		chunk.downExitX = this.downExitX;
		
		chunk.orientation = this.orientation;
		
		chunk.flow = this.flow;
		chunk.chunkFlowPresent = this.chunkFlowPresent;
		chunk.nextChunk = this.nextChunk;
		chunk.lastChunk = this.lastChunk;
		chunk.playerPassedThrought = this.playerPassedThrought;
		
		chunk.isStraight = this.isStraight;
		
		chunk.startingChunk = this.startingChunk;
		chunk.checkPointLocation = this.checkPointLocation;
	
		chunk.backgroundColor = this.backgroundColor;
		
		chunk.randomToGenerate = this.randomToGenerate;
	
		chunk.proceduralGenerator = this.proceduralGenerator;
	}
}
