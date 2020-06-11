#include "StdAfx.h"
#include "DestructibleHitChunk.h"

NxDestructibleHitChunk DestructibleHitChunk::ToUnmanaged(DestructibleHitChunk managed)
{
	NxDestructibleHitChunk unmanaged;
		unmanaged.chunkIndex = managed.ChunkIndex;
		unmanaged.hitChunkFlags = managed.HitChunkFlags;

	return unmanaged;
}
DestructibleHitChunk DestructibleHitChunk::ToManaged(NxDestructibleHitChunk unmanaged)
{
	DestructibleHitChunk managed;
		managed.ChunkIndex = unmanaged.chunkIndex;
		managed.HitChunkFlags = unmanaged.hitChunkFlags;

	return managed;
}