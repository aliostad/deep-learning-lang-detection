using System.Diagnostics;
using Lidgren.Network;
using SquareCubed.Common.Data;

namespace SquareCubed.Client.Structures
{
	public class ClientChunk : Chunk
	{
	}

	public static class ClientChunkExtensions
	{
		public static ClientChunk ReadChunk(this NetIncomingMessage msg)
		{
			Debug.Assert(msg != null);

			var chunk = new ClientChunk();

			// Read all the tiles from the message
			for (var x = 0; x < Chunk.ChunkSize; x++)
			{
				for (var y = 0; y < Chunk.ChunkSize; y++)
				{
					// False means no tile, so ignore it
					if (!msg.ReadBoolean()) continue;

					msg.ReadPadBits();
					chunk.Tiles[x][y] = msg.ReadTile();
				}
			}
			msg.ReadPadBits();
			chunk.UpdateColliders();

			Debug.Assert(chunk != null);
			return chunk;
		}
	}
}