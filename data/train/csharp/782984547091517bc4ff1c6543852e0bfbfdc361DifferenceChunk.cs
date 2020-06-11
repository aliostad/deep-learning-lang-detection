namespace Server.Core
{
    public class DifferenceChunk
    {
        public readonly byte[] ChunkInformation;
        public readonly long CurentFileChunkNumber;
        public readonly long CachedFileChunkNumber;

        public DifferenceChunk(byte[] chunkInformation, long curentFileChunkNumber, long cachedFileChunkNumber)
        {
            ChunkInformation = chunkInformation;
            CurentFileChunkNumber = curentFileChunkNumber;
            CachedFileChunkNumber = cachedFileChunkNumber;
        }
    }
}