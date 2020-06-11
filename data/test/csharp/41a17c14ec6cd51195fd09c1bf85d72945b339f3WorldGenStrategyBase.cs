using UnityEngine;

public abstract class WorldGenStrategyBase
{
    public abstract string Name { get; }

    protected virtual bool AffectsChunk( World world , ChunkVector chunkVector )
    {
        return false;
    }

    public void Init( World world , Chunk chunk , ChunkVector chunkVector )
    {
        if ( !AffectsChunk( world , chunkVector ) )
            return;

        InitInternal( world , chunk , chunkVector );
    }

    protected abstract void InitInternal( World world , Chunk chunk , ChunkVector chunkVector );
}