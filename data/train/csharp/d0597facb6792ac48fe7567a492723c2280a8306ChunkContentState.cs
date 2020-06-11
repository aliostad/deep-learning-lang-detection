using System;

namespace Proxy
{
    internal class ChunkContentState : State
    {
        private Chunk chunk;
        private int size;

        public ChunkContentState(Chunk chunk)
        {
            this.chunk = chunk;
        }

        internal override void Handle(byte data, Action<State> state)
        {
            if (chunk.GetGetExpectedLength == 0)
            {
                chunk.ChangeState(new ChunkCompleteState(chunk));
            }
            else if (chunk.GetGetExpectedLength > size)
            {
                size++;
            }
            else if (chunk.GetGetExpectedLength == size)
            {
                if (data == '\r')
                {
                    return;
                }
                if (data == '\n')
                {
                    chunk.ResetLength();
                    chunk.ChangeState(new ChunkNumberOrCrState(chunk));
                }
                else
                {
                    throw new Exception("New line did not respect the protocol. Invalid length, smaller.");
                }
            }
            else
            {
                throw new Exception("This cannot be. Invalid Chunk length.");
            }
        }
    }
}