using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JobProcessor.Model;

namespace JobProcessor.Interfaces
{
    public interface IJobChunkRegistrator
    {
        void RegisterNewMapChunk(JobChunkUid chunkUid);
        void RegisterNewReduceChunk(JobChunkUid chunkUid);
        void UpdateChunkMapSent(JobChunkUid chunkUid);
        void UpdateChunkMapComplete(JobChunkUid chunkUid);
        void UpdateChunkReduceSent(JobChunkUid chunkUid);
        void UpdateChunkReduceComplete(JobChunkUid chunkUid);

        event Action<object, string> JobMapComplete;
        event Action<object, string> JobReduceComplete;
    }
}
