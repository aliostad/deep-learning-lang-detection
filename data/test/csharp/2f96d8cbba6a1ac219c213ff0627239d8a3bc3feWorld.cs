using System.Collections.Generic;
using System.Linq;
using Assets.Code.GenerationEngine;
using Assets.Code.Tasker;
using Assets.Code.World.Chunks;
using Assets.Code.WorldObjects;
using Assets.Code.WorldObjects.Static;
using Frankfort.Threading;
using UnityEngine;

namespace Assets.Code.World
{
    public class World : MonoBehaviour
    {
        public Dictionary<Position, Chunk> Chunks = new Dictionary<Position, Chunk>();

        public static World Instance;

        public GameObject ChunkPrefab;

        public GameObject ColliderCube;

        public static Generator Generator;
        
        public void CreateNewChunkCallback(Position position, Chunk chunk)
        {
            Chunks[position] = chunk;
        }
        
        void Awake()
        {
            Instance = this;
            Generator = new Generator();
        }

        void Start()
        {
            Generator.Start();
        }
        
        void OnDestroy()
        {
            Generator.Abort();
        }
        
        public Chunk GetChunk(Position position)
        {
            Position snappedPosition = new Position
            {
                x = Mathf.FloorToInt(position.x/(float) WorldSettings.ChunkSize)*WorldSettings.ChunkSize,
                y = Mathf.FloorToInt(position.y/(float) WorldSettings.ChunkSize)*WorldSettings.ChunkSize,
                z = Mathf.FloorToInt(position.z/(float) WorldSettings.ChunkSize)*WorldSettings.ChunkSize
            };

            Chunk containerChunk;

            Chunks.TryGetValue(snappedPosition, out containerChunk);

            return containerChunk;
        }

        public WorldObject GetObject(Position position)
        {
            Chunk containerChunk = GetChunk(position);

            if (containerChunk != null)
            {
                WorldObject block = containerChunk.GetObject(position - containerChunk.Position);

                return block;
            }
            
            return new Air();
        }

        public void SetObject(Position position, WorldObject worldObject, bool replace = false)
        {
            Chunk chunk = GetChunk(position);
            
            if (chunk != null)
            {
                chunk.SetObject(position, worldObject, replace);

                UpdateIfNeighbour(position.x - chunk.Position.x, 0, new Position(position.x - 1, position.y, position.z));
                UpdateIfNeighbour(position.x - chunk.Position.x, WorldSettings.ChunkSize - 1, new Position(position.x + 1, position.y, position.z));
                UpdateIfNeighbour(position.y - chunk.Position.y, 0, new Position(position.x, position.y - 1, position.z));
                UpdateIfNeighbour(position.y - chunk.Position.y, WorldSettings.ChunkSize - 1, new Position(position.x, position.y + 1, position.z));
                UpdateIfNeighbour(position.z - chunk.Position.z, 0, new Position(position.x, position.y, position.z - 1));
                UpdateIfNeighbour(position.z - chunk.Position.z, WorldSettings.ChunkSize - 1, new Position(position.x, position.y, position.z + 1));
            }
        }

        void UpdateIfNeighbour(int value1, int value2, Position position)
        {
            if (value1 == value2)
            {
                Chunk chunk = GetChunk(position);

                if (chunk != null)
                    chunk.DoRebuild();
            }
        }
    }
}
