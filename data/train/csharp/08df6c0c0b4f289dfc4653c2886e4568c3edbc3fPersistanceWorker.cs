using System;
using System.Collections.Generic;
using Priority_Queue;
namespace MTB
{
    public class PersistanceWorker : ProcessWorker
    {
        #region implemented abstract members of ProcessWorker

        protected override void Process()
        {
            try
            {
                SinglePersistanceWorker();
                NetPersistanceWorker();

            }
            catch (Exception e)
            {
                UnityEngine.Debug.LogError(e);
            }
        }

        #endregion
        //单机的持续化工作
        private void SinglePersistanceWorker()
        {
            //单机
            //从本地数据加载
            PriorityChunk loadPriorityChunk = DeLoadQueue();
            if (loadPriorityChunk != null)
            {
				WorldPos pos = loadPriorityChunk.chunk.worldPos;
				if(World.world.GetChunk(pos.x,pos.y,pos.z) == null)return;
                loadPriorityChunk.chunk.InitData();
                if (WorldConfig.Instance.loadInMap)
                {
                    WorldPersistanceManager.Instance.LoadChunk(loadPriorityChunk.chunk);
                }
                //这里进入产生线程
                _manager.generatorWorker.EnGeneratorQueue(loadPriorityChunk);
            }
            //保存到本地数据
            Chunk saveChunk = DeSaveQueue();
            if (saveChunk != null)
            {
                if (saveChunk.isUpdate)
                {
                    if (WorldConfig.Instance.saveBlock)
                    {
                        WorldPersistanceManager.Instance.SaveChunk(saveChunk);
                        saveChunk.isUpdate = false;
                    }
                }
                _manager.EnqueueWaitRemove(saveChunk);
            }
            RefreshChunkArea refreshChunkArea = DeRefreshQueue();
            if (refreshChunkArea != null)
            {
                _manager.generatorWorker.EnRefreshQueue(refreshChunkArea);
            }
        }

        //联机的时候的持续化工作
        private void NetPersistanceWorker()
        {
            //网络
            //从本地数据加载作为网络数据
            NetChunkData netLoadChunkData = DeNetLoadQueue();
            if (netLoadChunkData != null)
            {
                bool succ = WorldPersistanceManager.Instance.LoadNetChunk(netLoadChunkData);
                if (succ) netLoadChunkData.isExist = true;
                else netLoadChunkData.isExist = false;
                _manager.EnResponseNetChunkData(netLoadChunkData);
            }
            //从网络数据加载保存为本地数据
            NetChunkData netSaveChunkData = DeNetSaveQueue();
            if (netSaveChunkData != null)
            {
                WorldPersistanceManager.Instance.SaveNetChunk(netSaveChunkData);
            }

            //从网络数据加载作为内存数据
            NetPriorityChunk requestNetChunk = DeNetChunkLoadQueue();
            if (requestNetChunk != null)
            {
                requestNetChunk.netChunk.chunk.InitData();
                if (requestNetChunk.netChunk.chunkData.isExist)
                {
                    requestNetChunk.netChunk.chunk = WorldPersistanceManager.Instance.GetChunk(requestNetChunk.netChunk);
                    //当从网络上获取到区块数据，并产生的时候，发送到服务器上
                    EventManager.SendEvent(EventMacro.CHUNK_DATA_GENERATE_FINISH, requestNetChunk.netChunk.chunk);
                }
                else
                {
                    //如果当前客户端是主机，尝试从本机读取数据
                    if (NetManager.Instance.client.isMainClient)
                    {
                        if (WorldConfig.Instance.loadInMap)
                        {
                            if (WorldPersistanceManager.Instance.LoadChunk(requestNetChunk.netChunk.chunk))
                            {
                                //当从本地上获取到区块数据，并产生的时候，发送到服务器上
                                EventManager.SendEvent(EventMacro.CHUNK_DATA_GENERATE_FINISH, requestNetChunk.netChunk.chunk);
                            }
                        }
                    }
                }
                _manager.generatorWorker.EnNetGeneratorQueue(requestNetChunk);
            }

            //将内存数据序列化为网络数据
            NetRemovedChunk netSaveChunk = DeNetChunkSaveQueue();
            if (netSaveChunk != null)
            {
                EventManager.SendEvent(EventMacro.CHUNK_DATA_REMOVE_FINISH, netSaveChunk);
                _manager.EnqueueWaitRemove(netSaveChunk.chunk);
            }
        }

        private HeapPriorityQueue<PriorityChunk> _selfLoadQueue;
        private Queue<RefreshChunkArea> _refreshQueue;

        private Queue<Chunk> _selfSaveQueue;

        private Queue<NetChunkData> _netLoadQueue;
        private Queue<NetChunkData> _netSaveQueue;

        private HeapPriorityQueue<NetPriorityChunk> _netChunkLoadQueue;
		private Queue<NetRemovedChunk> _netChunkSaveQueue;
        public PersistanceWorker(DataProcessorManager manager)
            : base(manager)
        {
            _selfLoadQueue = new HeapPriorityQueue<PriorityChunk>(1000);
            _selfSaveQueue = new Queue<Chunk>();
            _refreshQueue = new Queue<RefreshChunkArea>();
            _netLoadQueue = new Queue<NetChunkData>();
            _netSaveQueue = new Queue<NetChunkData>();

            _netChunkLoadQueue = new HeapPriorityQueue<NetPriorityChunk>(1000);
			_netChunkSaveQueue = new Queue<NetRemovedChunk>();
        }

        public void EnLoadQueue(Chunk chunk, WorldPos curInChunkPos)
        {
            lock (_selfLoadQueue)
            {
                if (_selfLoadQueue.Count > _selfLoadQueue.MaxSize) 
				{
					return;
				}
                _selfLoadQueue.Enqueue(_manager.GetPriorityChunk(chunk), _manager.GetPriority(chunk.worldPos, curInChunkPos));
            }
        }

        private PriorityChunk DeLoadQueue()
        {
            lock (_selfLoadQueue)
            {
                if (_selfLoadQueue.Count > 0)
                {
                    PriorityChunk c = _selfLoadQueue.Dequeue();
                    return c;
                }
                return null;
            }
        }

        //刷新区块网格和光照
        public void EnReFreshQueue(RefreshChunkArea chunk)
        {
            lock (_refreshQueue)
            {
                _refreshQueue.Enqueue(chunk);
            }
        }

        public RefreshChunkArea DeRefreshQueue()
        {
            lock (_refreshQueue)
            {
                if (_refreshQueue.Count > 0)
                {
                    return _refreshQueue.Dequeue();
                }
                return null;
            }
        }

        public void EnSaveQueue(Chunk chunk)
        {
            lock (_selfSaveQueue)
            {
                _selfSaveQueue.Enqueue(chunk);
            }
        }

        public Chunk DeSaveQueue()
        {
            lock (_selfSaveQueue)
            {
                if (_selfSaveQueue.Count > 0)
                {
                    return _selfSaveQueue.Dequeue();
                }
                return null;
            }
        }

        public void EnNetLoadQueue(NetChunkData netChunkData)
        {
            lock (_netLoadQueue)
            {
                _netLoadQueue.Enqueue(netChunkData);
            }
        }

        public NetChunkData DeNetLoadQueue()
        {
            lock (_netLoadQueue)
            {
                if (_netLoadQueue.Count > 0)
                {
                    return _netLoadQueue.Dequeue();
                }
                return null;
            }
        }

        public void EnNetSaveQueue(NetChunkData data)
        {
            lock (_netSaveQueue)
            {
                _netSaveQueue.Enqueue(data);
            }
        }

        public NetChunkData DeNetSaveQueue()
        {
            lock (_netSaveQueue)
            {
                if (_netSaveQueue.Count > 0)
                {
                    return _netSaveQueue.Dequeue();
                }
                return null;
            }
        }

        public void EnNetChunkLoadQueue(NetPriorityChunk netPriorityChunk)
        {
            lock (_netChunkLoadQueue)
            {
                _netChunkLoadQueue.Enqueue(netPriorityChunk, netPriorityChunk.Priority);
            }
        }

        public NetPriorityChunk DeNetChunkLoadQueue()
        {
            lock (_netChunkLoadQueue)
            {
                if (_netChunkLoadQueue.Count > 0)
                {
                    return _netChunkLoadQueue.Dequeue();
                }
                return null;
            }
        }

		public void EnNetChunkSaveQueue(NetRemovedChunk data)
        {
            lock (_netChunkSaveQueue)
            {
                _netChunkSaveQueue.Enqueue(data);
            }
        }

		public NetRemovedChunk DeNetChunkSaveQueue()
        {
            lock (_netChunkSaveQueue)
            {
                if (_netChunkSaveQueue.Count > 0)
                {
                    return _netChunkSaveQueue.Dequeue();
                }
                return null;
            }
        }

        public void UpdateLoadChunkPriority(WorldPos curInChunkPos)
        {
            lock (_selfLoadQueue)
            {
                IEnumerator<PriorityChunk> enumerator = _selfLoadQueue.GetEnumerator();
                while (enumerator.MoveNext())
                {
                    enumerator.Current.Priority = _manager.GetPriority(enumerator.Current.chunk.worldPos, curInChunkPos);
                }
                _selfLoadQueue.UpdateAll();
            }
        }

        public void UpdateNetLoadChunkPriority(WorldPos curInChunkPos)
        {
            lock (_netChunkLoadQueue)
            {
                IEnumerator<NetPriorityChunk> enumerator = _netChunkLoadQueue.GetEnumerator();
                while (enumerator.MoveNext())
                {
                    enumerator.Current.Priority = _manager.GetPriority(enumerator.Current.netChunk.chunk.worldPos, curInChunkPos);
                }
                _netChunkLoadQueue.UpdateAll();
            }
        }
    }

    public class NetChunkData
    {
        public int roleId { get; private set; }
        public bool isExist { get; set; }
        public ChunkByteData data { get; set; }
        public bool hasChangeData { get; set; }
        public ClientChangedChunkData changedData { get; set; }
        public WorldPos worldPos { get; private set; }
        public NetChunkData(int roleId, WorldPos pos)
        {
            this.roleId = roleId;
            worldPos = pos;
            isExist = false;
            data = new ChunkByteData();
        }

    }

    public class NetChunk
    {
        public Chunk chunk { get; set; }
        public WorldPos curPlayerInChunkPos { get; set; }
        public NetChunkData chunkData { get; set; }
        public WorldPos chunkPos { get; private set; }
        public NetChunk(NetChunkData data)
        {
            chunkData = data;
            chunkPos = data.worldPos;
        }

        public NetChunk(Chunk chunk)
        {
            this.chunk = chunk;
            chunkPos = chunk.worldPos;
        }
    }

    public class NetRemovedChunk
	{
		public Chunk chunk{get;set;}
		public bool needSave{get;set;}
		public List<ClientEntityInfo> changedEntityInfos{get;set;}
		public NetRemovedChunk(Chunk chunk)
		{
			this.chunk = chunk;
		}
	}
}

