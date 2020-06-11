﻿using ECommon.Components;
using ECommon.Scheduling;
using ECommon.Utilities;
using EQueue.Broker.Storage.LogRecords;

namespace EQueue.Broker.Storage
{
    public class ChunkWriter
    {
        public Chunk CurrentChunk { get { return _currentChunk; } }

        private readonly ChunkManager _chunkManager;
        private readonly IScheduleService _scheduleService;
        private readonly object _lockObj = new object();
        private bool _isClosed = false;

        private Chunk _currentChunk;

        public ChunkWriter(ChunkManager chunkManager)
        {
            Ensure.NotNull(chunkManager, "chunkManager");

            _chunkManager = chunkManager;
            _scheduleService = ObjectContainer.Resolve<IScheduleService>();
        }

        public void Open()
        {
            _currentChunk = _chunkManager.GetLastChunk();

            if (!_chunkManager.Config.SyncFlush)
            {
                _scheduleService.StartTask("FlushChunk", Flush, 1000, _chunkManager.Config.FlushChunkIntervalMilliseconds);
            }

            _isClosed = false;
        }
        public long Write(ILogRecord record)
        {
            lock (_lockObj)
            {
                if (_isClosed)
                {
                    throw new ChunkWriteException(_currentChunk.ToString(), "Chunk writer is closed.");
                }

                //如果当前文件已经写完，则需要新建文件
                if (_currentChunk.IsCompleted)
                {
                    _currentChunk = _chunkManager.AddNewChunk();
                }

                //先尝试写文件
                var result = _currentChunk.TryAppend(record);

                //如果当前文件已满
                if (!result.Success)
                {
                    //结束当前文件
                    _currentChunk.Complete();

                    //新建新的文件
                    _currentChunk = _chunkManager.AddNewChunk();

                    //再尝试写入新的文件
                    result = _currentChunk.TryAppend(record);

                    //如果还是不成功，则报错
                    if (!result.Success)
                    {
                        throw new ChunkWriteException(_currentChunk.ToString(), "Write record to chunk failed.");
                    }
                }

                //如果需要同步刷盘，则立即同步刷盘
                if (_chunkManager.Config.SyncFlush)
                {
                    _currentChunk.Flush();
                }

                //返回数据写入位置
                return result.Position;
            }
        }
        public void Close()
        {
            lock (_lockObj)
            {
                _scheduleService.StopTask("FlushChunk");
                _currentChunk = null;
                _isClosed = true;
            }
        }
        private void Flush()
        {
            lock (_lockObj)
            {
                if (_isClosed) return;
                if (_currentChunk == null || _currentChunk.IsCompleted) return;

                _currentChunk.Flush();
            }
        }
    }
}
