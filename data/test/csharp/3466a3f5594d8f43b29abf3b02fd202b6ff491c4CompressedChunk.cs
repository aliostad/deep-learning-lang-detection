using System;
using System.Runtime.Serialization;

namespace BusinessLayer.Entities.Chunking
{
    [Serializable]
    public class CompressedChunk : ISerializable
    {
        private readonly byte[] _fileChecksum;
        private readonly byte[] _compressedChunk;
        private readonly int _size;
        private readonly int _chunkNum;
        private readonly byte[] _chunkChecksum;

        public CompressedChunk(byte[] fileChecksum, byte[] chunkChecksum, byte[] compressedChunk, int chunkNum)
        {
            _fileChecksum = fileChecksum;
            _chunkChecksum = chunkChecksum;
            _compressedChunk = compressedChunk;
            _chunkNum = chunkNum;
            _size = compressedChunk.Length;
        }

        public byte[] GetFileChecksum()
        {
            return _fileChecksum;
        }

        public byte[] GetChunkChecksum()
        {
            return _chunkChecksum;
        }

        public byte[] GetCompressedChunk()
        {
            return _compressedChunk;
        }

        public int GetSize()
        {
            return _size;
        }

        public int GetChunkNum()
        {
            return _chunkNum;
        }

        public void GetObjectData(SerializationInfo info, StreamingContext context)
        {
            info.AddValue("cChunkFileChecksum", _fileChecksum, typeof(byte[]));
            info.AddValue("cChunkCompChunk", _compressedChunk, typeof(byte[]));
            info.AddValue("cChunkSize", _size, typeof(int));
            info.AddValue("cChunkChunkNum", _chunkNum, typeof(int));
            info.AddValue("cChunkChunkChecksum", _chunkChecksum, typeof(byte[]));
        }

        public CompressedChunk(SerializationInfo info, StreamingContext context)
        {
            _fileChecksum = (byte[])info.GetValue("cChunkFileChecksum", typeof(byte[]));
            _compressedChunk = (byte[]) info.GetValue("cChunkCompChunk", typeof (byte[]));
            _size = (int)info.GetValue("cChunkSize", typeof(int));
            _chunkNum = (int)info.GetValue("cChunkChunkNum", typeof(int));
            _chunkChecksum = (byte[])info.GetValue("cChunkChunkChecksum", typeof(byte[]));
        }
    }
}
