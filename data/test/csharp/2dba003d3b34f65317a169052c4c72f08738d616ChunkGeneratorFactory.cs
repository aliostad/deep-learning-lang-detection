using System;

namespace ASCIIWorld.Data.Generation
{
	public class ChunkGeneratorFactory
	{
		#region Constructors

		static ChunkGeneratorFactory()
		{
			Instance = new ChunkGeneratorFactory();
		}

		private ChunkGeneratorFactory()
		{
		}

		#endregion

		#region Properties

		public static ChunkGeneratorFactory Instance { get; private set; }

		#endregion

		#region Methods

		public IChunkGenerator GetGenerator(ChunkType chunkType, int chunkWidth, int chunkHeight, string seed)
		{
			switch (chunkType)
			{
				case ChunkType.Overworld:
					return new OverworldChunkGenerator(chunkWidth, chunkHeight, seed);

				case ChunkType.Cavern:
					return new CavernChunkGenerator(chunkWidth, chunkHeight, seed);

				case ChunkType.BSPDungeon:
					throw new NotImplementedException();

				case ChunkType.DugoutDungeon:
					throw new NotImplementedException();

				case ChunkType.Labyrinth:
					throw new NotImplementedException();

				default:
					throw new NotImplementedException();
			}
		}

		#endregion
	}
}
