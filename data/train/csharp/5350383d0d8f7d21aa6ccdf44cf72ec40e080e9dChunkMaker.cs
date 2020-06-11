using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class ChunkMaker : MonoBehaviour {

    public Transform ChunkPrefab;
    public float SquareSize = 1.0f;
    public int ChunkWidth = 50;
    public int ChunkHeight = 50;

    public List<Transform> Activators;
    public float ActivationDistance;

    [HideInInspector]
    public List<MapGenerator> Chunks;

    void Start()
    {

    }

    void Update()
    {
        ActivateChunks();
    }

    void ActivateChunks()
    {
        //get all the activators
        var relevantActivators = Activators.Where(
                                    x=>
                                    checkActivatorInActivationRange(x)
                                ).ToList();



    }

    private bool checkActivatorInActivationRange(Transform activator)
    {
        var chunkRelativeX = (activator.transform.position.x % (ChunkWidth * SquareSize)) - (ChunkWidth * SquareSize / 2);
        var chunkRelativeY = (activator.transform.position.x % (ChunkWidth * SquareSize)) - (ChunkWidth * SquareSize / 2);
        if (chunkRelativeX > ((ChunkWidth * SquareSize) / 2f) - ActivationDistance ||
            chunkRelativeX < ((ChunkWidth * SquareSize) / 2f) + ActivationDistance ||
            chunkRelativeY > ((ChunkHeight * SquareSize) / 2f) - ActivationDistance ||
            chunkRelativeY < ((ChunkHeight * SquareSize) / 2f) + ActivationDistance)
            return true;
        else
            return false;
    }

    private List<Vector2> getRelavantChunks(Transform activator)
    {
        var relavantChunks = new List<MapGenerator>();

        var CheckableAbsolutePositions = new List<Vector2>();

        var chunkRelativeX = ((activator.transform.position.x - transform.position.x) % (ChunkWidth * SquareSize)) - (ChunkWidth * SquareSize / 2f);
        var chunkRelativeY = ((activator.transform.position.x - transform.position.y) % (ChunkHeight * SquareSize)) - (ChunkHeight * SquareSize / 2f);
        var currChunkPosX = activator.transform.position.x - chunkRelativeX;
        var currChunkPosY = activator.transform.position.y - chunkRelativeY;

        CheckableAbsolutePositions.Add(new Vector2(currChunkPosX, currChunkPosY));


        bool right = false;
        bool left = false;
        bool bottom = false;
        bool top = false;
        //right
        if (chunkRelativeX > ((ChunkWidth * SquareSize) / 2f) - ActivationDistance) {
            CheckableAbsolutePositions.Add(new Vector2(currChunkPosX + (ChunkWidth * SquareSize), currChunkPosY));
            right = true;
        }
        //left
        if (chunkRelativeX < ActivationDistance)
        {
            CheckableAbsolutePositions.Add(new Vector2(currChunkPosX - (ChunkWidth * SquareSize), currChunkPosY));
            left = true;
        }
        //bottom
        if (chunkRelativeY > ((ChunkHeight * SquareSize) / 2f) - ActivationDistance)
        {
            CheckableAbsolutePositions.Add(new Vector2(currChunkPosX, currChunkPosY + (ChunkHeight * SquareSize)));
            bottom = true;
        }
        //top
        if (chunkRelativeY < ActivationDistance)
        {
            CheckableAbsolutePositions.Add(new Vector2(currChunkPosX, currChunkPosY - (ChunkHeight * SquareSize) ));
            top = true;
        }

        //top-right
        if(top && right)
        {
            CheckableAbsolutePositions.Add(new Vector2(currChunkPosX + (ChunkWidth * SquareSize), currChunkPosY - (ChunkHeight * SquareSize)));
        }

        return CheckableAbsolutePositions;

        //right side check
        //if (chunkRelativeX > ((ChunkWidth * SquareSize) / 2f) - ActivationDistance) {
        //    var relavantChunk =
        //        Chunks.Where(x =>
        //            Mathf.Abs(x.transform.position.y - activator.transform.position.y) < (ChunkHeight * SquareSize) / 2f
        //            &&
        //            x.transform.position.x > activator.transform.position.x
        //        )
        //        .OrderBy(x => x.transform.position.x)
        //        .FirstOrDefault();
        //    if (relavantChunk != null)
        //        relavantChunks.Add(relavantChunk);
        //}



    }

}
