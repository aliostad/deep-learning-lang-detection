using System;
using System.IO;

namespace BitAuto.HMC.ServiceBus.MessageLib.Storage
{
    internal class ChunkManager : IDisposable
    {
        private readonly object _lock;
        private readonly int _maxChunkSize;

        private readonly DirectoryInfo _directory;
        private readonly ChunkNameManager _chunkNameManager;
        private readonly IRecordProtocol _protocol;
        private readonly IChunkConsumeOffset _offset;

        private long _lastOffsetPosition;
        private ReadWriteChunk _writerChunk;
        private Chunk _readerChunk;


        public ChunkManager(int maxChunkSize, DirectoryInfo directory, IRecordProtocol protocol, IChunkConsumeOffset offset)
        {
            _lock = new object();
            _maxChunkSize = maxChunkSize;
            _directory = directory;
            _chunkNameManager = new ChunkNameManager(directory.FullName);
            _protocol = protocol;
            _offset = offset;

            InitWriterChunk();
            InitReaderChunk();
        }

        private void InitWriterChunk()
        {
            var chunkName = default(ChunkName);

            if (!_chunkNameManager.TryGetLast(out chunkName))
            {
                chunkName = _chunkNameManager.CreateNext();
                _writerChunk = ReadWriteChunk.CreateNew(chunkName, _maxChunkSize, _protocol);
            }
            else
            {
                _writerChunk = ReadWriteChunk.InitOnGoing(chunkName, _protocol);
            }

            if (_writerChunk.IsCompleted)
            {
                chunkName = _chunkNameManager.CreateNext();
                _writerChunk = ReadWriteChunk.CreateNew(chunkName, _maxChunkSize, _protocol);
            }
        }

        private void InitReaderChunk()
        {
            var chunkName = default(string);
            var position = default(long);
            var readerChunkName = default(ChunkName);

            if (_offset.TryRead(out chunkName, out position) && _chunkNameManager.TryParse(chunkName, out readerChunkName))
            {
                _lastOffsetPosition = position;
                _readerChunk = new Chunk(readerChunkName, _protocol);
            }
            else if (_chunkNameManager.TryGetFirst(out readerChunkName))
            {
                _lastOffsetPosition = ChunkHeader.Size;
                _readerChunk = new Chunk(readerChunkName, _protocol);
            }
            else
            {
                throw new Exception("无法读取chunk信息");
            }
        }

        public long Write(byte[] value)
        {
            lock (_lock)
            {
                var result = _writerChunk.Write(value);

                if (result == ChunkWriteResult.NotEnoughSpace)
                {
                    var chunkName = (ChunkName)null;
                    _writerChunk.Complete();
                    _writerChunk.Dispose();
                    chunkName = _chunkNameManager.CreateNext();
                    _writerChunk = ReadWriteChunk.CreateNew(chunkName, _maxChunkSize, _protocol);
                    result = _writerChunk.Write(value);
                }

                return result.Position;
            }
        }

        public byte[] Read()
        {
            lock (_lock)
            {
                var nextOffsetPosition = 0L;
                var buffer = Read(_lastOffsetPosition, out nextOffsetPosition);
                if (nextOffsetPosition != 0)
                {
                    _lastOffsetPosition = nextOffsetPosition;
                }
                return buffer;
            }
        }

        internal byte[] Read(long position, out long nextPosition)
        {
            var record = (byte[])null;
            var readResult = _readerChunk.TryRead(position, out nextPosition, out record);

            if (readResult == ChunkReadResult.Success)
            {
                _offset.Write(_readerChunk.ChunkName.ToString(), nextPosition);
                return record;
            }

            //如果已经到达了流的末尾，那么尝试加载并读取下一个chunk
            //这里需要区别：`流的末尾`与`文件的末尾`，流的末尾有可能是文件的末尾，也有可能是写入流的最新位置
            if (readResult == ChunkReadResult.EndOfStream)
            {
                var nextReaderChunk = default(ChunkName);
                if (_chunkNameManager.TryGetNext(_readerChunk.ChunkName, out nextReaderChunk))
                {
                    _readerChunk.Dispose();
                    _readerChunk = new Chunk(nextReaderChunk, _protocol);

                    position = ChunkHeader.Size;//需要重置position
                    if (_readerChunk.TryRead(position, out nextPosition, out record) == ChunkReadResult.Success)
                    {
                        return record;
                    }
                }
            }

            return record;
        }

        public void Dispose()
        {
            _writerChunk.Dispose();
            _readerChunk.Dispose();
        }
    }
}

