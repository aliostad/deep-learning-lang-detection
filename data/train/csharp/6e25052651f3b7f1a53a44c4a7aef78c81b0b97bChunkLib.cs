using UnityEngine;
using System.Collections;

public class ChunkLib
{
    public static bool ChunkExists(World world, Chunk detectionChunk, int x, int y, int z)
    {
        if (detectionChunk.numID.x + x < world.chunkNumber.x &&
            detectionChunk.numID.x + x >= 0 &&
            detectionChunk.numID.y + y < world.chunkNumber.y &&
            detectionChunk.numID.y + y >= 0 &&
            detectionChunk.numID.z + z < world.chunkNumber.z &&
            detectionChunk.numID.z + z >= 0)
            return true;
        else
            return false;
    }


    public static bool ChunkExists(World world, IntVector3 numID)
    {
        if (numID.x < world.chunkNumber.x &&
            numID.x >= 0 &&
            numID.y < world.chunkNumber.y &&
            numID.y >= 0 &&
            numID.z < world.chunkNumber.z &&
            numID.z >= 0)
            return true;
        else
            return false;
    }


    public static void Reset(World world, Chunk detectionChunk, Voxel detectionVoxel)
    {
        int xSign, ySign, zSign;

        // Resets the nearer chunks
        if (detectionVoxel.numID.x < world.chunkSize.x / 2)
            xSign = -1;
        else
            xSign = 1;

        if (detectionVoxel.numID.y < world.chunkSize.y / 2)
            ySign = -1;
        else
            ySign = 1;

        if (detectionVoxel.numID.z < world.chunkSize.z / 2)
            zSign = -1;
        else
            zSign = 1;

        // Selected chunk reset
        world.chunksToReset.Add(new IntVector3(detectionChunk.numID.x, detectionChunk.numID.y, detectionChunk.numID.z));

        // x alone
        if (ChunkLib.ChunkExists(world, detectionChunk, xSign, 0, 0))
            world.chunksToReset.Add(new IntVector3(detectionChunk.numID.x + xSign, detectionChunk.numID.y, detectionChunk.numID.z));

        // y alone
        if (ChunkLib.ChunkExists(world, detectionChunk, 0, ySign, 0))
            world.chunksToReset.Add(new IntVector3(detectionChunk.numID.x, detectionChunk.numID.y + ySign, detectionChunk.numID.z));

        // z alone
        if (ChunkLib.ChunkExists(world, detectionChunk, 0, 0, zSign))
            world.chunksToReset.Add(new IntVector3(detectionChunk.numID.x, detectionChunk.numID.y, detectionChunk.numID.z + zSign));

        // x and y
        if (ChunkLib.ChunkExists(world, detectionChunk, xSign, ySign, 0))
            world.chunksToReset.Add(new IntVector3(detectionChunk.numID.x + xSign, detectionChunk.numID.y + ySign, detectionChunk.numID.z));

        // x and z
        if (ChunkLib.ChunkExists(world, detectionChunk, xSign, 0, zSign))
            world.chunksToReset.Add(new IntVector3(detectionChunk.numID.x + xSign, detectionChunk.numID.y, detectionChunk.numID.z + zSign));

        // y and z
        if (ChunkLib.ChunkExists(world, detectionChunk, 0, ySign, zSign))
            world.chunksToReset.Add(new IntVector3(detectionChunk.numID.x, detectionChunk.numID.y + ySign, detectionChunk.numID.z + zSign));

        // x, y and z
        if (ChunkLib.ChunkExists(world, detectionChunk, xSign, ySign, zSign))
            world.chunksToReset.Add(new IntVector3(detectionChunk.numID.x + xSign, detectionChunk.numID.y + ySign, detectionChunk.numID.z + zSign));
    }
}
