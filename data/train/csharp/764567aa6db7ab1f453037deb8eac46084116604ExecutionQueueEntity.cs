namespace Corebyte.LuaEngineNS
{
    public class ExecutionQueueEntity
    {
        #region Variables

        public CompiledChunk Chunk { get; private set; }
        public ChunkInstance Instance { get; private set; }

        #endregion

        #region Constructors

        public ExecutionQueueEntity(CompiledChunk chunk, ChunkInstance instance)
        {
            Chunk = chunk;
            Instance = instance;
        }

        #endregion

        #region Methods

        //

        #endregion
    }
}
