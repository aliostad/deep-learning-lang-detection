using UnityEngine;
using System.Collections;

public class CaveGenerator 
{
	public int[ , ] chunkList = 
	{
		{ 4, 5, 6, 7 },
		{ 0, 1, 2, 3 }
	};
	public CaveGenerator(MapData mapData)
	{
		Debug.Log("Generating Cave");
		int chunkWidth  = ChunkHandler.chunks[0].Width;
		int chunkHeight = ChunkHandler.chunks[0].Height;

		mapData.Width  = chunkWidth  * chunkList.GetLength(1);
		mapData.Height = chunkHeight * chunkList.GetLength(0);

		int rowPos = 0;
		for (int row = 0; row < chunkList.GetLength(0); ++row)
		{
			int colPos = 0;
			for (int col = 0; col < chunkList.GetLength(1); ++col)
			{

				mapData.SetTiles(ChunkHandler.chunks[chunkList[row, col]], colPos, rowPos);
				colPos += chunkWidth;
			}
			rowPos += chunkHeight;
		}
	}
}
