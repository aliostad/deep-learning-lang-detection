using System;
using System.Threading;
using System.Collections.Generic;
using System.Collections;
using Priority_Queue;

namespace MTB
{
    public class DataProcessorManager
    {
        public PersistanceWorker persistanceWorker { get; private set; }
        public GeneratorWorker generatorWorker { get; private set; }
        public RenderWorker renderWorker { get; private set; }

        private Queue<PriorityChunk> _priorityCaches;

        private Queue<WaitRenderChunkJob> _waitRenderChunkJobs;

        private Queue<Chunk> _waitRemoveChunks;

        private Queue<NetChunkData> _waitResponseNetChunkDatas;

        private Queue<NetChunkData> _waitNetChunkRemoveDatas;

        private Queue<MeshData> _meshDataQueue;
        public int MaxMeshDataNum = 5;

        public World World { get; set; }

        public DataProcessorManager(World world)
        {
            World = world;
            InitMap();
            InitQueue();
            WorldPersistanceManager.Instance.Init();
        }

        public void StartHandler()
        {
            persistanceWorker.Start();
            generatorWorker.Start();
            renderWorker.Start();
        }

        public void StopHandler()
        {
            persistanceWorker.Stop();
            generatorWorker.Stop();
            renderWorker.Stop();
        }
        //更新区块的优先级
        public void UpdateChunkPriority(WorldPos curInChunkPos)
        {
            persistanceWorker.UpdateLoadChunkPriority(curInChunkPos);
            generatorWorker.UpdateGeneratorChunkPriority(curInChunkPos);
        }
        public void UpdateNetChunkPriority(WorldPos curInChunkPos)
        {
            persistanceWorker.UpdateNetLoadChunkPriority(curInChunkPos);
            generatorWorker.UpdateNetGeneratorChunkPriority(curInChunkPos);
        }

        //从本地加载区块数据(单机使用)
        public void EnqueueLoadChunk(Chunk chunk, WorldPos curInChunkPos)
        {
            persistanceWorker.EnLoadQueue(chunk, curInChunkPos);
        }


        public PriorityChunk GetPriorityChunk(Chunk chunk)
        {
            lock (_priorityCaches)
            {
                if (_priorityCaches.Count > 0)
                {
                    PriorityChunk c = _priorityCaches.Dequeue();
                    c.chunk = chunk;
                    return c;
                }
                return new PriorityChunk(chunk);
            }
        }

        public void SetPriorityChunk(PriorityChunk c)
        {
            lock (_priorityCaches)
            {
                c.chunk = null;
                c.Priority = 0;
                _priorityCaches.Enqueue(c);
            }
        }

        public double GetPriority(WorldPos chunkPos, WorldPos curInChunkPos)
        {
            double priority = Math.Sqrt(Math.Pow((chunkPos.x - curInChunkPos.x) / Chunk.chunkWidth, 2) +
                Math.Pow((chunkPos.z - curInChunkPos.z) / Chunk.chunkDepth, 2));
            return priority;
        }
        //保存到本地区块数据文件(单机使用)
        public void EnqueueSaveChunk(Chunk chunk)
        {
            persistanceWorker.EnSaveQueue(chunk);
        }

        //刷新区块网格和光照
        public void EnqueueRefreshChunk(RefreshChunkArea chunk)
        {
            persistanceWorker.EnReFreshQueue(chunk);
        }

        //从本地加载出chunk数据（为了发给请求的客户端）(联机使用)
        public void EnqueueLoadNetChunkData(NetChunkData data)
        {
            persistanceWorker.EnNetLoadQueue(data);
        }
        //保存从客户端发送过来的chunk数据 (联机使用)
        public void EnqueueSaveNetChunkData(NetChunkData data)
        {
            persistanceWorker.EnNetSaveQueue(data);
        }
        //将客户端的chunk数据序列化好（保存到服务器上）(联机使用)
        public void EnqueueSaveNetChunk(NetRemovedChunk netRemovedChunk)
        {
			persistanceWorker.EnNetChunkSaveQueue(netRemovedChunk);
        }
        //将从服务器端获取的数据序列化成chunk数据(联机使用)
        public void EnqueueNetChunk(NetChunk netChunk)
        {
            NetPriorityChunk priorityChunk = new NetPriorityChunk(netChunk);
            priorityChunk.Priority = GetPriority(netChunk.chunkPos, netChunk.curPlayerInChunkPos);
            persistanceWorker.EnNetChunkLoadQueue(priorityChunk);
        }

        //如果当前本机客户端没有产生生物群落，而其他客户端产生生物群落时，将产生的生物群落更新到当前客户端上
        public void EnqueueUpdatePopulation(NetChunk netChunk)
        {
            NetPriorityChunk priorityChunk = new NetPriorityChunk(netChunk);
            priorityChunk.Priority = GetPriority(netChunk.chunkPos, netChunk.curPlayerInChunkPos);
            generatorWorker.EnNetGeneratorQueue(priorityChunk);
        }

        //更新网络同步的大量块刷新
        public void EnqueueNetUpdateArea(RefreshChunkArea area)
        {
            generatorWorker.EnNetRefreshAreaQueue(area);
        }

        //渲染前的处理，如一些光照的传播什么的
        public void EnqueuePrevRender(Chunk chunk, int x, int y, int z, Block block)
        {
            renderWorker.EnqueuePrevRender(chunk, x, y, z, block);
        }
        //进入渲染队列
        public void EnqueueRender(Chunk chunk, bool isHighPriority = false)
        {
            renderWorker.EnqueueRender(chunk, isHighPriority);
        }
        //进入等待渲染队列，worldRender将从该队列中拿出数据渲染
        public void EnqueueWaitRender(Chunk chunk, MeshData meshData)
        {
            lock (_waitRenderChunkJobs)
            {
                WaitRenderChunkJob job = null;
                foreach (var item in _waitRenderChunkJobs)
                {
                    if (item.chunk.worldPos.EqualOther(chunk.worldPos))
                    {
                        job = item;
                        break;
                    }
                }
                if (job == null)
                {
                    job = new WaitRenderChunkJob(chunk, meshData);
                    _waitRenderChunkJobs.Enqueue(job);
                }
                else
                {
                    job.meshData = meshData;
                }
            }
        }

        public WaitRenderChunkJob DequeueWaitRender()
        {
            lock (_waitRenderChunkJobs)
            {
                if (_waitRenderChunkJobs.Count > 0)
                {
                    WaitRenderChunkJob job = _waitRenderChunkJobs.Dequeue();

                    return job;
                }
                return null;
            }
        }
        //进入等待移除队列
        public void EnqueueWaitRemove(Chunk chunk)
        {
            lock (_waitRemoveChunks)
            {
                if (!_waitRemoveChunks.Contains(chunk))
                {
                    _waitRemoveChunks.Enqueue(chunk);
                }
            }
        }

        public Chunk DequeueWaitRemove()
        {
            lock (_waitRemoveChunks)
            {
                if (_waitRemoveChunks.Count > 0)
                {
                    Chunk chunk = _waitRemoveChunks.Dequeue();
                    return chunk;
                }
                return null;
            }
        }
        //进入队列，该队列保存了客户端请求的chunk数据
        public void EnResponseNetChunkData(NetChunkData data)
        {
            lock (_waitResponseNetChunkDatas)
            {
                _waitResponseNetChunkDatas.Enqueue(data);
            }
        }

        public NetChunkData DeResponseNetChunkData()
        {
            lock (_waitResponseNetChunkDatas)
            {
                if (_waitResponseNetChunkDatas.Count > 0)
                {
                    NetChunkData data = _waitResponseNetChunkDatas.Dequeue();
                    return data;
                }
                return null;
            }
        }

        public void EnNetChunkRemoveData(NetChunkData data)
        {
            lock (_waitNetChunkRemoveDatas)
            {
                _waitNetChunkRemoveDatas.Enqueue(data);
            }
        }

        public NetChunkData DeNetChunkRemoveData()
        {
            lock (_waitNetChunkRemoveDatas)
            {
                if (_waitNetChunkRemoveDatas.Count > 0)
                {
                    NetChunkData data = _waitNetChunkRemoveDatas.Dequeue();
                    return data;
                }
                return null;
            }
        }

        public MeshData GetUnusedMeshData()
        {
            lock (_meshDataQueue)
            {
                if (_meshDataQueue.Count > 0)
                {
                    MeshData meshData = _meshDataQueue.Dequeue();
                    meshData.Clear();
                    return meshData;
                }
                return new MeshData();
            }
        }

        public void SetUnusedMeshData(MeshData meshData)
        {
            lock (_meshDataQueue)
            {
                if (_meshDataQueue.Count < MaxMeshDataNum)
                {
                    _meshDataQueue.Enqueue(meshData);
                }
            }
        }

        private void InitMap()
        {
            persistanceWorker = new PersistanceWorker(this);
            generatorWorker = new GeneratorWorker(this);
            renderWorker = new RenderWorker(this);
        }

        private void InitQueue()
        {
            _priorityCaches = new Queue<PriorityChunk>(1000);

            _waitRenderChunkJobs = new Queue<WaitRenderChunkJob>();
            _waitRemoveChunks = new Queue<Chunk>();

            _waitResponseNetChunkDatas = new Queue<NetChunkData>();

            _waitNetChunkRemoveDatas = new Queue<NetChunkData>();

            _meshDataQueue = new Queue<MeshData>();
            for (int i = 0; i < MaxMeshDataNum; i++)
            {
                _meshDataQueue.Enqueue(new MeshData());
            }
            MeshBaseDataCache.Instance.Init();
        }
    }

    public class WaitRenderChunkJob
    {
        public Chunk chunk;
        public MeshData meshData;
        public WaitRenderChunkJob(Chunk chunk, MeshData meshData)
        {
            this.chunk = chunk;
            this.meshData = meshData;
        }
    }

    public class PriorityChunk : PriorityQueueNode
    {
        public Chunk chunk;

        public PriorityChunk(Chunk chunk, double priority)
        {
            this.chunk = chunk;
            Priority = priority;
        }

        public PriorityChunk(Chunk chunk)
        {
            this.chunk = chunk;
        }

        public override bool Equals(object obj)
        {
            if (obj is PriorityChunk)
            {
                return chunk.worldPos.EqualOther(((PriorityChunk)obj).chunk.worldPos);
            }
            return false;
        }
    }

    //刷新某一区域较大范围的区块
    public class RefreshChunkArea
    {
        public List<RefreshChunk> chunkList;
        public RefreshChunkArea(List<RefreshChunk> chunklist)
        {
            chunkList = chunklist;
        }
    }

    public class RefreshChunk
    {
        public Chunk chunk;
        public List<UpdateBlock> refreshList;

        public RefreshChunk(Chunk c)
        {
            chunk = c;
            refreshList = new List<UpdateBlock>();
        }
    }

    public class UpdateBlock
    {
        public WorldPos Pos;
        public BlockType type;
        public byte exid;
        public UpdateBlock(BlockType t, byte ei, WorldPos pos)
        {
            type = t;
            exid = ei;
            Pos = pos;
        }
    }

    public class NetPriorityChunk : PriorityQueueNode
    {
        public NetChunk netChunk { get; private set; }

        public NetPriorityChunk(NetChunk chunk, double priority)
        {
            this.netChunk = chunk;
            Priority = priority;
        }

        public NetPriorityChunk(NetChunk chunk)
        {
            this.netChunk = chunk;
        }

        public override bool Equals(object obj)
        {
            if (obj is NetPriorityChunk)
            {
                return netChunk.chunkPos.EqualOther(((NetPriorityChunk)obj).netChunk.chunkPos);
            }
            return false;
        }
    }



    public class PrevRenderChunk
    {
        public Chunk chunk;
        public int x;
        public int y;
        public int z;
        public Block block;
        public PrevRenderChunk(Chunk chunk, int x, int y, int z, Block block)
        {
            this.chunk = chunk;
            this.x = x;
            this.y = y;
            this.z = z;
            this.block = block;
        }

        public override bool Equals(object obj)
        {
            if (obj is PrevRenderChunk)
            {
                PrevRenderChunk c = obj as PrevRenderChunk;
                return chunk.worldPos.EqualOther(c.chunk.worldPos) && x == c.x && y == c.y && z == c.z && block.EqualOther(c.block);
            }
            return false;
        }

        public bool EqualOther(PrevRenderChunk c)
        {
            return chunk.worldPos.EqualOther(c.chunk.worldPos) && x == c.x && y == c.y && z == c.z && block.EqualOther(c.block);
        }
    }
}

