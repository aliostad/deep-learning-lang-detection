using System;

namespace Proxy
{
    internal class ChunkNewLineState : State
    {
        private Chunk chunk;

        public ChunkNewLineState(Chunk chunk)
        {
            this.chunk = chunk;
        }

        internal override void Handle(byte data, Action<State> state)
        {
            if (data == '\n')
            {
                chunk.ChangeState(new ChunkContentState(chunk));
            }
            else
            {
                throw new Exception("Protocol violation, Line Feed expected.");
            }
        }
    }
}