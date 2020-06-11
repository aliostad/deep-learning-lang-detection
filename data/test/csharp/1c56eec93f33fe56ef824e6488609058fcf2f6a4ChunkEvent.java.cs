namespace Mine.NET.Event.world
{
    /**
     * Represents a Chunk related event
     */
    public abstract class ChunkEventArgs : WorldEventArgs
    {
        protected Chunk chunk;

        protected ChunkEventArgs(Chunk chunk) : base(chunk.getWorld())
        {
            this.chunk = chunk;
        }

        /**
         * Gets the chunk being loaded/unloaded
         *
         * @return Chunk that triggered this event
         */
        public Chunk getChunk()
        {
            return chunk;
        }
    }
}
