using OceanChip.Common.Components;
using OceanChip.Common.Scheduling;
using OceanChip.Common.Storage.Exceptions;
using OceanChip.Common.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OceanChip.Common.Storage
{
    public class ChunkWriter
    {
        private const string SchdeuleName= "FlushChunk";
        public Chunk CurrentChunk => _currentChunk;

        private readonly ChunkManager _chunkManager;
        private readonly IScheduleService _scheduleService;
        private readonly object _lockSync = new object();
        private bool _isClosed = false;

        private Chunk _currentChunk;

        public ChunkWriter(ChunkManager manager)
        {
            Check.NotNull(manager, nameof(manager));

            this._chunkManager = manager;
            this._scheduleService = ObjectContainer.Resolve<IScheduleService>();
        }
        public void Open()
        {
            _currentChunk = _chunkManager.GetLastChunk();

            if (!_chunkManager.IsMemoryMode && !_chunkManager.Config.SyncFlush)
                _scheduleService.StartTask(SchdeuleName, Flush, 1000, _chunkManager.Config.FlushChunkIntervalMilliseconds);

            _isClosed = false;
        }
        public long Write(ILogRecord record)
        {
            lock (_lockSync)
            {
                if (_isClosed)
                    return -1L;

                if (_currentChunk.IsCompleted)
                    _currentChunk = _chunkManager.AddNewChunk();

                var result = _currentChunk.TryAppend(record);
                if (!result.Success)//文件已满
                {
                    //结束当前文件
                    _currentChunk.Complete();
                    //新建文件
                    _currentChunk = _chunkManager.AddNewChunk();

                    result = _currentChunk.TryAppend(record);//重新写文件
                    if (!result.Success)
                        throw new ChunkWriteException(this.ToString(), "写记录失败");
                }

                if(!_chunkManager.IsMemoryMode && _chunkManager.Config.SyncFlush)
                {
                    _currentChunk.Flush();
                }
                return result.Position;
            }
        }
        public void Close()
        {
            lock (_lockSync)
            {
                if (!_chunkManager.IsMemoryMode && _currentChunk != null)
                    _currentChunk.Flush();
                if (!_chunkManager.IsMemoryMode && !_chunkManager.Config.SyncFlush)
                    _scheduleService.StopTask(SchdeuleName);
                _currentChunk = null;
                _isClosed = true;
            }
        }
        private void Flush()
        {
            lock (_lockSync)
            {
                if (_isClosed) return;
                if (_currentChunk == null || _currentChunk.IsCompleted) return;

                _currentChunk.Flush();
            }
        }
    }
}
