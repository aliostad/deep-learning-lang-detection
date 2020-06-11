using System;
using System.Linq;

using Podcatcher.FileSaver;
using Podcatcher.Downloader;
using System.Threading.Tasks;
using Podcatcher.Domain;
using System.IO;

namespace Podcatcher.Manager
{
    public class FileDownload
    {
        public delegate void ChunkSavedEventHandler(FileDownload sender, IChunk chunk);

        public event ChunkSavedEventHandler ChunkSaved;

        public string SourceLink { get; private set; }
        public string Destination { get; private set; }

        public int ChunkLength { get; set; } = 1024 * 512;

        /// <summary>
        /// Gets or sets expected content length.
        /// 
        /// This should be supplied the caller, it is not
        /// found during web calls. This is value is not
        /// used during download and the actual file may be
        /// greater or less than this value.
        /// </summary>
        public int ContentLength { get; set; }

        public IChunkedDownloader ChunkDownloader { get; set; }
        public ChunkSaver ChunkSaver { get; set; }

        public bool Complete { get; private set; }

        public FileDownload(string sourceLink, string destination)
        {
            SourceLink = sourceLink;
            Destination = CleanFilename(destination);
            

            ChunkDownloader = new HttpChunkedDownloader() { Url = sourceLink };
            ChunkSaver = new ChunkSaver();

            Complete = false;
        }

        private string CleanFilename(string filename)
        {
            foreach (var c in Path.GetInvalidFileNameChars())
            {
                filename = filename.Replace(c, '-');
            }
            return filename;
        }

        public async Task<IChunk> DownloadChunk()
        {
            var chunkInfo = await ChunkSaver.GetNextEmptyChunk(Destination);

            var checkedChunkInfo = new ChunkInfo(
                chunkInfo.Start,
                Math.Min(ChunkLength, chunkInfo.Length)
            );
            var chunk = await ChunkDownloader.DownloadChunk(checkedChunkInfo);
            return chunk;
        }

        public async Task SaveChunk(IChunk chunk)
        {
            await ChunkSaver.SaveFile(Destination, chunk.Start, chunk.Data);
            if (ChunkSaved != null)
            {
                ChunkSaved.Invoke(this, chunk);
            }
        }

        public async Task DownloadAndSaveChunk()
        {
            var chunk = await DownloadChunk();
            if (chunk == null)
            {
                Complete = true;
            }
            else
            {
                await SaveChunk(chunk);
            }
        }

        public async Task<Stream> GetCompleteFileStream()
        {
            var stream = await ChunkSaver.CreateCombinedStream(Destination);
            return stream;
        }

        public async Task<int> GetBytesSavedCount()
        {
            var count = await ChunkSaver.GetBytesSavedCount(Destination);
            return count;
        }
    }
}
