using Assets.Scripts.ScriptableObjects;
using System.Collections.Generic;

namespace Assets.Scripts.Data_Types
{
    public class LoadedChunks
    {
        public Coordinates lowerLeft; // The location in the lower left corner of this chunk array
        public Chunk[,] chunkArray;
        public HashSet<Chunk> chunkSet;
        public bool hasLoaded = false;

        /* PRIVATE FIELDS */

        /* CONSTRUCTORS */

        public LoadedChunks(World world)
        {
            chunkArray = new Chunk[world.LoadedChunkWidth, world.LoadedChunkWidth];
            chunkSet = new HashSet<Chunk>();
        }
    }
}