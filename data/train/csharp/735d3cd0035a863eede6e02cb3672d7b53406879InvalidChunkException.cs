using System;
using SharpDX.Multimedia;

namespace Odyssey.Serialization
{
    /// <summary>
    /// Exceptions thrown when an invalid chunk is decoded.
    /// </summary>
    public class InvalidChunkException : Exception
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="T:System.Exception" /> class with a specified error message.
        /// </summary>
        /// <param name="chunkId">The chunk id.</param>
        /// <param name="expectedChunkId">The expected chunk id.</param>
        public InvalidChunkException(FourCC chunkId, FourCC expectedChunkId)
            : base(string.Format("Unexpected chunk [{0}/0x{1:X}] instead of [{2}/0x{3:X}]", chunkId, (int)chunkId, expectedChunkId, (int)expectedChunkId))
        {
            this.ChunkId = chunkId;
            this.ExpectedChunkId = expectedChunkId;
        }

        /// <summary>
        /// Gets the chunk id.
        /// </summary>
        /// <value>The chunk id.</value>
        public FourCC ChunkId { get; private set; }

        /// <summary>
        /// Gets the expected chunk id.
        /// </summary>
        /// <value>The expected chunk id.</value>
        public FourCC ExpectedChunkId { get; private set; }
    }
}