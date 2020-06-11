using System;

namespace MapReader.Objects
{
    public class BaseMapPortion
    {
        protected uint _chunkSize;
        protected uint _chunkOffset;
        protected byte[] _chunkData;

        public uint ChunkSize()
        {
            return _chunkSize;
        }

        public uint ChunkOffset()
        {
            return _chunkOffset;
        }
        
        public BaseMapPortion()
        {
            _chunkSize = 0;
        }

        public virtual void Load(byte[] chunk)
        {
            _chunkData = chunk;
        }

        protected uint ReadUint32(uint offset)
        {
            return HaloMap.ReadUint32(_chunkData, offset);
        }
    }
}
