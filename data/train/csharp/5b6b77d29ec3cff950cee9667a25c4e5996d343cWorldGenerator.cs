using System;
using System.Collections.Generic;
using UnityEngine;
namespace MTB
{
    public class WorldGenerator
    {
        private World _world;
        private DataProcessorManager _manager;
        public DataProcessorManager DataProcessorManager { get { return _manager; } }

        public WorldGenerator(World world)
        {
            _world = world;
            _manager = new DataProcessorManager(_world);
        }

        public void StartWorldGenerator()
        {
            _manager.StartHandler();
        }

        public void Dispose()
        {
            _manager.StopHandler();
            WorldPersistanceManager.Instance.Dispose();
        }

        public bool HasSingleDataGenerateFinish()
        {
            return _manager.generatorWorker.hasSingleDataGenerated();
        }

        //(单机使用)
        public void GenerateChunk(int x, int y, int z, WorldPos curInChunkPos)
        {
            WorldPos pos = new WorldPos(x, y, z);
            if (_world.chunks.ContainsKey(pos)) return;
            Chunk newChunk = _world.CreateNewChunk(pos);
            if (newChunk == null) return;
            GenerateChunk(newChunk, curInChunkPos);
        }
        //(单机使用)
        public void GenerateChunk(Chunk chunk, WorldPos curInChunkPos)
        {
            _world.chunks.Add(chunk.worldPos, chunk);
            _manager.generatorWorker.AddSingleGenerateChunk();
            _manager.EnqueueLoadChunk(chunk, curInChunkPos);
        }

        //刷新区块网格和光照
        public void RefreshChunk(RefreshChunkArea chunk)
        {
            _manager.EnqueueRefreshChunk(chunk);
        }

        //(联机使用)
        public void GenerateNetChunk(NetChunkData data, WorldPos curInChunkPos)
        {
            WorldPos pos = data.worldPos;
            Chunk newChunk = _world.GetChunk(pos.x, pos.y, pos.z);
            if (newChunk != null)
            {
                NetChunk netChunk = new NetChunk(data);
                netChunk.chunk = newChunk;
                netChunk.curPlayerInChunkPos = curInChunkPos;
                _manager.EnqueueNetChunk(netChunk);
            }
        }

        public void UpdatePopulationFromServer(NetChunkData data, WorldPos curInChunkPos)
        {
            WorldPos pos = data.worldPos;
            Chunk curChunk = _world.GetChunk(pos.x, pos.y, pos.z);
            if (curChunk != null)
            {
                NetChunk netChunk = new NetChunk(data);
                netChunk.chunk = curChunk;
                netChunk.curPlayerInChunkPos = curInChunkPos;
                _manager.EnqueueUpdatePopulation(netChunk);
            }
        }

        public void UpdateAreaFromServer(RefreshChunkArea area)
        {
            _manager.EnqueueNetUpdateArea(area);
        }

        //(联机使用)
        public void GenerateFromServer(int x, int y, int z)
        {
            WorldPos pos = new WorldPos(x, y, z);
            if (_world.chunks.ContainsKey(pos)) return;
            Chunk newChunk = _world.CreateNewChunk(pos);
            if (newChunk == null) return;
            _world.chunks.Add(newChunk.worldPos, newChunk);
            RequestChunkPackage package = PackageFactory.GetPackage(PackageType.ResquestChunk) as RequestChunkPackage;
            package.roleId = NetManager.Instance.client.roleId;
            package.pos = pos;
            NetManager.Instance.client.SendPackage(package);
        }

        public void RemoveChunk(Chunk chunk)
        {
            chunk.RemoveEntity();
            _world.chunks.Remove(chunk.worldPos);
            _manager.EnqueueSaveChunk(chunk);
        }

        public void LoadNetChunkData(NetChunkData data)
        {
            _manager.EnqueueLoadNetChunkData(data);
        }

        public void RemoveChunkFromClient(NetRemovedChunk removedChunk)
        {
			_manager.EnqueueSaveNetChunk(removedChunk);
        }

        public void RecalculateChunkMeshData(Chunk chunk)
        {
            _manager.EnqueueRender(chunk, true);
        }

        public void ChunkChanged(Chunk chunk, int x, int y, int z, Block block)
        {
            _manager.EnqueuePrevRender(chunk, x, y, z, block);
        }
    }
}

