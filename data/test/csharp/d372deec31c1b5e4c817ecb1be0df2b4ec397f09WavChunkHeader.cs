using System;
using System.IO;
using System.Text;

namespace WavSplitter
{
	public class WavChunkHeader
	{
		public const int Size = 8;

		public string ChunkId { get; private set; }
		public int ChunkLength { get; private set; }

		public bool ShouldSkip
		{
			get { return ChunkId == WavConst.Fllr; }
		}

		public void Read (BinaryReader reader)
		{
			ChunkId = Encoding.UTF8.GetString (reader.ReadBytes (4), 0, 4); // "data" or "FLLR"
			ValidateDataChunkId (ChunkId);

			ChunkLength = reader.ReadInt32 ();
		}

		private static void ValidateDataChunkId (string chunkId)
		{
			if (chunkId != WavConst.Data && chunkId != WavConst.Fllr)
			{
				throw new InvalidOperationException ("Invalid data chunk id: " + chunkId);
			}
		}
	}
}
