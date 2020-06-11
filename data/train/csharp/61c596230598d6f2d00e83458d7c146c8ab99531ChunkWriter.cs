using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Hosting;

namespace MsgQueue.Storage
{
    public class ChunkWriter
    {
        private readonly object _lockObj = new object();
        private readonly ChunkManager _chunkManager;
        private Chunk _currentChunk;
        public ChunkWriter()
        {
            _chunkManager = new ChunkManager();
            _currentChunk = new Chunk();
        }

        /// <summary>
        /// 写入内容
        /// </summary>
        /// <param name="json">JSON内容</param>
        /// <returns></returns>
        public bool Write(string json)
        {
            bool result;

            lock (_lockObj)
            {
                _currentChunk = _chunkManager.GetLastChunk();

                //如果当前文件已经写完，则需要新建文件
                if (_currentChunk.IsCompleted)
                {
                    _currentChunk = _chunkManager.GetNewChunkStrategy(_currentChunk);
                }

                result = _currentChunk.TryAppend(json);
            }
            return result;
        }
    }
}
