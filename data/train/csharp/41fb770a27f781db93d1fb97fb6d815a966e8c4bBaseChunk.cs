namespace MidiBacon
{
    public abstract class BaseChunk
    {
        private char[] _chunkID;

        public char[] ChunkID
        {
            get { return _chunkID; }
            set { _chunkID = value; }
        }

        private uint _chunkSize;

        public uint ChunkSize
        {
            get { return _chunkSize; }
            set { _chunkSize = value; }
        }

        private MidiFile _file;

        public MidiFile File
        {
            get { return _file; }
            set { _file = value; }
        }

        public virtual uint GetSizeInBytes()
        {
            return 0;
        }
    }
}