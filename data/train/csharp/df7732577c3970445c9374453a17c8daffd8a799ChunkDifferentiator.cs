using System.Collections.Generic;
using System.Linq;
using Common;

namespace Server.Core
{
    public static class ChunkDifferentiator
    {
        public static IEnumerable<DifferenceChunk> GetUpdatedChunks(List<Chunk> chunksFromCachedFile, List<Chunk> chunksFromCurrentFile)
        {
            List<DifferenceChunk> differenceChunks = new List<DifferenceChunk>(chunksFromCurrentFile.Count);

            foreach (Chunk currentChunk in chunksFromCurrentFile)
            {
                Chunk cachedChunk = chunksFromCachedFile.FirstOrDefault(x => x.ChunkHash.Equals(currentChunk.ChunkHash));
                DifferenceChunk differenceChunk;
                if (cachedChunk == null)
                    differenceChunk = new DifferenceChunk(currentChunk.ChunkInformation, currentChunk.FileChunkNumber, -1);
                else
                    differenceChunk = new DifferenceChunk(new byte[0], currentChunk.FileChunkNumber, cachedChunk.FileChunkNumber);
                differenceChunks.Add(differenceChunk);
            }

            return differenceChunks;
        }
    }
}
