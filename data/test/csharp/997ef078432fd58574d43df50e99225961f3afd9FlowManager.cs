using System.Web;
using Adborroto.FlowJs.Chunk;
using Adborroto.FlowJs.Chunk.Binder;
using Adborroto.FlowJs.Error;
using Adborroto.FlowJs.Result;

namespace Adborroto.FlowJs
{
    public class FlowManager:IFlowManager
    {
        private readonly IChunkBinder _chunkBinder;
        private readonly IChunkNameGenerator _chunkNameGenerator;
        private readonly IFileManager _fileManager;

        public FlowManager(
            IChunkBinder chunkBinder,
            IChunkNameGenerator chunkNameGenerator,
            IFileManager fileManager)
        {
            _chunkBinder = chunkBinder;
            _chunkNameGenerator = chunkNameGenerator;
            _fileManager = fileManager;
        }

        public virtual ValueResult<ChunkStatus> Post(HttpRequest request)
        {
            var chunkResult = _chunkBinder.Parse(request.Form);
            if (!chunkResult.Sucess)
                return ValueResult<ChunkStatus>.Failed(chunkResult.Errors);

            if (request.Files.Count != 0)
                return ValueResult < ChunkStatus > .Failed(new InvalidFileApplicationError("No file in the http request"));
            var file = request.Files[0];

            var chunkUniqueNameTemp = _chunkNameGenerator.Generate(chunkResult.Result);
            _fileManager.Copy(file.InputStream, chunkUniqueNameTemp);

            //Rename when file copy is done
            var chunkUniqueName = _chunkNameGenerator.Generate(chunkResult.Result);
            _fileManager.Rename(chunkUniqueNameTemp, chunkUniqueName);

            if (IsFileUploadComplete(chunkResult.Result))
            {
                MergeFile(chunkResult.Result);
                return ValueResult<ChunkStatus>.Successed(ChunkStatus.Last);
            }

            return ValueResult<ChunkStatus>.Successed(ChunkStatus.Chunk);
        }

        #region Helpers

        private bool IsFileUploadComplete(Chunk.Chunk chunk)
        {

            for (var chunkNumber = 1; chunkNumber <= chunk.TotalChunks; chunkNumber++)
            {
                var chunkUniqueName = _chunkNameGenerator.Generate(chunk.FileName, chunk.Identifier, chunkNumber);
                if (!_fileManager.Exits(chunkUniqueName))
                    return false;
            }
            return true;
        }

        private void MergeFile(Chunk.Chunk chunk)
        {
            var finalFile = _fileManager.Create(chunk.FileName);

            for (var chunkNumber = 1; chunkNumber <= chunk.TotalChunks; chunkNumber++)
            {
                var chunkUniqueName = _chunkNameGenerator.Generate(chunk.FileName, chunk.Identifier, chunkNumber);
                var chunkFile = _fileManager.Read(chunkUniqueName);
                chunkFile.CopyTo(finalFile);

                _fileManager.Delete(chunkUniqueName);
            }

        }

        #endregion
       
    }
}
