using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Voxalia.ServerGame.WorldSystem;
using Voxalia.Shared;

namespace Voxalia.ServerGame.NetworkSystem.PacketsOut
{
    /// <summary>
    /// Sends out all shareable information (block types) in a chunk.
    /// </summary>
    public class ChunkPacketOut: AbstractPacketOut
    {
        /// <summary>
        /// The chunk this packet is for.
        /// </summary>
        public Chunk TheChunk;

        /// <summary>
        /// Constructs a chunk packet out.
        /// </summary>
        /// <param name="chunk">The chunk to get data from</param>
        public ChunkPacketOut(Chunk chunk)
        {
            TheChunk = chunk;
            ID = 0;
            Data = chunk.GetArray();
        }
    }
}
