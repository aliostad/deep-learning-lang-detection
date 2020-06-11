namespace Common
{
    /// <summary>
    /// Represents a chunk of a file.
    /// </summary>
    public class Chunk
    {
        public readonly byte[] ChunkInformation;
        public readonly string ChunkHash;
        public readonly long FileChunkNumber;

        /// <summary>
        /// Initializes a new instance of the <see cref="Chunk"/> class.
        /// </summary>
        public Chunk(byte[] chunkInformation, long fileChunkNumber)
        {
            ChunkInformation = chunkInformation;
            FileChunkNumber = fileChunkNumber;
            ChunkHash = chunkInformation.CalculateSha256Hash();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="Chunk"/> class.
        /// </summary>
        public Chunk(string chunkHash, byte[] chunkInformation, long cachedFileChunkLocation)
        {
            ChunkHash = chunkHash;
            ChunkInformation = chunkInformation;
            FileChunkNumber = cachedFileChunkLocation;
        }
    }
}
