namespace Veeam.IntroductoryAssignment.FileChunkManaging.Splitting
{
    internal class FileSplitInfo
    {
        private readonly long _chunkCount;
        private readonly FileChunkInfo[] _chunks;

        public FileSplitInfo(long chunkCount)
        {
            _chunkCount = chunkCount;
            _chunks = new FileChunkInfo[chunkCount];
        }

        public long ChunkCount
        {
            get { return _chunkCount; }
        }

        public FileChunkInfo[] Chunks
        {
            get { return _chunks; }
        }
    }
}
