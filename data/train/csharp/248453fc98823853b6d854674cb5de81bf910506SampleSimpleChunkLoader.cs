using UnityEngine;

public class SampleSimpleChunkLoader : ChunkLoader
{
	public override void LoadChunk(Chunk chunk)
	{
		WorldChunk wChunk = chunk as WorldChunk;
		if (wChunk == null)
			return;

		chunk.InitBlocks(wChunk.World.ChunkSizeX, wChunk.World.ChunkSizeY, wChunk.World.ChunkSizeZ);

		for (int x = 0; x < wChunk.SizeX; x++)
			for (int z = 0; z < wChunk.SizeZ; z++)
			{
				if (x == 0 && z != 0)
					wChunk.SetBlock(x, 0, z, new Block { Color = new Color32() { a = 255, r = 0, g = 0, b = 255 }, Type = Block.BlockTypes.Solid }, false);
				else if (z == 0 && x != 0)
					wChunk.SetBlock(x, 0, z, new Block { Color = new Color32() { a = 255, r = 255, g = 0, b = 0 }, Type = Block.BlockTypes.Solid }, false);
				else if ((x + z) % 2 == 0)
					wChunk.SetBlock(x, 0, z, new Block { Color = new Color32() { a = 255, r = 127, g = 127, b = 127 }, Type = Block.BlockTypes.Solid }, false);
				else
					wChunk.SetBlock(x, 0, z, new Block { Color = new Color32() { a = 255, r = 50, g = 255, b = 50 }, Type = Block.BlockTypes.Solid }, false);
			}

		for (int y = 0; y < chunk.SizeX; y++)
			wChunk.SetBlock(0, y, 0, new Block { Color = new Color32() { a = 255, r = 0, g = 255, b = 0 }, Type = Block.BlockTypes.Solid }, false);
	}
}
