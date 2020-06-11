using System;
using System.Collections.Generic;
using VoxelWars.Vector;

namespace VoxelWars.Universe
{
	public partial class World
	{
		private readonly Dictionary<Position, Chunk> chunks = new Dictionary<Position, Chunk>();
		private readonly Noise noise = new Noise(new Random());

		public Chunk this[Position position]
		{
			get
			{ 
				Chunk chunk;
				if (chunks.TryGetValue(position, out chunk)) return chunk;

				chunk = new Chunk(position, noise);
				chunks.Add(position, chunk);

				foreach (Side side in SideExtensions.Sides)
				{
					Chunk sideChunk;
					SByte2 offset = side.Vector();
					if (chunks.TryGetValue(new Position(position.X + offset.X, position.Y + offset.Y), out sideChunk))
					{
						sideChunk.neighbours[(byte)side.Opposite()] = chunk;
						chunk.neighbours[(byte)side] = sideChunk;

						sideChunk.changed = true;
						chunk.changed = true;
					}
				}
				return chunk;
			}
		}

		public BlockData GetBlock(Position position)
		{
			return this[position / Chunk.ChunkSize].CurrentAccessor[AbsMod(position.X, Chunk.ChunkSize), AbsMod(position.Y, Chunk.ChunkSize)];
		}
        
		public BlockData SetBlock(Position position, BlockData block)
		{
			return this[position / Chunk.ChunkSize].NextAccessor[AbsMod(position.X, Chunk.ChunkSize), AbsMod(position.Y, Chunk.ChunkSize)] = block;
		}
        
		public static int AbsMod(int x, int mod)
		{
			x %= mod;
			return x < 0 ? x + mod : x;
		}

		public void Dump()
		{
			foreach (Chunk chunk in chunks.Values)
			{
				Console.WriteLine("Chunk: {0}:", chunk.Position);
				int x = 0;
				foreach (Chunk side in chunk.neighbours)
				{
					Console.WriteLine("  {0}: {1}", (Side)x, side == null ? "null" : side.Position.ToString());
					x++;
				}
			}
		}
	}
}

