#region Using

using System;

#endregion

namespace Willcraftia.Xna.Blocks.Models
{
    public sealed class ChunkTaskRequest
    {
        Chunk chunk;

        ChunkTaskType taskType;

        ChunkTaskPriority priority;

        TimeSpan timestamp;

        public Chunk Chunk
        {
            get { return chunk; }
        }

        public ChunkTaskType TaskType
        {
            get { return taskType; }
        }

        public ChunkTaskPriority Priority
        {
            get { return priority; }
        }

        internal TimeSpan Timestamp
        {
            get { return timestamp; }
        }

        internal ChunkTaskRequest() { }

        internal void Initialize(Chunk chunk, ChunkTaskType taskType, ChunkTaskPriority priority)
        {
            if (chunk == null) throw new ArgumentNullException("chunk");

            this.chunk = chunk;
            this.taskType = taskType;
            this.priority = priority;

            timestamp = TimeSpan.FromTicks(Environment.TickCount);
        }

        internal void Clear()
        {
            chunk = null;
        }
    }
}
