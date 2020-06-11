using EveFortressModel.Components;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EveFortressModel
{
    public class ChunkManager : IResetNeeded
    {
        public Dictionary<Point<long>, Chunk> LoadedChunks { get; set; }

        public ChunkManager()
        {
            LoadedChunks = new Dictionary<Point<long>, Chunk>();
        }

        public Chunk GetChunk(Point<long> loc)
        {
            Chunk chunk;
            LoadedChunks.TryGetValue(loc, out chunk);
            return chunk;
        }

        public void AddChunk(Chunk chunk)
        {
            LoadedChunks[chunk.Loc] = chunk;
        }

        public void UnloadChunk(Point<long> loc)
        {
            LoadedChunks.Remove(loc);
        }

        public void MoveEntity(Point<long> previousLoc, Point<long> newLoc, long ID)
        {
            var previousChunkLoc = Chunk.GetChunkCoords(previousLoc);
            var previousChunk = GetChunk(previousChunkLoc);
            if (previousChunk != null)
            {
                var entity = previousChunk.Entities[ID];
                entity.Position = newLoc;
                if (!previousChunk.ContainsLoc(newLoc))
                {
                    previousChunk.Entities.Remove(ID);
                    var newChunkLoc = Chunk.GetChunkCoords(newLoc);
                    var newChunk = GetChunk(newChunkLoc);
                    if (newChunk != null)
                    {
                        newChunk.Entities[ID] = entity;
                    }
                }
            }
        }

        public void PatchEntity(Point<long> loc, long ID, Dictionary<Component, bool> changes)
        {
            var chunkLoc = Chunk.GetChunkCoords(loc);
            var chunk = GetChunk(chunkLoc);
            if (chunk != null)
            {
                if (chunk.Entities.ContainsKey(ID))
                {
                    chunk.Entities[ID].ApplyStateChanges(changes);
                }
            }
        }

        public void Reset()
        {
            LoadedChunks.Clear();
        }
    }
}
