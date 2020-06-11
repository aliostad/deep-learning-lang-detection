using System;
using System.IO;

namespace APNGLibrary
{
    /// <summary>
    /// PNG Stream
    /// </summary>
	public class PNGStream : BinStream
	{
		public PNGStream(Stream stream)
			: base(stream)
		{
		}

		public ChunkType ReadChunkType()
		{
			ChunkType result;
			string chunkString = ReadString (4);
			if (!Enum.TryParse<ChunkType>(chunkString, out result))
			{
				throw new Exception(string.Format("Unknown chunk type: '{0}'", chunkString));
			}
			return result;
		}

		public void WriteChunkType(ChunkType chunkType)
		{
			WriteString(chunkType.ToString());
		}

		public Chunk ReadChunk()
		{
			// read 4 byte length
			int length = ReadInt ();
			// read 4 byte chunk type string
			ChunkType chunkType = ReadChunkType ();
            Chunk chunk = Chunk.Factory(length, chunkType, BaseStream);
			return chunk;
		}

		public void WriteChunk(Chunk chunk)
		{
			chunk.Write(BaseStream);
		}
	}
}

