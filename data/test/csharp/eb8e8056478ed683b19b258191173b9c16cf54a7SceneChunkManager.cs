using System;
using System.Threading;
using System.Threading.Tasks;
using System.Collections.Concurrent;
using System.Collections.Generic;
using Microsoft.Xna.Framework;
using VoxEngine.Voxels;
using LibNoise;

namespace VoxEngine.Managers
{
    public class SceneChunkManager : GameComponent
    {
        private static ConcurrentDictionary<Vector3, Chunk> _chunks = new ConcurrentDictionary<Vector3, Chunk>();
        public static ConcurrentDictionary<Vector3, Chunk> Chunks
        {
            get { return _chunks; }
        }

        private static bool _initialized = false;
        public static bool Initialized
        {
            get { return _initialized; }
        }

        private static Perlin _perlin;
        public static Perlin Perlin
        {
            get { return _perlin; }
        }

        private static byte _chunkSize;
        public static byte ChunkSize
        {
            get { return _chunkSize; }
        }

        #region Threaded Chunk Management

        #endregion


        private static List<Vector3> _dirtyVoxels = new List<Vector3>();
        public static List<Vector3> DirtyVoxels
        {
            get { return _dirtyVoxels; }
            set { _dirtyVoxels = value; }
        }
        

        public SceneChunkManager(Game game, byte chunkSize) : base(game)
        {
            _chunkSize = chunkSize;
            Enabled = true;
        }

        public override void Initialize()
        {
            base.Initialize();

            _perlin = new Perlin();
            _perlin.Frequency = 0.008f;
            _perlin.Lacunarity = 1f;
            _perlin.NoiseQuality = NoiseQuality.Standard;
            _perlin.OctaveCount = 1;
            _perlin.Persistence = 0.1f;
            _perlin.Seed = 100;

            ThreadManager.CreateThread("ChunkManager", ManageChunks);
            int meshThreads = 4;
            for(int i=0;i<meshThreads;i++)
                ThreadManager.CreateThread("ChunkMesh"+i, ManageChunkMeshing);
            ThreadManager.CreateThread("PriorityChunkMesh", ManagePriorityChunkMeshing);

            _initialized = true;
        }

        private static BlockingCollection<Tuple<Action<object>, object>> _chunkManagerEventQueue = new BlockingCollection<Tuple<Action<object>, object>>();
        private static List<Tuple<Action<object>, object>> _chunkManagerEventList = new List<Tuple<Action<object>, object>>();

        private static BlockingCollection<Action> _chunkManagerMeshQueue = new BlockingCollection<Action>();
        public static List<Action> _chunkManagerMeshList = new List<Action>();
        private static BlockingCollection<Action> _chunkManagerPriorityMeshQueue = new BlockingCollection<Action>();
        public static List<Action> _chunkManagerPriorityMeshList = new List<Action>();

        void ManageChunkMeshing()
        {
            while (true)
                foreach (var workItem in _chunkManagerMeshQueue.GetConsumingEnumerable())
                    workItem();
        }

        void ManagePriorityChunkMeshing()
        {
            while (true)
                foreach (var workItem in _chunkManagerPriorityMeshQueue.GetConsumingEnumerable())
                    workItem();
        }

        void ManageChunks()
        {
            while (true)
            {
                foreach (var workItem in _chunkManagerEventQueue.GetConsumingEnumerable())
                    workItem.Item1(workItem.Item2);
            }
        }

        void HandleQueues()
        {
            if (_chunkManagerEventQueue.Count == 0 && _chunkManagerEventList.Count > 0)
            {
                foreach (var item in _chunkManagerEventList)
                    _chunkManagerEventQueue.TryAdd(item);
                _chunkManagerEventList.Clear();
            }
            if (_chunkManagerMeshQueue.Count == 0 && _chunkManagerMeshList.Count > 0)
            {
                foreach (var item in _chunkManagerMeshList)
                    _chunkManagerMeshQueue.TryAdd(item);
                _chunkManagerMeshList.Clear();
            }
            if (_chunkManagerPriorityMeshQueue.Count == 0 && _chunkManagerPriorityMeshList.Count > 0)
            {
                foreach (var item in _chunkManagerPriorityMeshList)
                    _chunkManagerPriorityMeshQueue.TryAdd(item);
                _chunkManagerPriorityMeshList.Clear();
            }
        }

        public static void Draw(GameTime gameTime)
        {
            foreach (Chunk chunk in _chunks.Values)
                chunk.Draw(gameTime);
        }

        public static void DrawDebug(GameTime gameTime)
        {
            foreach (Chunk chunk in _chunks.Values)
                chunk.DrawDebug(gameTime);
        }
        
        public override void Update(GameTime gameTime)
        {
            base.Update(gameTime);

            HandleQueues();

            foreach (Chunk chunk in _chunks.Values)
                chunk.Update(gameTime);
        }
        
        private static void RemoveChunk(object o)
        {
            Vector3 chunkPos = (Vector3)o;
            Chunk tempChunk;
            if (!_chunks.TryGetValue(chunkPos, out tempChunk))
                return;
            //tempChunk.UnloadContent();
            _chunks.TryRemove(chunkPos, out tempChunk);
        }
        public static void RemoveChunk(Vector3 chunkPos)
        {
            _chunkManagerEventList.Add(new Tuple<Action<object>, object>(RemoveChunk, chunkPos));
        }

        private static void AddChunk(object o)
        {
            Vector3 chunkPos = (Vector3)o;
            Chunk tempChunk;
            if (_chunks.TryGetValue(chunkPos, out tempChunk))
                return;
            tempChunk = new Chunk(_chunkSize, chunkPos);
            tempChunk.LoadContent();
            _chunkManagerEventQueue.TryAdd(new Tuple<Action<object>, object>(GenerateChunk, tempChunk));
            _chunks.TryAdd(chunkPos, tempChunk);
            //_chunkManagerEventQueue.TryAdd(new Tuple<Action<object>, object>(DirtySurroundingChunks, chunkPos));
        }
        public static void AddChunk(Vector3 chunkPos)
        {
            _chunkManagerEventList.Add(new Tuple<Action<object>, object>(AddChunk, chunkPos));
        }

        public static void AddChunkColumn(Vector2 chunkPos)
        {
            for (int y = 0; y < 8; y++)
                AddChunk(new Vector3(chunkPos.X, y, chunkPos.Y));
        }

        private static void DirtySurroundingChunks(object o)
        {
            Vector3 mainChunkPos = (Vector3)o;
            Chunk tempChunk;
            for (int x = -1; x <= 1; x++)
            {
                for (int y = 0; y <= 0; y++)
                {
                    for (int z = -1; z <= 1; z++)
                    {
                        if (x == 0 && y == 0 && z == 0)
                            continue;
                        _chunks.TryGetValue(mainChunkPos + new Vector3(x, y, z), out tempChunk);
                        if (tempChunk != null)
                            tempChunk.Dirty = true;
                    }
                }
            }
        }
        
        public static Chunk GetChunk(Vector3 chunkPos)
        {
            Chunk tempChunk = null;
            Vector3 chunkPosition = new Vector3((int)System.Math.Floor(chunkPos.X / _chunkSize), (int)System.Math.Floor(chunkPos.Y / _chunkSize), (int)System.Math.Floor(chunkPos.Z / _chunkSize));
            _chunks.TryGetValue(chunkPosition, out tempChunk);
            return tempChunk;
        }

        public static ushort GetVoxel(int x, int y, int z)
        {
            Chunk tempChunk = GetChunk(new Vector3(x, y, z));
            if (tempChunk == null)
                return 0;
            return tempChunk.GetVoxel(x, y, z);
        }

        public static void SetVoxel(int x, int y, int z, ushort voxel)
        {
            Chunk tempChunk = GetChunk(new Vector3(x, y, z));
            if (tempChunk == null)
                return;
            tempChunk.SetVoxel(x, y, z, voxel);
        }

        public static void GenerateChunk(object o)
        {
            Chunk tempChunk = (Chunk)o;
            tempChunk.Editing = true;
            for (int x = (int)tempChunk.Position.X; x < (int)tempChunk.Position.X + tempChunk.Size; x++)
            {
                for (int z = (int)tempChunk.Position.Z; z < (int)tempChunk.Position.Z + tempChunk.Size; z++)
                {
                    byte baseHeight = 64;
                    byte variance = 5;
                    double height = (_perlin.GetValue(x, 0, z) + 0.25) * variance + baseHeight;
                    
                    for (int y = (int)tempChunk.Position.Y; y < (int)tempChunk.Position.Y + tempChunk.Size; y++)
                    {
                        if (y < height - 3)
                            tempChunk.SetVoxel(x, y, z, 1);
                        else if (y < height - 1)
                            tempChunk.SetVoxel(x, y, z, 2);
                        else if (y < height)
                            tempChunk.SetVoxel(x, y, z, 3);
                    }
                }
            }
            tempChunk.Editing = false;
        }
    }
}