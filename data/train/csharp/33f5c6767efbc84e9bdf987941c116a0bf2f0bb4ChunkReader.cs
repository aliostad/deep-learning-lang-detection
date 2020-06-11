using OceanChip.Common.Storage.Exceptions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OceanChip.Common.Storage
{
    public class ChunkReader
    {
        private readonly ChunkManager _chunkManager;
        private readonly ChunkWriter _chunkWriter;

        public ChunkReader(ChunkManager manager,ChunkWriter writer)
        {
            this._chunkManager = manager;
            this._chunkWriter = writer;
        }
        public T TryReadAt<T>(long position,Func<byte[],T> readRecordFunc,bool autoCache=true)where T :class, ILogRecord
        {
            var lastChunk = _chunkWriter.CurrentChunk;
            var maxPosition = lastChunk.GlobalDataPosition;
            if (position >= maxPosition)
                return null;

            var chunkNum = _chunkManager.GetChunkNum(position);
            var chunk = _chunkManager.GetChunk(chunkNum);
            if (chunk == null)
                throw new ChunkNotExistException(position, chunkNum);

            var localPosition = chunk.ChunkHeader.GetLocalDataPosition(position);
            return chunk.TryReadAt(localPosition, readRecordFunc, autoCache);
        }
    }
}
