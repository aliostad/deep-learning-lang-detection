using System.Collections.Generic;
using Assets.Scripts.voxel.Helpers;
using Assets.Scripts.voxel.Structs;
using UnityEngine;

namespace Assets.Scripts.voxel
{
    public class LoadChunks : MonoBehaviour
    {
        private readonly List<WorldPos> _buildList = new List<WorldPos>();
        private readonly List<WorldPos> _updateList = new List<WorldPos>();
        public World World;
        private WorldPos _initialPos;
        private int _timer;

        private void Start()
        {
            _initialPos = new WorldPos(
                Mathf.FloorToInt(transform.position.x/Chunk.ChunkSize)*Chunk.ChunkSize,
                Mathf.FloorToInt(transform.position.y/Chunk.ChunkSize)*Chunk.ChunkSize,
                Mathf.FloorToInt(transform.position.z/Chunk.ChunkSize)*Chunk.ChunkSize
                );

            PushChunkToBuildList(_initialPos);
            LoadAndRenderChunks();
        }

        private void Update()
        {
            DeleteChunks();
            FindChunksToLoad();
            LoadAndRenderChunks();
        }

        private void DeleteChunks()
        {
            if (_timer == 10)
            {
                var chunksToDelete = new List<WorldPos>();
                foreach (var chunk in World.Chunks)
                {
                    var distance = Vector3.Distance(
                        new Vector3(chunk.Value.WorldPos.X, 0, chunk.Value.WorldPos.Z),
                        new Vector3(transform.position.x, 0, transform.position.z));

                    if (distance > 256)
                        chunksToDelete.Add(chunk.Key);
                }

                foreach (var chunk in chunksToDelete)
                    World.DestroyChunk(chunk.X, chunk.Y, chunk.Z);

                _timer = 0;
            }

            _timer++;
        }

        private void BuildChunk(WorldPos pos)
        {
            if (World.GetChunk(pos.X, pos.Y, pos.Z) == null)
                World.CreateChunk(pos.X, pos.Y, pos.Z);

            _updateList.Add(pos);
        }

        private void LoadAndRenderChunks()
        {
            for (var i = 0; i < 4; i++)
            {
                if (_buildList.Count == 0)
                    continue;

                BuildChunk(_buildList[0]);
                _buildList.RemoveAt(0);
            }

            for (var i = 0; i < _updateList.Count; i++)
            {
                var chunk = World.GetChunk(_updateList[0].X, _updateList[0].Y, _updateList[0].Z);
                if (chunk != null)
                    chunk.ShouldUpdate = true;

                _updateList.RemoveAt(0);
            }
        }

        private void FindChunksToLoad()
        {
            var playerPos = new WorldPos(
                Mathf.FloorToInt(transform.position.x/Chunk.ChunkSize)*Chunk.ChunkSize,
                Mathf.FloorToInt(transform.position.y/Chunk.ChunkSize)*Chunk.ChunkSize,
                Mathf.FloorToInt(transform.position.z/Chunk.ChunkSize)*Chunk.ChunkSize
                );

            if (_buildList.Count != 0)
                return;

            for (var x = -1; x < 3; x++)
            {
                for (var z = -1; z < 3; z++)
                {
                    var newX = x*Chunk.ChunkSize;
                    var newZ = z*Chunk.ChunkSize;

                    var newChunkPos = playerPos.CloneWithAdd(newX, 0, newZ);

                    if (PushChunkToBuildList(newChunkPos))
                        return;
                }
            }
        }

        private bool PushChunkToBuildList(WorldPos playerPos)
        {
            var newChunkPos = playerPos;
            var newChunk = World.GetChunk(newChunkPos);

            if (newChunk != null && newChunk.Rendered || _updateList.Contains(newChunkPos))
                return false;

            for (var y = -4; y < 4; y++)
            {
                _buildList.Add(new WorldPos(newChunkPos.X, y*Chunk.ChunkSize, newChunkPos.Z));
            }

            return true;
        }
    }
}