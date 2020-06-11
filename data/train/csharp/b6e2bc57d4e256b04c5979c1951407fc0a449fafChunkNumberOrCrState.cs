using System;

namespace Proxy
{
    internal class ChunkNumberOrCrState : State
    {
        private Chunk chunk;

        public ChunkNumberOrCrState(Chunk chunk)
        {
            this.chunk = chunk;
        }

        internal override void Handle(byte data, Action<State> state)
        {
            if (('0' <= data && data <= '9')
                || ((byte)'A' <= data && (byte)'E' <= data)
                || ((byte)'a' <= data && (byte)'e' <= data))
            {
                chunk.OnLength(data);
            }
            else if (data == '\r')
            {
                chunk.ChangeState(new ChunkNewLineState(chunk));
            }
            else
            {
                throw new Exception("Protocol violation, Carriage Return expected.");
            }
        }
    }
}