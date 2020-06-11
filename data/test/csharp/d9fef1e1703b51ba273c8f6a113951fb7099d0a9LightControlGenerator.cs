using System;
using UnityEngine;
using System.Collections.Generic;
namespace MTB
{
	public class LightControlGenerator
	{
		private World _world;
		private SunLightSpread _lightSpread;
		public LightControlGenerator (World world)
		{
			_world = world;
			_lightSpread = new SunLightSpread(world);
		}

		public void Generate(Chunk chunk)
		{
			NormalSunLightFill(chunk);
			SpreadLight(chunk);
		}

		public void SpreadLight(Chunk chunk)
		{
			_lightSpread.ClearNode();
			SpreadInChunk(chunk);
			_lightSpread.SpreadInChunk(chunk);
			SpreadFromOtherChunk(chunk);
			_lightSpread.SpreadInChunk(chunk);
		}

		private void NormalSunLightFill(Chunk chunk)
		{
			int sunLightLevel;
			bool isLight;
			for (int x = 0; x < Chunk.chunkWidth; x++) {
				for (int z = 0; z < Chunk.chunkDepth; z++) {
					sunLightLevel = WorldConfig.Instance.maxLightLevel;
					isLight = true;
					for (int y = Chunk.chunkHeight - 1; y >= 0; y--) {

						Block b = chunk.GetBlock(x,y,z,true);

						BlockAttributeCalculator calculator = BlockAttributeCalculatorFactory.GetCalculator(b.BlockType);
						int lightDamp = calculator.LightDamp(b.ExtendId);

						if(lightDamp != 0 && isLight)
						{
							chunk.SetHeight(x,z,y + 1);
							isLight = false;
						}
						
						sunLightLevel -= lightDamp;
						if(sunLightLevel > 0)
						{
							chunk.SetSunLight(x,y,z,sunLightLevel);
						}
						else
						{
							break;
						}
					}
				}
			}

		}

		private void SpreadInChunk(Chunk chunk)
		{
			int sunLightLevel;
			for (int x = 0; x < Chunk.chunkWidth; x++) {
				bool isXInRange = (x != 0 && x != Chunk.chunkWidth - 1);
				for (int z = 0; z < Chunk.chunkDepth; z++) {
					bool isZInRange = (z != 0 && z != Chunk.chunkDepth - 1);
					int height = chunk.GetHeight(x,z,true);
					int leftHeight = chunk.GetHeight(x - 1,z,isXInRange);
					int rightHeight = chunk.GetHeight(x + 1,z,isXInRange);
					int frontHeight = chunk.GetHeight(x,z + 1,isZInRange);
					int backHeight = chunk.GetHeight(x,z - 1,isZInRange);
					int maxHeight = GetMax(height,leftHeight,rightHeight,frontHeight,backHeight);
					for (int y = Chunk.chunkHeight - 1; y >= 0; y--) {
						if(y <= maxHeight)
						{
							sunLightLevel = chunk.GetSunLight(x,y,z,true);
							if(sunLightLevel <= 0)break;
							int index = (x * Chunk.chunkDepth + z) * Chunk.chunkHeight + y;
							LightSpreadNode node = NodeCache.Instance.GetSpreadNode(index,sunLightLevel,chunk);
							_lightSpread.AddSpreadNode(node);
						}
					}
				}
			}
		}

		private int GetMax(int a,int b,int c,int d,int e)
		{
			int temp = Math.Max(Math.Max(a,b),Math.Max(c,d));
			return Math.Max(temp,e);
		}

		private void SpreadFromOtherChunk(Chunk chunk)
		{
			Chunk otherChunk;
			//curChunk_X - 1
			otherChunk = _world.GetChunk(chunk.worldPos.x - Chunk.chunkWidth,0,chunk.worldPos.z);
			if(otherChunk != null && otherChunk.isLightDataPrepared)
			{
				for (int z = 0; z < Chunk.chunkDepth; z++) {
					for (int y = Chunk.chunkHeight - 1; y >= 0; y--) {
						Block curBlock = chunk.GetBlock(0,y,z,true);
						BlockAttributeCalculator calculator = BlockAttributeCalculatorFactory.GetCalculator(curBlock.BlockType);
						int lightDamp = calculator.LightDamp(curBlock.ExtendId);
						if(lightDamp < 15)
						{
							int curLightLevel = chunk.GetSunLight(0,y,z,true);
							int otherLightLevel = otherChunk.GetSunLight(Chunk.chunkWidth - 1,y,z,true);
							int nextLightLevel = otherLightLevel - lightDamp - 1;
							if(nextLightLevel > curLightLevel)
							{
								chunk.SetSunLight(0,y,z,nextLightLevel,true);
								int nextIndex = (0 * Chunk.chunkDepth + z) * Chunk.chunkHeight + y;
								_lightSpread.AddSpreadNode(NodeCache.Instance.GetSpreadNode(nextIndex,nextLightLevel,chunk));
							}
						}
					}
				}
			}
			//curChunk_x + Chunk.chunkWidth
			otherChunk = _world.GetChunk(chunk.worldPos.x + Chunk.chunkWidth,0,chunk.worldPos.z);
			if(otherChunk != null && otherChunk.isLightDataPrepared)
			{
				for (int z = 0; z < Chunk.chunkDepth; z++) {
					for (int y = Chunk.chunkHeight - 1; y >= 0; y--) {
						Block curBlock = chunk.GetBlock(Chunk.chunkWidth - 1,y,z,true);
						BlockAttributeCalculator calculator = BlockAttributeCalculatorFactory.GetCalculator(curBlock.BlockType);
						int lightDamp = calculator.LightDamp(curBlock.ExtendId);
						if(lightDamp < 15)
						{
							int curLightLevel = chunk.GetSunLight(Chunk.chunkWidth - 1,y,z,true);
							int otherLightLevel = otherChunk.GetSunLight(0,y,z,true);
							int nextLightLevel = otherLightLevel - lightDamp - 1;
							if(nextLightLevel > curLightLevel)
							{
								chunk.SetSunLight(Chunk.chunkWidth - 1,y,z,nextLightLevel,true);
								int nextIndex = ((Chunk.chunkWidth - 1) * Chunk.chunkDepth + z) * Chunk.chunkHeight + y;
								_lightSpread.AddSpreadNode(NodeCache.Instance.GetSpreadNode(nextIndex,nextLightLevel,chunk));
							}
						}
					}
				}
			}
			//curChunk_z - Chunk.chunkDepth
			otherChunk = _world.GetChunk(chunk.worldPos.x,0,chunk.worldPos.z - Chunk.chunkDepth);
			if(otherChunk != null && otherChunk.isLightDataPrepared)
			{
				for (int x = 0; x < Chunk.chunkDepth; x++) {
					for (int y = Chunk.chunkHeight - 1; y >= 0; y--) {
						Block curBlock = chunk.GetBlock(x,y,0,true);
						BlockAttributeCalculator calculator = BlockAttributeCalculatorFactory.GetCalculator(curBlock.BlockType);
						int lightDamp = calculator.LightDamp(curBlock.ExtendId);
						if(lightDamp < 15)
						{
							int curLightLevel = chunk.GetSunLight(x,y,0,true);
							int otherLightLevel = otherChunk.GetSunLight(x,y,Chunk.chunkDepth - 1,true);
							int nextLightLevel = otherLightLevel - lightDamp - 1;
							if(nextLightLevel > curLightLevel)
							{
								chunk.SetSunLight(x,y,0,nextLightLevel,true);
								int nextIndex = (x * Chunk.chunkDepth + 0) * Chunk.chunkHeight + y;
								_lightSpread.AddSpreadNode(NodeCache.Instance.GetSpreadNode(nextIndex,nextLightLevel,chunk));
							}
						}
					}
				}
			}
			//curChunk_z + Chunk.chunkDepth
			otherChunk = _world.GetChunk(chunk.worldPos.x,0,chunk.worldPos.z + Chunk.chunkDepth);
			if(otherChunk != null && otherChunk.isLightDataPrepared)
			{
				for (int x = 0; x < Chunk.chunkDepth; x++) {
					for (int y = Chunk.chunkHeight - 1; y >= 0; y--) {
						Block curBlock = chunk.GetBlock(x,y,Chunk.chunkDepth - 1,true);
						BlockAttributeCalculator calculator = BlockAttributeCalculatorFactory.GetCalculator(curBlock.BlockType);
						int lightDamp = calculator.LightDamp(curBlock.ExtendId);
						if(lightDamp < 15)
						{
							int curLightLevel = chunk.GetSunLight(x,y,Chunk.chunkDepth - 1,true);
							int otherLightLevel = otherChunk.GetSunLight(x,y,0,true);
							int nextLightLevel = otherLightLevel - lightDamp - 1;
							if(nextLightLevel > curLightLevel)
							{
								chunk.SetSunLight(x,y,Chunk.chunkDepth - 1,nextLightLevel,true);
								int nextIndex = (x * Chunk.chunkDepth + Chunk.chunkDepth - 1) * Chunk.chunkHeight + y;
								_lightSpread.AddSpreadNode(NodeCache.Instance.GetSpreadNode(nextIndex,nextLightLevel,chunk));
							}
						}
					}
				}
			}
		}

	}

}

