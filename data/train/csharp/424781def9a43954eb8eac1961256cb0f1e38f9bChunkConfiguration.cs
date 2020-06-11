using System;

namespace VoxLib.Configurations
{
	public class ChunkConfiguration
	{
		public byte ChunkWidth		{ get; set; }
		public byte ChunkHeight		{ get; set; }
		public byte ChunkMaxHeight	{ get; set; }
		public byte ChunkDepth		{ get; set; }
		
		public byte ChunkCacheRange		{ get; set; }
		public byte ChunkViewRange		{ get; set; }
	
		public int ChunkCacheWidth	{ get; private set; }
		public int ChunkCacheDepth	{ get; private set; }

		public ChunkConfiguration()
		{
			ChunkWidth = 16;
			ChunkHeight = 128;
			ChunkMaxHeight = (byte)(ChunkHeight - 1);
			ChunkDepth = 16;

			ChunkCacheRange = 10;
			ChunkViewRange = 8;

			ChunkCacheWidth = ((ChunkCacheRange * 2) + 1) * ChunkWidth;
			ChunkCacheDepth = ((ChunkCacheRange * 2) + 1) * ChunkDepth;

			Reroll();
		}

		public void Reroll()
		{
			ChunkMaxHeight = (byte)(ChunkHeight - 1);
			ChunkCacheWidth = ((ChunkCacheRange * 2) + 1) * ChunkWidth;
			ChunkCacheDepth = ((ChunkCacheRange * 2) + 1) * ChunkDepth;
		}
	}
}
