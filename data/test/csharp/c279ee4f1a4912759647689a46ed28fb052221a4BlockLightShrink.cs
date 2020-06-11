using System;
using System.Collections.Generic;
namespace MTB
{
	public class BlockLightShrink
	{
		private World _world;
		private Queue<LightShrinkNode> _lightBfsQueue;
		private List<Chunk> _changedList;
		
		private BlockLightSpread _lightSpread;
		public BlockLightShrink (World world)
		{
			_world = world;
			_lightBfsQueue = new Queue<LightShrinkNode>();
			_changedList = new List<Chunk>();
			_lightSpread = new BlockLightSpread(_world);
		}
		
		public void AddShrinkNode(LightShrinkNode node)
		{
			_lightBfsQueue.Enqueue(node);
		}
		
		public void ClearNode()
		{
			_lightBfsQueue.Clear();
			_lightSpread.ClearNode();
		}
		
		public List<Chunk> ShrinkInChunk(Chunk chunk)
		{
			int nextX;
			int nextY;
			int nextZ;
			Chunk nextChunk;
			_changedList.Clear();
			while(_lightBfsQueue.Count > 0)
			{
				LightShrinkNode node = _lightBfsQueue.Dequeue();
				int y = node.index % Chunk.chunkHeight;
				int temp = node.index / Chunk.chunkHeight;
				int z = temp % Chunk.chunkDepth;
				int x = temp / Chunk.chunkDepth;
				
				Chunk nodeChunk = node.chunk;
				
				int prevLightLevel = node.prevLightLevel;
				
				int curLightLevel = node.lightLevel;
				
				nextX = x - 1;
				nextChunk = nodeChunk;
				if(nextX < 0)
				{
					nextChunk = _world.GetChunk(nextX + nodeChunk.worldPos.x,y + nodeChunk.worldPos.y,z + nodeChunk.worldPos.z);
					nextX = Chunk.chunkWidth - 1;
				}
				
				if(nextChunk != null && (nextChunk.isLightDataPrepared || nextChunk.worldPos.EqualOther(chunk.worldPos)))
				{
					ShrinkInPos(nextX,y,z,nextChunk, prevLightLevel,curLightLevel);
				}
				
				
				//x + 1
				nextX = x + 1;
				nextChunk = nodeChunk;
				if(nextX >= Chunk.chunkWidth)
				{
					nextChunk = _world.GetChunk(nextX + nodeChunk.worldPos.x,y + nodeChunk.worldPos.y,z + nodeChunk.worldPos.z);
					nextX = 0;
				}
				
				if(nextChunk != null && (nextChunk.isLightDataPrepared || nextChunk.worldPos.EqualOther(chunk.worldPos)))
				{
					ShrinkInPos(nextX,y,z,nextChunk,prevLightLevel,curLightLevel);
				}
				
				//z - 1
				nextZ = z - 1;
				nextChunk = nodeChunk;
				if(nextZ < 0)
				{
					nextChunk = _world.GetChunk(x + nodeChunk.worldPos.x,y + nodeChunk.worldPos.y,nextZ + nodeChunk.worldPos.z);
					nextZ = Chunk.chunkDepth - 1;
				}
				if(nextChunk != null && (nextChunk.isLightDataPrepared || nextChunk.worldPos.EqualOther(chunk.worldPos)))
				{
					ShrinkInPos(x,y,nextZ,nextChunk,prevLightLevel,curLightLevel);
				}
				
				//z + 1
				nextZ = z + 1;
				nextChunk = nodeChunk;
				if(nextZ >= Chunk.chunkDepth)
				{
					nextChunk = _world.GetChunk(x + nodeChunk.worldPos.x,y + nodeChunk.worldPos.y,nextZ + nodeChunk.worldPos.z);
					nextZ = 0;
				}
				if(nextChunk != null && (nextChunk.isLightDataPrepared || nextChunk.worldPos.EqualOther(chunk.worldPos)))
				{
					ShrinkInPos(x,y,nextZ,nextChunk,prevLightLevel,curLightLevel);
				}
				
				//y - 1
				nextY = y - 1;
				if(nextY >= 0)
				{
					ShrinkInPos(x,nextY,z,nodeChunk,prevLightLevel,curLightLevel);
				}
				
				// y + 1
				nextY = y + 1;
				if(nextY < Chunk.chunkHeight)
				{
					ShrinkInPos(x,nextY,z,nodeChunk,prevLightLevel,curLightLevel);
				}
			}
			List<Chunk> spreadList = _lightSpread.SpreadInChunk(chunk);
			for (int i = 0; i < spreadList.Count; i++) {
				if(!_changedList.Contains(spreadList[i]))
				{
					_changedList.Add(spreadList[i]);
				}
			}
			return _changedList;
		}

		private void ShrinkInPos(int x,int y,int z,Chunk chunk,int prevLightLevel,int curLightLevel)
		{
			//当前光照强度为最大值时不收缩
			if(curLightLevel >= WorldConfig.Instance.maxLightLevel)return;
			Block b = chunk.GetBlock(x,y,z,true);
			BlockAttributeCalculator calculator = BlockAttributeCalculatorFactory.GetCalculator(b.BlockType);
			int lightDamp = calculator.LightDamp(b.ExtendId);
			if(lightDamp < WorldConfig.Instance.maxLightLevel)
			{
				int lightLevel= chunk.GetBlockLight(x,y,z);
				if(lightLevel > 0)
				{
					int temp = prevLightLevel - lightDamp;
					//如果前一个物块比当前物块的太阳光亮，那么减弱当前物块的亮度
					if(temp > lightLevel)
					{
						int nextLightLevel = curLightLevel - lightDamp - 1;
						if(nextLightLevel < 0)
						{
							nextLightLevel = 0;
						}
						//如果最终结果没有发生改变，那么不收缩
						if(nextLightLevel == lightLevel)return;
						chunk.SetBlockLight(x,y,z,nextLightLevel,true);
						if(!_changedList.Contains(chunk))
						{
							_changedList.Add(chunk);
						}
						int nextIndex = (x * Chunk.chunkDepth + z) * Chunk.chunkHeight + y; 
						_lightBfsQueue.Enqueue(NodeCache.Instance.GetShrinkNode(nextIndex,lightLevel,nextLightLevel,chunk));
					}
					//如果前一个物块比当前物块的太阳光暗，那么增强前一个物块的亮度
					else if(temp < lightLevel)
					{
						int nextIndex = (x * Chunk.chunkDepth + z) * Chunk.chunkHeight + y; 
						_lightSpread.AddSpreadNode(NodeCache.Instance.GetSpreadNode(nextIndex,lightLevel,chunk));
					}
				}
			}
		}
	}
}

