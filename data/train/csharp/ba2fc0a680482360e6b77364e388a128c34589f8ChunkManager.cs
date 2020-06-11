using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Hosting;

namespace MsgQueue.Storage
{
    internal class ChunkManager
    {
        private readonly object _lockObj = new object();
        public string ChunkPath { get; set; }

        public ChunkManager()
        {
            ChunkPath = HostingEnvironment.MapPath(ChunkManagerConfig.BasePath);
        }

        /// <summary>
        /// 程序第一个执行初始化Chunk
        /// </summary>
        /// <returns></returns>
        public Chunk InitNewChunk()
        {
            return GetNewChunkStrategy(null);
        }

        /// <summary>
        /// 获取一个新的Chunk Strategy
        /// </summary>
        /// <param name="chunk"></param>
        /// <returns></returns>
        public Chunk GetNewChunkStrategy(Chunk chunk)
        {
            lock (_lockObj)
            {
                int num = 0;
                if (chunk != null)
                {
                    num = Convert.ToInt32(chunk.ChunkFileName.Split('.')[0].Split('_')[1]);
                }

                string fileName = string.Format(ChunkManagerConfig.FileNamingStrategy, num + 1) +
                                  ChunkManagerConfig.FileNameSuffix;

                if (chunk != null)
                {
                    chunk.ChunkFileName = fileName;

                    return chunk;
                }
                return new Chunk
                {
                    IsCompleted = false,
                    ChunkSize = 0,
                    ChunkFileName = fileName,
                    ChunkPath = ChunkPath
                };
            }
        }

        /// <summary>
        /// 获取最后一个Chunk
        /// </summary>
        /// <returns></returns>
        public Chunk GetLastChunk()
        {
            lock (_lockObj)
            {
                var fileInfo =
                    new DirectoryInfo(ChunkPath).GetFiles()
                        .OrderByDescending(x => x.LastWriteTime)
                        .FirstOrDefault();

                if (fileInfo == null)
                {
                    return InitNewChunk();
                }

                var chunk = new Chunk();

                if (fileInfo.Length > ChunkManagerConfig.ChunkDataSize ||
                    fileInfo.LastWriteTime.AddHours(ChunkManagerConfig.DataSynchronousHours) < DateTime.Now)
                {
                    chunk.IsCompleted = true;

                    File.SetAttributes(ChunkPath + fileInfo.Name, FileAttributes.ReadOnly);
                }
                chunk.ChunkPath = ChunkPath;
                chunk.ChunkSize = fileInfo.Length;
                chunk.ChunkFileName = fileInfo.Name;
                return chunk;
            }
        }

        /// <summary>
        /// 删除Chunk
        /// </summary>
        /// <param name="fileName"></param>
        public void DeleteChunk(string fileName)
        {
            File.SetAttributes(ChunkPath + fileName, FileAttributes.Normal);
            File.Delete(ChunkPath + fileName);
        }
    }
}
