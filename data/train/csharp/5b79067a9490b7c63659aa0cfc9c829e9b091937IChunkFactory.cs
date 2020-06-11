using System;

namespace Vortex.Interface.World.Chunks
{
    public interface IChunkFactory
    {
        /// <summary>
        /// Add a type that implements IChunk
        /// </summary>
        /// <param name="chunkType"></param>
        void RegisterChunkType(Type chunkType);

        /// <summary>
        /// Create a new chunk given the specific typeid
        /// </summary>
        /// <param name="chunkType"></param>
        /// <returns></returns>
        IChunk GetChunk(short chunkType);

        /// <summary>
        /// Returns the typeid for a given chunk
        /// </summary>
        /// <param name="chunk"></param>
        /// <returns></returns>
        short GetChunkType(IChunk chunk);
    }
}
