using System;
using System.Collections.Generic;
using Microsoft.SilverlightMediaFramework.Plugins.Primitives;
using Microsoft.Web.Media.SmoothStreaming;

namespace Microsoft.SilverlightMediaFramework.Plugins.SmoothStreaming
{
    /// <summary>
    /// Represents a chunk of data that can be downloaded from a stream.
    /// </summary>
    public class DataChunk : IDataChunk
    {
        internal ChunkInfo ChunkInfo { get; private set; }

        public DataChunk(ChunkInfo chunkInfo)
        {
            ChunkInfo = chunkInfo;
        }

        /// <summary>
        /// Gets the unique timestamp of this IDataChunk.
        /// </summary>
        public TimeSpan Timestamp
        {
            get { return ChunkInfo.TimeStamp; }
        }

        /// <summary>
        /// Gets the duration of this IDataChunk.
        /// </summary>
        public TimeSpan Duration
        {
            get { return ChunkInfo.Duration; }
        }

        /// <summary>
        /// Gets a list of attributes about this IDataChunk.
        /// </summary>
        public IDictionary<string, string> Attributes
        {
            get { return ChunkInfo.Attributes; }
        }

        public override bool Equals(object obj)
        {
            var dataChunk = obj as DataChunk;

            return dataChunk != null && dataChunk.ChunkInfo == ChunkInfo;
        }

        public override int GetHashCode()
        {
            return base.GetHashCode();
        }
    }
}
