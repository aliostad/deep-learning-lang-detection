namespace Adborroto.FlowJs.Chunk
{
    public class ChunkNameGenerator:IChunkNameGenerator
    {

        public virtual string Generate(Chunk chunk, bool temporal = false)
        {
            return Generate(chunk.FileName, chunk.Identifier, chunk.Number, temporal);
        }

        public virtual string Generate(string fileName, string flowIdentifier, int chunkNumer, bool temporal = false)
        {
            return temporal
                ? string.Format("chunk-{0}-{1}.{2}.tmp", fileName, flowIdentifier, chunkNumer)
                : string.Format("chunk-{0}-{1}.{2}", fileName, flowIdentifier, chunkNumer);
        }
    }
}