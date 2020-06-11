using Assets.Scripts.AccessLayer.Material;
using Assets.Scripts.Algorithms.Pathfinding.Utils;
using Assets.Scripts.EngineLayer.Voxels.Containers;
using Assets.Scripts.EngineLayer.Voxels.Containers.Chunks;
using Assets.Scripts.EngineLayer.Voxels.Data;
using Assets.Scripts.EngineLayer.Voxels.Material;
using UnityEngine;

namespace Assets.Scripts.AccessLayer.Worlds
{
    public class World
    {
        public static WorldPosition At(Vector3 v)
        {
            return new WorldPosition(v);
        }
        
        public static WorldPosition At(float x, float y, float z)
        {
            return new WorldPosition(new Vector3(x, y, z));
        }
    }

    public class WorldPosition
    {
        private readonly Vector3I _v;

        public WorldPosition(Vector3 v)
        {
            _v = v;
        }

        public void SetVoxel(VoxelMaterial material)
        {
            var chunkData = GetChunkData() ?? CreateChunk();
            chunkData.SetVoxel(_v.x % Chunk.ChunkSize, _v.y % Chunk.ChunkSize, _v.z % Chunk.ChunkSize, material);
        }

        public void SetVoxel(string type)
        {
            SetVoxel(MaterialRegistry.Instance.GetMaterialFromName(type));
        }

        public VoxelMaterial GetMaterial()
        {
            var chunkData = GetChunkData();
            return chunkData == null ? MaterialRegistry.Instance.MaterialFromId(0) : chunkData.GetVoxelType(_v.x % Chunk.ChunkSize, _v.y % Chunk.ChunkSize, _v.z % Chunk.ChunkSize);
        }

        public bool IsAir()
        {
            var chunkData = GetChunkData();
            return chunkData == null || !chunkData.GetVoxelActive(_v.x % Chunk.ChunkSize, _v.y % Chunk.ChunkSize, _v.z % Chunk.ChunkSize);
        }

        private ChunkData CreateChunk()
        {
            var cx = _v.x / Chunk.ChunkSize;
            var cy = _v.y / Chunk.ChunkSize;
            var cz = _v.z / Chunk.ChunkSize;
            return Map.Instance.MapData.Chunks[cx, cy, cz] = Map.Instance.CreateChunk(cx, cy, cz);
        }

        public ChunkData GetChunkData()
        {
            var cx = _v.x / Chunk.ChunkSize;
            var cy = _v.y / Chunk.ChunkSize;
            var cz = _v.z / Chunk.ChunkSize;
            return Map.Instance.IsInBounds(_v.x, _v.y, _v.z) ? Map.Instance.MapData.Chunks[cx, cy, cz] : null;
        }
    }
}
