#region

using System.Collections.Generic;
using System.Threading.Tasks;
using BlockEngine;
using BlockEngine.Math;
using UnityEngine;

#endregion

namespace WorldGeneration.Core
{
    public class GeneratorChunkLoader
    {
        private readonly int _biomeSizeInChunks;
        private readonly int _chunkSize;

        private readonly Dictionary<IntVector2, GeneratorChunk> _chunks = new Dictionary<IntVector2, GeneratorChunk>();
        private readonly World _world;
        private Task _activeTask = null;
        public GeneratorChunkLoader(World world)
        {
            _world = world;
            _chunkSize = world.ChunkSize;
            _biomeSizeInChunks = world.BiomeSizeInChunks;
        }

        public GeneratorChunk GetChunk(IntVector2 gridPosition)
        {
            int x = Mathx.DivideRoundDown(gridPosition.x, _chunkSize);
            int y = Mathx.DivideRoundDown(gridPosition.y, _chunkSize);
            IntVector2 chunkIndex = new IntVector2(x, y);

            return GetChunkByIndex(chunkIndex);
        }

        public GeneratorChunk GetChunk(GeneratorChunk chunk, Direction direction)
        {
            return GetChunkByIndex(chunk.ChunkIndex + direction.Offset());
        }

        public GeneratorChunk GetBiomeChunk(GeneratorChunk chunk)
        {
            return GetBiomeChunk(chunk, IntVector2.ZERO);
        }

        public GeneratorChunk GetBiomeChunk(GeneratorChunk chunk, Direction direction)
        {
            return GetBiomeChunk(chunk, direction.Offset());
        }

        private GeneratorChunk GetBiomeChunk(GeneratorChunk chunk, IntVector2 offset)
        {
            int x = Mathx.DivideRoundDown(chunk.ChunkIndex.x, _biomeSizeInChunks);
            int y = Mathx.DivideRoundDown(chunk.ChunkIndex.y, _biomeSizeInChunks);
            IntVector2 chunkIndex = new IntVector2(x, y);
            chunkIndex += offset;
            chunkIndex *= _biomeSizeInChunks;
            return GetChunkByIndex(chunkIndex);
        }

        private GeneratorChunk GetChunkByIndex(IntVector2 chunkIndex)
        {
            if (!_chunks.ContainsKey(chunkIndex))
            {
                _chunks[chunkIndex] = new GeneratorChunk(this, _world, chunkIndex);
            }
            return _chunks[chunkIndex];
        }

        public GeneratorChunk GetFullyGeneratedChunk(IntVector2 gridPosition)
        {

            GeneratorChunk chunk = GetChunk(gridPosition);
            if (chunk.CurrentState != GeneratorChunk.State.Done)
            {
                
                if (_activeTask != null)
                {
                    if (chunk.CurrentState != GeneratorChunk.State.ReadyToTriggerNeighbours)
                    {
                        _activeTask.Wait();
                    }
                    if (_activeTask.IsCompleted)
                    {
                        _activeTask = null;
                    }
                }
                if (_activeTask == null)
                {
                    chunk.GenerateToState(GeneratorChunk.State.Done);
                    _activeTask = Task.Run(() => PrepareNeighbours(chunk));
                }
            }
            return chunk;

        }

        private void PrepareNeighbours(GeneratorChunk chunk)
        {
            
            foreach (Direction direction in DirectionSupport.VALUES)
            {
                GetChunk(chunk, direction).GenerateToState(GeneratorChunk.State.ReadyToTriggerNeighbours);
            }
        }



    }
}