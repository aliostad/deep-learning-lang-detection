using System;
using System.Collections.Generic;
namespace MTB
{
	public class BlockLightSpread
	{
		private World _world;
		private Queue<LightSpreadNode> _lightBfsQueue;
		private List<Chunk> _changedList;
		private bool _isSunLight;
		public BlockLightSpread (World world)
		{
			_world = world;
			_lightBfsQueue = new Queue<LightSpreadNode>();
			_changedList = new List<Chunk>();
		}
		
		
		public void AddSpreadNode(LightSpreadNode node)
		{
			_lightBfsQueue.Enqueue(node);
		}
		
		public void ClearNode()
		{
			_lightBfsQueue.Clear();
		}
		
		public List<Chunk> SpreadInChunk(Chunk chunk)
		{
			int nextX;
			int nextY;
			int nextZ;
			Chunk nextChunk;
			_changedList.Clear();
			while(_lightBfsQueue.Count > 0)
			{
				LightSpreadNode node = _lightBfsQueue.Dequeue();
				int y = node.index % Chunk.chunkHeight;
				int temp = node.index / Chunk.chunkHeight;
				int z = temp % Chunk.chunkDepth;
				int x = temp / Chunk.chunkDepth;
				
				Chunk nodeChunk = node.chunk;
				
				int curLightLevel = node.lightLevel;
				
				//x - 1
				nextX = x - 1;
				nextChunk = nodeChunk;
				if(nextX < 0)
				{
					nextChunk = _world.GetChunk(nextX + nodeChunk.worldPos.x,y + nodeChunk.worldPos.y,z + nodeChunk.worldPos.z);
					nextX = Chunk.chunkWidth - 1;
				}
				
				if(nextChunk != null && (nextChunk.isLightDataPrepared || nextChunk.worldPos.EqualOther(chunk.worldPos)))
				{
					SpreadInPos(nextX,y,z,nextChunk,curLightLevel);
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
					SpreadInPos(nextX,y,z,nextChunk,curLightLevel);
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
					SpreadInPos(x,y,nextZ,nextChunk,curLightLevel);
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
					SpreadInPos(x,y,nextZ,nextChunk,curLightLevel);
				}
				
				//y - 1
				nextY = y - 1;
				if(nextY >= 0)
				{
					SpreadInPos(x,nextY,z,nodeChunk,curLightLevel);
				}
				
				// y + 1
				nextY = y + 1;
				if(nextY < Chunk.chunkHeight)
				{
					SpreadInPos(x,nextY,z,nodeChunk,curLightLevel);
				}
			}
			return _changedList;
		}

		private void SpreadInPos(int x,int y,int z,Chunk chunk,int curLightLevel)
		{
			//光照强度小于等于1时不再传播
			if(curLightLevel < 2)return;
			Block b = chunk.GetBlock(x,y,z,true);
			BlockAttributeCalculator calculator = BlockAttributeCalculatorFactory.GetCalculator(b.BlockType);
			int lightDamp = calculator.LightDamp(b.ExtendId);
			if(lightDamp < WorldConfig.Instance.maxLightLevel)
			{
				int lightLevel = chunk.GetBlockLight(x,y,z);
				
				int nextLightLevel = curLightLevel - lightDamp - 1;
				if(nextLightLevel > lightLevel)
				{
					int curBlockLightLevel = calculator.LightLevel(b.ExtendId);
					if(curBlockLightLevel > nextLightLevel)
					{
						nextLightLevel = curBlockLightLevel;
					}
					SetLight(chunk,x,y,z,nextLightLevel);
				}
			}
		}

		private void SetLight(Chunk chunk,int x,int y,int z,int lightLevel)
		{
			chunk.SetBlockLight(x,y,z,lightLevel);
			
			if(!_changedList.Contains(chunk))
			{
				_changedList.Add(chunk);
			}
			int nextIndex = (x * Chunk.chunkDepth + z) * Chunk.chunkHeight + y;
			_lightBfsQueue.Enqueue(NodeCache.Instance.GetSpreadNode(nextIndex,lightLevel,chunk));
		}
	}
}

