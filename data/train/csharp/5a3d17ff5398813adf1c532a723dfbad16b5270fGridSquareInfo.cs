using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GridSquareInfo : MonoBehaviour {
    public Vector2[] neighborOffsets;

    public Color[] chunkColorValues;

    public Color ourColor;
    public int chunkIndex = 0;
    public int nextChunkIndex;

    public void setChunkColor(int chunkIndex)
    {
        this.chunkIndex = chunkIndex;
        nextChunkIndex = chunkIndex;
        ourColor = chunkColorValues[chunkIndex];
        GetComponent<Renderer>().material.color = ourColor;
    }

    void LateUpdate()
    {
        if (nextChunkIndex != chunkIndex)
        {
            setChunkColor(nextChunkIndex);
        }
    }
   
}
