using UnityEngine;

//ChunkLocation is a subclass of Location where every inputed coordinate is 16 times bigger than the given coordinate, to 
//account for chunk sizes
public class ChunkLocation : Location {

    //Initialise the location at the world and the x.y,z coordinates
    public ChunkLocation(World world, float x, float y, float z) : base(world, x, y, z) {

        //Set the x and y values to 16 times their inputed value, the z coordinate doesn't need to be changed
        setX(x * Chunk.chunkSize);
        setZ(z * Chunk.chunkSize);

    }

    //Perform the same procedure, but this time a location variable is inputed
    public ChunkLocation(Location location) : base(location) {

        float x = location.getX();
        float z = location.getZ();

        setX(x * Chunk.chunkSize);
        setZ(z * Chunk.chunkSize);

    }

    public static ChunkLocation asChunkLocation(Location location) {

        World world = location.getWorld();
        float x = location.getX();
        float z = location.getZ();

        x = (x - (x % 16)) / 16f;
        z = (z - (z % 16)) / 16f;

        return new ChunkLocation(world, x, 0, z);

    }

    public static ChunkLocation operator +(ChunkLocation chunkLocation1, ChunkLocation chunkLocation2) {
        Location location1 = chunkLocation1;
        Location location2 = chunkLocation2;
        return ChunkLocation.asChunkLocation(location1 + location2);
    }

    public static ChunkLocation operator -(ChunkLocation chunkLocation1, ChunkLocation chunkLocation2) {
        Location location1 = chunkLocation1;
        Location location2 = chunkLocation2;
        return ChunkLocation.asChunkLocation(location1 - location2);
    }

}