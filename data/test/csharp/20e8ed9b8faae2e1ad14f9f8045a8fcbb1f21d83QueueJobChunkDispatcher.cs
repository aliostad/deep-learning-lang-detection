using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.WindowsAzure.StorageClient;
using JobProcessor;
using JobProcessor.Model;
using JobProcessor.Interfaces;

namespace JobProcessor.Implementation
{
    class QueueJobChunkDispatcher : IJobChunkDispatcher
    {
        #region Data Members
        private CloudQueue _queue;
        private IJobChunkRegistrator _jobChunkRegistrator;
        #endregion Data Members

        #region Ctor
        public QueueJobChunkDispatcher(IJobChunkRegistrator jobChunkRegistrator)
        {
            _jobChunkRegistrator = jobChunkRegistrator;
            _queue = AzureClient.Instance.QueueClient.GetQueueReference(RoleSettings.JobsChunksQueueName);
            _queue.CreateIfNotExist();
        }
        #endregion Ctor

        #region Public Methods
        public void Dispatch(JobChunk chunk)
        {
            var jsonChunk = chunk.ToJson();
            Logger.Log.Instance.Info(string.Format("QueueJobChunkDispatcher. Dispatch chunk. JobId '{0}', ChunkId '{1}', JSON:\n{2}",
                chunk.ChunkUid.JobId,
                chunk.ChunkUid.ChunkId,
                jsonChunk));
            _queue.AddMessage(new CloudQueueMessage(jsonChunk));
            if (chunk.Mode == ProcessingMode.Map)
            {
                _jobChunkRegistrator.UpdateChunkMapSent(chunk.ChunkUid);
            }
            else if (chunk.Mode == ProcessingMode.Reduce)
            {
                _jobChunkRegistrator.UpdateChunkReduceSent(chunk.ChunkUid);
            }
        }
        #endregion Public Methods
    }
}
