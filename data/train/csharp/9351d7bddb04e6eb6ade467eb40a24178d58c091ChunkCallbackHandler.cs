using System;

namespace SDTM
{
	public class ChunkCallbackHandler:IChunkCallback
	{
		protected World world;

		public ChunkCallbackHandler ():base()
		{
			this.world = GameManager.Instance.World;
			this.world.ChunkCache.AddChunkCallback (this);
		}

		public void OnChunkAdded(Chunk _chunk){
			SDTM.API.Events.NotifyChunkAddedHandlers(_chunk);
		}

		public void OnChunkBeforeRemove(Chunk _chunk){
			SDTM.API.Events.NotifyBeforeChunkRemovedHandlers(_chunk);
		}

		public void OnChunkBeforeSave(Chunk _chunk){
			SDTM.API.Events.NotifyBeforeChunkSavedHandlers(_chunk);
		}
	}
}

