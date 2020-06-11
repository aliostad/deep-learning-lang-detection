using UnityEngine;
using System.Collections;
using System.Collections.Generic;
namespace MTB
{
    [RequireComponent(typeof(WorldRenderer))]
    public class World : MonoBehaviour
    {
        private static World _world;
        public static World world { get { return _world; } }

        private Queue<Chunk> _cacheChunks;

        public Dictionary<WorldPos, Chunk> chunks = new Dictionary<WorldPos, Chunk>(200, new WorldPosComparer());
        public GameObject chunkPrefab;
        public bool editorMode;

        private WorldGenerator _worldGenerator;
        public WorldGenerator WorldGenerator { get { return _worldGenerator; } }

        private IWorldLoader _worldLoader;
        public IWorldLoader WorlderLoader { get { return _worldLoader; } }

		public bool FirstGeneted{get;private set;}

        public static int MaxHeight = Chunk.chunkHeight;
        public static int MinHeight = 0;

        public Vector3 generatorPos { get; set; }

        public NetType netType { get; set; }

        public static void Generate(string path, Vector3 pos, NetType netType)
        {
            GameObject worldObject = GameObject.Instantiate(Resources.Load(path) as GameObject);
            _world = worldObject.GetComponent<World>();
            _world.generatorPos = pos;
            _world.netType = netType;
        }

        public void Awake()
        {
            _worldGenerator = new WorldGenerator(this);
            MTBPathFinder.Instance.Init(this);
        }

        public void Start()
        {
            ChangeLoader(netType);
            int extendChunkWidth = WorldConfig.Instance.extendChunkWidth;
            InitCacheChunks((extendChunkWidth * 2 + 1) * (extendChunkWidth * 2 + 1) - extendChunkWidth * extendChunkWidth);
			EventManager.RegisterEvent(EventMacro.GENERATE_FIRST_WORLD_FINISH, OnFirstWorldGenerated);
			FirstGeneted = false;
			_worldLoader.LoadFirst(generatorPos, extendChunkWidth > 7 ? 7 : extendChunkWidth);
            _worldLoader.Start();
            _worldGenerator.StartWorldGenerator();
        }

		private void OnFirstWorldGenerated(object[] param)
		{
			EventManager.UnRegisterEvent(EventMacro.GENERATE_FIRST_WORLD_FINISH, OnFirstWorldGenerated);
			FirstGeneted = true;
		}

        public void ChangeLoader(NetType netType)
        {
            if (_worldLoader != null)
            {
                _worldLoader.Stop();
                _worldLoader.Dispose();
            }
            if (editorMode)
            {
                _worldLoader = new EditorWorldLoader(this);
            }
            else
            {
                if (netType == NetType.Single)
                {
                    _worldLoader = new SingleWorldLoader(this);
                }
                else
                {
                    _worldLoader = new NetWorldLoader(this);
                }
            }
        }

        public void saveAll()
        {
            _worldLoader.SaveAll();
        }

        void Update()
        {
            _worldLoader.Update();
        }

        public float showSplashTimeout = 1.0F;
        private static bool allowQuitting = false;

        void OnApplicationQuit()
        {
            StartCoroutine(DelayedQuit());
            if (!allowQuitting)
                Application.CancelQuit();
        }
        IEnumerator DelayedQuit()
        {
            _worldLoader.Dispose();
            _worldGenerator.Dispose();
            yield return new WaitForSeconds(showSplashTimeout);
            allowQuitting = true;
            Application.Quit();
        }

        public void InitCacheChunks(int size)
        {
            _cacheChunks = new Queue<Chunk>(size);
            for (int i = 0; i < size; i++)
            {
                Chunk chunk = new Chunk();
                _cacheChunks.Enqueue(chunk);
            }
        }
        public Chunk CreateNewChunk(WorldPos pos, bool needNew = false)
        {
            Chunk chunk;
            if (_cacheChunks.Count > 0)
            {
                chunk = _cacheChunks.Dequeue();
            }
            else
            {
                if (needNew)
                {
                    chunk = new Chunk();
                }
                else return null;
            }
            chunk.worldPos = pos;
            chunk.world = this;
            return chunk;
        }

        public void DisposeChunk(Chunk chunk)
        {
            chunk.Dispose();
            _cacheChunks.Enqueue(chunk);
        }

        public void InstantiateChunkGameObject(Chunk chunk)
        {
            GameObject newChunkObject = Instantiate(chunkPrefab, new Vector3(chunk.worldPos.x, chunk.worldPos.y, chunk.worldPos.z), Quaternion.Euler(Vector3.zero)) as GameObject;
            string name = "chunk_" + chunk.worldPos.x + "_" + chunk.worldPos.y + "_" + chunk.worldPos.z;
            Transform temp = gameObject.transform.Find(name);
            if (temp != null)
            {
                Debug.Log(name);
            }
            newChunkObject.name = name;
            newChunkObject.GetComponent<Transform>().parent = gameObject.transform;
            chunk.chunkObj = newChunkObject.GetComponent<ChunkObj>();
            chunk.chunkObj.chunk = chunk;
        }
        //可能是没有数据的空块，请判断chunk.isTerrainDataPrepared
        public Chunk GetChunk(int x, int y, int z)
        {
            WorldPos pos = Terrain.GetChunkPos(x, y, z);
            Chunk outputChunk = null;
            Watcher.instance.worldDictTimes += 1;
            chunks.TryGetValue(pos, out outputChunk);
            return outputChunk;
        }
        //获取到围绕Chunk所在块周围方向为direction的块
        public Chunk GetChunkAround(Chunk chunk, Direction direction)
        {
            WorldPos pos;
            switch (direction)
            {
                case Direction.front:
                    pos = new WorldPos(chunk.worldPos.x, chunk.worldPos.y, chunk.worldPos.z + Chunk.chunkDepth);
                    break;
                case Direction.back:
                    pos = new WorldPos(chunk.worldPos.x, chunk.worldPos.y, chunk.worldPos.z - Chunk.chunkDepth);
                    break;
                case Direction.left:
                    pos = new WorldPos(chunk.worldPos.x - Chunk.chunkWidth, chunk.worldPos.y, chunk.worldPos.z);
                    break;
                case Direction.right:
                    pos = new WorldPos(chunk.worldPos.x + Chunk.chunkWidth, chunk.worldPos.y, chunk.worldPos.z);
                    break;
                case Direction.up:
                    pos = new WorldPos(chunk.worldPos.x, chunk.worldPos.y + Chunk.chunkHeight, chunk.worldPos.z);
                    break;
                case Direction.down:
                    pos = new WorldPos(chunk.worldPos.x, chunk.worldPos.y - Chunk.chunkHeight, chunk.worldPos.z);
                    break;
                default:
                    throw new UnityException("不存在当前传入的方向!");
            }
            return GetChunk(pos.x, pos.y, pos.z);
        }
        //可能是没有数据的空块，请判断chunk.isTerrainDataPrepared

        public List<Chunk> GetAroundChunks(Chunk chunk)
        {
            List<Chunk> aroundChunks = new List<Chunk>();
            for (int x = -1; x <= 1; x++)
            {
                for (int z = -1; z <= 1; z++)
                {
                    if (x == 0 && z == 0) continue;
                    Chunk c = GetChunk(chunk.worldPos.x + x * Chunk.chunkWidth, chunk.worldPos.y, chunk.worldPos.z + z * Chunk.chunkDepth);
                    if (c != null)
                        aroundChunks.Add(c);
                }
            }
            return aroundChunks;
        }

        public List<Chunk> GetAroundChunks(Chunk chunk, List<Chunk> list)
        {
            for (int x = -1; x <= 1; x++)
            {
                for (int z = -1; z <= 1; z++)
                {
                    if (x == 0 && z == 0) continue;
                    Chunk c = GetChunk(chunk.worldPos.x + x * Chunk.chunkWidth, chunk.worldPos.y, chunk.worldPos.z + z * Chunk.chunkDepth);
                    if (c != null)
                        list.Add(c);
                }
            }
            return list;
        }

        public Section GetSection(int x, int y, int z)
        {
            Chunk chunk = GetChunk(x, y, z);
            if (chunk != null && chunk.isTerrainDataPrepared)
            {
                return chunk.GetSection(x - chunk.worldPos.x, y - chunk.worldPos.y, z - chunk.worldPos.z);
            }
            return null;
        }

        public Block GetBlock(int x, int y, int z)
        {
            Chunk chunk = GetChunk(x, y, z);
            if (chunk != null && chunk.isTerrainDataPrepared)
            {
                Block block = chunk.GetBlock(x - chunk.worldPos.x, y - chunk.worldPos.y, z - chunk.worldPos.z, true);
                return block;
            }
            else
            {
                return new Block(BlockType.Null);
            }
        }

        public void SetBlock(int x, int y, int z, Block block)
        {
            Chunk chunk = GetChunk(x, y, z);
            if (chunk != null && chunk.isTerrainDataPrepared)
            {
                int tempX = x - chunk.worldPos.x;
                int tempY = y - chunk.worldPos.y;
                int tempZ = z - chunk.worldPos.z;
                chunk.SetBlock(tempX, tempY, tempZ, block, true);
            }
        }

        public void CheckAndRecalculateMesh(int x, int y, int z, Block block)
        {
            Chunk chunk = GetChunk(x, y, z);
            CheckAndRecalculateMesh(chunk, x - chunk.worldPos.x, y - chunk.worldPos.y, z - chunk.worldPos.z, block);
        }

        public void CheckAndRecalculateMesh(Chunk chunk, int x, int y, int z, Block block)
        {
            if (chunk != null && chunk.isTerrainDataPrepared)
            {
                _worldGenerator.ChunkChanged(chunk, x, y, z, block);
            }
        }

        public int GetBiomeId(int x, int z)
        {
            Chunk chunk = GetChunk(x, 0, z);
            if (chunk != null && chunk.isTerrainDataPrepared)
            {
                return chunk.GetBiomeId(x - chunk.worldPos.x, z - chunk.worldPos.z, true);
            }
            return -1;
        }

        public void SetBiomeId(int x, int z, int biomeId)
        {
            Chunk chunk = GetChunk(x, 0, z);
            if (chunk != null && chunk.isTerrainDataPrepared)
            {
                chunk.SetBiomeId(x - chunk.worldPos.x, z - chunk.worldPos.z, biomeId, true);
            }
        }

        public int GetHeight(int x, int z)
        {
            Chunk chunk = GetChunk(x, 0, z);
            if (chunk != null && chunk.isPopulationDataPrepared)
            {
                return chunk.GetHeight(x - chunk.worldPos.x, z - chunk.worldPos.z, true);
            }
            return -1;
        }

        public void SetHeight(int x, int z, int height)
        {
            Chunk chunk = GetChunk(x, 0, z);
            if (chunk != null && chunk.isPopulationDataPrepared)
            {
                chunk.SetHeight(x - chunk.worldPos.x, z - chunk.worldPos.z, height, true);
            }
        }

        public int GetSunLight(int x, int y, int z)
        {
            Chunk chunk = GetChunk(x, 0, z);
            if (chunk != null && chunk.isPopulationDataPrepared)
            {
                return chunk.GetSunLight(x - chunk.worldPos.x, y - chunk.worldPos.y, z - chunk.worldPos.z, true);
            }
            return 0;
        }

        public void SetSunLight(int x, int y, int z, int value)
        {
            Chunk chunk = GetChunk(x, 0, z);
            if (chunk != null && chunk.isPopulationDataPrepared)
            {
                chunk.SetSunLight(x - chunk.worldPos.x, y - chunk.worldPos.y, z - chunk.worldPos.z, value, true);
            }
        }

        public int GetBlockLight(int x, int y, int z)
        {
            Chunk chunk = GetChunk(x, 0, z);
            if (chunk != null && chunk.isPopulationDataPrepared)
            {
                return chunk.GetBlockLight(x - chunk.worldPos.x, y - chunk.worldPos.y, z - chunk.worldPos.z, true);
            }
            return 0;
        }

        public void SetBlockLight(int x, int y, int z, int value)
        {
            Chunk chunk = GetChunk(x, 0, z);
            if (chunk != null && chunk.isPopulationDataPrepared)
            {
                chunk.SetBlockLight(x - chunk.worldPos.x, y - chunk.worldPos.y, z - chunk.worldPos.z, value, true);
            }
        }
    }
}
