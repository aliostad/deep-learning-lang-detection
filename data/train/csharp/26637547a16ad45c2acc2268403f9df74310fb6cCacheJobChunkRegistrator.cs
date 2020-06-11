using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JobProcessor;
using JobProcessor.Exceptions;
using JobProcessor.Interfaces;
using JobProcessor.Model;

namespace JobProcessor.Implementation
{
    class CacheJobChunkRegistrator : IJobChunkRegistrator
    {
        #region Consts
        private const string JobSumKeyPrefix = "Job_";
        private const string JobChunkKeyPrefix = "Chunk_";
        #endregion Consts

        #region Events
        public event Action<object, string> JobMapComplete;
        public event Action<object, string> JobReduceComplete;
        #endregion Events

        #region Public Methods
        public void RegisterNewMapChunk(JobChunkUid chunkUid)
        {
            Logger.Log.Instance.Info(string.Format("CacheJobChunkRegistrator. Register new map chunk. JobId '{0}', ChunkId '{1}'",
                chunkUid.JobId,
                chunkUid.ChunkId));
            UpdateJobSummeryInCache(chunkUid);
            AddChunkToCache(chunkUid, ProcessingMode.Map);
        }
        
        public void RegisterNewReduceChunk(JobChunkUid chunkUid)
        {
            Logger.Log.Instance.Info(string.Format("CacheJobChunkRegistrator. Register new reduce chunk. JobId '{0}', ChunkId '{1}'",
                chunkUid.JobId,
                chunkUid.ChunkId));
            UpdateJobSummeryInCache(chunkUid);
            AddChunkToCache(chunkUid, ProcessingMode.Reduce);
        }

        public void UpdateChunkMapSent(JobChunkUid chunkUid)
        {
            Logger.Log.Instance.Info(string.Format("CacheJobChunkRegistrator. Map chunk sent. JobId '{0}', ChunkId '{1}'",
                chunkUid.JobId,
                chunkUid.ChunkId));

            UpdateChunkStatusInCache(chunkUid, ChunkStatus.MapSent, ProcessingMode.Map);
        }

        public void UpdateChunkMapComplete(JobChunkUid chunkUid)
        {
            Logger.Log.Instance.Info(string.Format("CacheJobChunkRegistrator. Map chunk complete. JobId '{0}', ChunkId '{1}'",
                chunkUid.JobId,
                chunkUid.ChunkId));
            
            UpdateChunkStatusInCache(chunkUid, ChunkStatus.MapCompleted, ProcessingMode.Map);
            if (AllJobChunksCompleted(chunkUid.JobId, ProcessingMode.Map))
            {
                Logger.Log.Instance.Info(string.Format("CacheJobChunkRegistrator. Map of all job chunks complete. JobId '{0}'",
                    chunkUid.JobId));
                
                var jobMapComplete = JobMapComplete;
                if (jobMapComplete != null)
                {
                    Logger.Log.Instance.Info(string.Format("CacheJobChunkRegistrator. Raise job map complete event for JobId '{0}'",
                        chunkUid.JobId));
                    jobMapComplete(this, chunkUid.JobId);
                }
            }
        }

        public void UpdateChunkReduceSent(JobChunkUid chunkUid)
        {
            Logger.Log.Instance.Info(string.Format("CacheJobChunkRegistrator. Reduce chunk sent. JobId '{0}', ChunkId '{1}'",
                chunkUid.JobId,
                chunkUid.ChunkId));
            UpdateChunkStatusInCache(chunkUid, ChunkStatus.ReduceSent, ProcessingMode.Reduce);
        }

        public void UpdateChunkReduceComplete(JobChunkUid chunkUid)
        {
            Logger.Log.Instance.Info(string.Format("CacheJobChunkRegistrator. Reduce chunk complete. JobId '{0}', ChunkId '{1}'",
                chunkUid.JobId,
                chunkUid.ChunkId));
            UpdateChunkStatusInCache(chunkUid, ChunkStatus.ReduceCompleted, ProcessingMode.Reduce);
            if (AllJobChunksCompleted(chunkUid.JobId, ProcessingMode.Reduce))
            {
                Logger.Log.Instance.Info(string.Format("CacheJobChunkRegistrator. Reduce of all job chunks complete. JobId '{0}'",
                    chunkUid.JobId));

                var jobReduceComplete = JobReduceComplete;
                if (jobReduceComplete != null)
                {
                    Logger.Log.Instance.Info(string.Format("CacheJobChunkRegistrator. Raise job reduce complete event. JobId '{0}'",
                        chunkUid.JobId));
                    jobReduceComplete(this, chunkUid.JobId);
                }
            }
        }
        #endregion Public methods

        #region Private methods
        private bool AllJobChunksCompleted(string jobId, ProcessingMode mode)
        {
            Logger.Log.Instance.Info(string.Format("CacheJobChunkRegistrator. Check for competion of phase {1}. JobId '{0}'",
                        jobId, mode));

            var sumKey = GetJobSummeryKey(jobId);
            var jobSplitDetails = AzureClient.Instance.CacheClient[sumKey] as JobSplitDetails;
            var completedStatus = mode == ProcessingMode.Map ? ChunkStatus.MapCompleted : ChunkStatus.ReduceCompleted;
            foreach (var chunkId in jobSplitDetails.JobChunkIds)
            {
                var chunkKey = GetJobChunkKey(new JobChunkUid() { JobId = jobId, ChunkId = chunkId }, mode);
                var chunkStatus = AzureClient.Instance.CacheClient[chunkKey] as JobChunkStatus;
                Logger.Log.Instance.Info(string.Format("   ==> Chunk {0}. Status: {1}",
                            chunkId, chunkStatus.Status));
                if (chunkStatus.Status != completedStatus)
                {
                    Logger.Log.Instance.Info(string.Format("     ==> Not completed yet"));
                    return false;
                }
            }
            Logger.Log.Instance.Info(string.Format("   ==> Phase completed. Clear cache"));

            // Clear cache
            foreach (var chunkId in jobSplitDetails.JobChunkIds)
            {
                var chunkKey = GetJobChunkKey(new JobChunkUid() { JobId = jobId, ChunkId = chunkId }, mode);
                AzureClient.Instance.CacheClient.Remove(chunkKey);
                Logger.Log.Instance.Info(string.Format("     ==> Clear cache for chunk {0}", chunkId));
            }

            AzureClient.Instance.CacheClient.Remove(sumKey);
            Logger.Log.Instance.Info(string.Format("     ==> Clear cache for sum of job {0}", jobId));

            return true;
        }

        private void UpdateJobSummeryInCache(JobChunkUid chunkUid)
        {
            var sumKey = GetJobSummeryKey(chunkUid.JobId);
            var jobSummery = AzureClient.Instance.CacheClient.Get(sumKey) as JobSplitDetails;
            if (jobSummery == null)
            {
                jobSummery = new JobSplitDetails();
                jobSummery.JobId = chunkUid.JobId;
            }

            if (!jobSummery.JobChunkIds.Contains(chunkUid.ChunkId))
            {
                jobSummery.JobChunkIds.Add(chunkUid.ChunkId);
                AzureClient.Instance.CacheClient.Add(sumKey, jobSummery);
            }
        }

        private void AddChunkToCache(JobChunkUid chunkUid, ProcessingMode mode)
        {
            var chunkKey = GetJobChunkKey(chunkUid, mode);
            var chunkStatus = new JobChunkStatus()
            {
                LastUpdate = DateTime.Now,
                Status = mode == ProcessingMode.Map ? ChunkStatus.NewMap : ChunkStatus.NewReduce
            };
            
            chunkStatus.ChunkUid.JobId = chunkUid.JobId;
            chunkStatus.ChunkUid.ChunkId = chunkUid.ChunkId;

            AzureClient.Instance.CacheClient.Add(chunkKey, chunkStatus);
        }

        private void UpdateChunkStatusInCache(JobChunkUid chunkUid, ChunkStatus status, ProcessingMode mode)
        {
            var chunkKey = GetJobChunkKey(chunkUid, mode);
            var chunkStatus = AzureClient.Instance.CacheClient.Get(chunkKey) as JobChunkStatus;
            if (chunkStatus == null)
                throw new UnknownChunkException("Unrestered chunk") { ChunkUid = chunkUid };
            
            chunkStatus.Status = status;
            chunkStatus.LastUpdate = DateTime.Now;
            AzureClient.Instance.CacheClient.Add(chunkKey, chunkStatus);
        }

        private string GetJobSummeryKey(string jobId)
        {
            return string.Concat(JobSumKeyPrefix, jobId);
        }

        private string GetJobChunkKey(JobChunkUid chunkUid, ProcessingMode mode)
        {
            return string.Format("{3}_{0}{1}_{2}", JobChunkKeyPrefix, chunkUid.JobId, chunkUid.ChunkId, mode);
        }
        #endregion Private methods
    }
}
