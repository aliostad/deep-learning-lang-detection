using UnityEngine;
using System;
using System.Collections;
using RPG.Assets.Scripts.Core;
using RPG.Assets.Scripts.Data;

public class God : MonoBehaviour {

	private XmlRepository<World> worldRepo;

	public GameObject ActivePlayer;
	public GameObject TilePrefab;
	private Chunk CurrentChunk;

	public World worldData;

	// Use this for initialization
	void Start () {
		// Load the world
		worldRepo = new XmlRepository<World>();
		worldData = worldRepo.GetById(new System.Guid("4e9b0641-b915-4259-b83e-c5ff96f86db9"));

		Debug.Log(worldData.Chunk.MinX() + "," + worldData.Chunk.MinY() + "," + worldData.Chunk.MaxX() + "," + worldData.Chunk.MaxY() + "," + worldData.Chunk.Width() + "," + worldData.Chunk.Height());
	}
	
	// Update is called once per frame
	void Update () {
		if(ActivePlayer != null)
		{
			Chunk currentChunk = worldData.FindChunk(ActivePlayer.transform.position.x, ActivePlayer.transform.position.y);

			if(CurrentChunk == null || CurrentChunk != currentChunk)
			{
				ChangeChunk(currentChunk);
			}
		}
	}
	
	private void ChangeChunk(Chunk currentChunk)
	{
		if(currentChunk != null)
		{
			Chunk previousChunk = CurrentChunk;
			CurrentChunk = currentChunk;

			Debug.Log("Change Chunk: " + currentChunk.MinX() + "," + currentChunk.MinY() + "," + currentChunk.MaxX() + "," + currentChunk.MaxY());

			// Unload previousChunk (including neighbours)
			if(previousChunk != null)
			{
				previousChunk.UnLoad();
			}

			// Load currentChunk (including neighbours)
			currentChunk.Load(this);
		}
	}
}
