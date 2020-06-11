using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Metrics : MonoBehaviour {
    public const int chunkSizeX = 20, chunkSizeZ = 20;
    public const int chunkCountX = 3, chunkCountZ = 3;
    public const float scale = 1f;
    public const float verticalScale = 1f;
    public static float getVScale()
    {
        return scale * verticalScale;
    }
    public static int xBlocks()
    {
        return chunkSizeX * chunkCountX;
    }
    public static int zBlocks()
    {
        return chunkSizeZ* chunkCountZ;
    }
    public static int chunkCount()
    {
        return chunkCountX * chunkCountZ;
    }
    //public static float width() {
    //    return chunkSizeX * chunkCountX * scale;
    //}
    //public static int height() {
    //    return chunkSizeX * chunkCountX * scale;
    //}
}
