using IwVoxelGame.Graphics;
using IwVoxelGame.Utils;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Threading;
using System;
using System.Threading.Tasks;

namespace IwVoxelGame.Blocks.World {
    public class World {
        private readonly Dictionary<Vector3i, Chunk> _chunks;
        private readonly Dictionary<Vector3i, Chunk> _loadedChunks;
        private readonly Dictionary<Vector3i, Chunk> _unloadedChunks;
        private readonly Queue<Chunk> m_chunksToBeLoaded;
        private readonly Queue<Chunk> m_chunksToBeUnloaded;
        private readonly Queue<Chunk> m_chunksToBeGenerated;

        private readonly double _chunkTimeout = 10000;

        public Dictionary<Vector3i, Chunk> LoadedChunks => _loadedChunks;

        public World() {
            _chunks = new Dictionary<Vector3i, Chunk>();
            _loadedChunks = new Dictionary<Vector3i, Chunk>();
            _unloadedChunks = new Dictionary<Vector3i, Chunk>();
            m_chunksToBeLoaded = new Queue<Chunk>();
            m_chunksToBeUnloaded = new Queue<Chunk>();
            m_chunksToBeGenerated = new Queue<Chunk>();
        }

        public void LoadChunk(Vector3i position) {
            if(_unloadedChunks.ContainsKey(position)) {
                SetLoadChunk(_unloadedChunks[position]);
                return;
            }

            if (!_loadedChunks.TryGetValue(position, out Chunk chunk)) {
                chunk = new Chunk(this, position);

                SetLoadChunk(chunk);

                if (!chunk.HasBeenGenerated) {
                    Task.Factory.StartNew(() => { GenerateChunk(chunk); });
                }
            }
        }

        public void SetLoadChunk(Chunk chunk) {
            chunk.LoadTime = Time.GameTime;
            _loadedChunks.Add(chunk.Position, chunk);
            _unloadedChunks.Remove(chunk.Position);
        }

        public void UnloadChunk(Chunk chunk) {
            _loadedChunks.Remove(chunk.Position);
            _unloadedChunks.Add(chunk.Position, chunk);
        }

        private void GenerateChunk(Chunk chunk) {
            chunk.Generate();
            m_chunksToBeLoaded.Enqueue(chunk);
        }

        public void Update(Camera camera) {
            //Queue unload world
            lock (_loadedChunks) {
                foreach (Chunk chunk in _loadedChunks.Values) {
                    if (Time.GameTime - chunk.LoadTime > _chunkTimeout) {
                        m_chunksToBeUnloaded.Enqueue(chunk);
                    }
                }
            }

            //Unload chunks
            lock(m_chunksToBeUnloaded) {
                while(m_chunksToBeUnloaded.Count > 0) {
                    UnloadChunk(m_chunksToBeUnloaded.Dequeue());

                    Logger.Debug($"Loaded chunks: {_loadedChunks.Count}   Unloaded chunks: {_unloadedChunks.Count}");
                }
            }

            //Load chunks
            lock (m_chunksToBeLoaded) {
                while (m_chunksToBeLoaded.Count > 0) {
                    m_chunksToBeLoaded.Dequeue()?.Update();

                    Logger.Debug($"Loaded chunks: {_loadedChunks.Count}   Unloaded chunks: {_unloadedChunks.Count}");
                }
            }

            //Load world
            LoadWorldAroundPlayer(camera.transform.GetChunk(), 4);
        }

        public void SetBlock(Vector3i worldPos, Block block) {
            var position = FormatPosition(worldPos);
            if (_chunks.TryGetValue(position.chunkPos, out Chunk chunk)) {
                chunk.SetBlock(position.blockPos, block);
            }
            else {
                LoadChunk(position.chunkPos);
                SetBlock(worldPos, block);
            }
        }

        public Block GetBlock(Vector3i worldPos) {
            var position = FormatPosition(worldPos);

            if (_chunks.TryGetValue(worldPos, out Chunk chunk)) {
                return chunk.GetBlock(position.blockPos);
            }
            else {
                return null;
            }
        }

        private void LoadWorldAroundPlayer(Vector3i position, int maxChunkDistance) {
            Vector3i start = new Vector3i(
                position.X - maxChunkDistance,
                position.Y - maxChunkDistance,
                position.Z - maxChunkDistance
                );

            Vector3i end = start + maxChunkDistance * 2;

            for (int x = start.X; x < end.X; x++) {
                for (int y = start.Y; y < end.Y; y++) {
                    for (int z = start.Z; z < end.Z; z++) {
                        LoadChunk(new Vector3i(x, y, z));
                    }
                }
            }
        }

        private (Vector3i chunkPos, Vector3i blockPos) FormatPosition(Vector3i position) {
            Vector3i chunkPos = new Vector3i(
                position.X < 0 ? (position.X + 1) / Chunk.Size - 1 : position.X / Chunk.Size,
                position.Y < 0 ? (position.Y + 1) / Chunk.Size - 1 : position.Y / Chunk.Size,
                position.Z < 0 ? (position.Z + 1) / Chunk.Size - 1 : position.Z / Chunk.Size);

            Vector3i blockPos = new Vector3i(
                position.X < 0 ? (position.X + 1) % Chunk.Size + Chunk.Size - 1 : position.X % Chunk.Size,
                position.Y < 0 ? (position.Y + 1) % Chunk.Size + Chunk.Size - 1 : position.Y % Chunk.Size,
                position.Z < 0 ? (position.Z + 1) % Chunk.Size + Chunk.Size - 1 : position.Z % Chunk.Size);

            return (chunkPos, blockPos);
        }
    }
}
