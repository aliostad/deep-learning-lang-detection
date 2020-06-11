using UnityEngine;
using System.Collections.Generic;

public class MapChunkHandler : MonoBehaviour {

    List<MapChunk> chunks = new List<MapChunk>();

	// Use this for initialization
	public void createChunks(List<WavesAndWeights> wavesAndWeights, Transform mapTransform, int chunkSize) {
        //Select all positions, 0-8, nice and clean way to see what's being loaded
        List<MapChunkPosition> positions = new List<MapChunkPosition>()
        {
            MapChunkPosition.MIDDLE,
            MapChunkPosition.LEFT,
            MapChunkPosition.RIGHT,
            MapChunkPosition.TOP,
            MapChunkPosition.BOTTOM,
            MapChunkPosition.TOP_RIGHT,
            MapChunkPosition.TOP_LEFT,
            MapChunkPosition.BOTTOM_RIGHT,
            MapChunkPosition.BOTTOM_LEFT,
        };


        foreach(var position in positions)
        {
            //Create a chunk for each position using the waves + weights system
            buildChunk(wavesAndWeights, mapTransform, chunkSize, position);
        }
    }

    void buildChunk(List<WavesAndWeights> wavesAndWeights, Transform mapTransform, int chunkSize, MapChunkPosition position)
    {
        //Get the position with the specified offset offset
        IntVector2 offset = MapChunkDirection.getVectorDirection(position, chunkSize * 2);

        //Create the chunk game object
        GameObject chunkObject = new GameObject();
        buildChunkCollider(chunkObject, chunkSize, offset, position);
        MapChunk chunk = buildChunkScript(chunkObject, chunkSize, offset, position, wavesAndWeights, mapTransform);

        //Add to list of current chunks
        chunks.Add(chunk);
    }

    void buildChunkCollider(GameObject chunkObject, int chunkSize, IntVector2 offset, MapChunkPosition position)
    {
        if (position.Equals(MapChunkPosition.TOP) ||
           position.Equals(MapChunkPosition.BOTTOM) ||
           position.Equals(MapChunkPosition.LEFT) ||
           position.Equals(MapChunkPosition.RIGHT))
        {
            //Build chunk collider, this will be used to trigger the chunk handler's chunk mover
            BoxCollider2D collider = chunkObject.AddComponent<BoxCollider2D>();
            collider.isTrigger = true;
            collider.size = new Vector3(chunkSize * 2, chunkSize * 2);
            collider.offset = new Vector3(offset.x, offset.y);
        }
    }

    //Create a map chunk at a specific position
    MapChunk buildChunkScript(GameObject chunkObject, int chunkSize, IntVector2 offset, MapChunkPosition position, List<WavesAndWeights> wavesAndWeights, Transform mapTransform)
    {
        MapChunk chunk = chunkObject.AddComponent<MapChunk>();
        chunk.build(chunkSize, offset, wavesAndWeights, mapTransform);
        chunk.setPosition(position);

        return chunk;
    }

    // Update is called once per frame
    void Update () {
	}
}
