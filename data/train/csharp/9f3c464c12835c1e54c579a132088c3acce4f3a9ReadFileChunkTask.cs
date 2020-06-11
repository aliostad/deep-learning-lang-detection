using Veeam.IntroductoryAssignment.Common;
using Veeam.IntroductoryAssignment.FileChunkManaging;

namespace Veeam.IntroductoryAssignment.Tasks
{
    class ReadFileChunkTask : ObservableTask
    {
        private readonly FileChunk _fileChunk;

        public ReadFileChunkTask(FileChunk fileChunk, ITaskCompletionObserver fileConverter)
            : base(fileConverter)
        {
            _fileChunk = fileChunk;
        }

        public override void Execute()
        {
            _fileChunk.ReadData();
            Observer.HandleTaskCompletion(_fileChunk);
        }
    }
}
