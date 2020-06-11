using UnityEngine;
using System.Collections;

public static class LVoxel
{
    public static bool VoxelExists(World world, ChunkGenerator detectionChunk, Voxel detectionVoxel, int x, int y, int z)
    {
        if (detectionChunk.numID.x * world.chunkSize.x + detectionVoxel.numID.x + x >= 0 &&
            detectionChunk.numID.x * world.chunkSize.x + detectionVoxel.numID.x + x < world.chunkNumber.x * world.chunkSize.x &&
            detectionChunk.numID.y * world.chunkSize.y + detectionVoxel.numID.y + y >= 0 &&
            detectionChunk.numID.y * world.chunkSize.y + detectionVoxel.numID.y + y < world.chunkNumber.y * world.chunkSize.y &&
            detectionChunk.numID.z * world.chunkSize.z + detectionVoxel.numID.z + z >= 0 &&
            detectionChunk.numID.z * world.chunkSize.z + detectionVoxel.numID.z + z < world.chunkNumber.z * world.chunkSize.z)
            return true;
        else
            return false;
    }


    public static void GetVoxel(World world, ref ChunkGenerator detectionChunk, ref Voxel detectionVoxel, int x, int y, int z)
    {
        int cx, cy, cz;
        int vx, vy, vz;


        // Voxel adapt
        vx = detectionVoxel.numID.x + x;
        vy = detectionVoxel.numID.y + y;
        vz = detectionVoxel.numID.z + z;

        // Chunk adapt
        cx = detectionChunk.numID.x;
        cy = detectionChunk.numID.y;
        cz = detectionChunk.numID.z;


        // slices
        if (vx == world.chunkSize.x)
        {
            cx++;
            vx = 0;
        }
        else if (vx < 0)
        {
            cx--;
            vx = world.chunkSize.x - 1;
        }

        if (vy == world.chunkSize.y)
        {
            cy++;
            vy = 0;
        }
        else if (vy < 0)
        {
            cy--;
            vy = world.chunkSize.y - 1;
        }

        if (vz == world.chunkSize.z)
        {
            cz++;
            vz = 0;
        }
        else if (vz < 0)
        {
            cz--;
            vz = world.chunkSize.z - 1;
        }

        detectionChunk = world.chunk[cx, cy, cz];
        detectionVoxel = detectionChunk.voxel[vx, vy, vz];
    }
}
