#region Copyright
// COPYRIGHT 2016 JUSTIN COX (CONJI)
#endregion

using System;
using Welt.API.Forge;
using Welt.API.Forge.Generators;

namespace Welt.Core.Forge
{
    public class World : IWorld
    {
        public string Name { get; }
        public long Seed { get; }
        public int Size { get; }
        public int Height { get; }
        public IForgeGenerator Generator { get; }
        public IWorldSystem System { get; }
        public int SystemIndex { get; }

        protected readonly ChunkManager Manager;
        protected int MaxX => Size*Chunk.Width;
        protected int MaxZ => Size*Chunk.Depth;

        public World(string name, IForgeGenerator gen)
        {
            Name = name;
            var random = new FastMath.LongRandom();
            Seed = random.Next(int.MaxValue)*name.GetHashCode();
            // TODO change Size and Height with IForgeGenerator
            Size = 32;
            Height = 256;
            Generator = gen;
            Manager = new ChunkManager(this);

            System = null;
            SystemIndex = 0;
        }

        public World(string name, long seed, IForgeGenerator gen)
        {
            Name = name;
            Seed = seed;
            Size = 32;
            Generator = gen;
            Manager = new ChunkManager(this);

            System = null;
            SystemIndex = 0;
        }

        /// <summary>
        ///     Creates the chunk and adds it to the chunk manager.
        /// </summary>
        /// <param name="x"></param>
        /// <param name="z"></param>
        /// <returns></returns>
        public Chunk CreateChunk(uint x, uint z)
        {
            var chunk = new Chunk(this, x, z);
            Generator.GenerateChunk(this, chunk);
            _SetChunk(x, z, chunk, ChunkChangedEventArgs.ChunkChangedAction.Created);
            return chunk;
        }

        /// <summary>
        ///     Creates the chunk without adding it, keeping it solely on the stack.
        /// </summary>
        /// <returns></returns>
        public Chunk CreateChunkInMemory(uint x, uint z)
        {
            var chunk = new Chunk(this, x, z);
            Generator.GenerateChunk(this, chunk);
            ChunkChanged?.Invoke(this, new ChunkChangedEventArgs(x, z, ChunkChangedEventArgs.ChunkChangedAction.Created));
            return chunk;
        }

        public Chunk CreateChunkWithoutGeneration(uint x, uint z)
        {
            var chunk = new Chunk(this, x, z);
            _SetChunk(x, z, chunk, ChunkChangedEventArgs.ChunkChangedAction.Created);
            return chunk;
        }

        public Chunk CreateChunkInMemoryWithoutGeneration(uint x, uint z)
        {
            var chunk = new Chunk(this, x, z);
            return chunk;
        }

        public virtual IChunk GetChunk(uint x, uint z)
        {
            var chunk = Manager.GetChunk(x, z) ?? CreateChunk(x, z);
            return chunk;
        }

        public virtual void SetChunk(uint x, uint z, IChunk value)
        {
            _SetChunk(x, z, value, ChunkChangedEventArgs.ChunkChangedAction.Adjusted);
        }

        private void _SetChunk(uint x, uint z, IChunk value, ChunkChangedEventArgs.ChunkChangedAction action)
        {
            Manager.SetChunk(x, z, (Chunk) value);
            ChunkChanged?.Invoke(this, new ChunkChangedEventArgs(x, z, action));
        }

        public virtual void RemoveChunk(uint x, uint z)
        {
            Manager.RemoveChunk(x, z);
            ChunkChanged?.Invoke(this, new ChunkChangedEventArgs(x, z, ChunkChangedEventArgs.ChunkChangedAction.Destroyed));
        }

        public virtual (ushort Id, byte Metadata) GetBlock(uint x, uint y, uint z)
        {
            if (y >= Height) return (0, 0);

            var nx = (uint) (x%MaxX);
            var nz = (uint) (z%MaxZ);

            var chunk = GetChunk(nx/Chunk.Width, nz/Chunk.Depth);
            return chunk.GetBlock((int) (nx%Chunk.Width), (int) y, (int) (nz%Chunk.Depth));
        }

        public virtual void SetBlock(uint x, uint y, uint z, ushort id, byte metadata)
        {
            if (y >= Height) return;

            var nx = (uint) (x%MaxX);
            var nz = (uint) (z%MaxZ);

            var chunk = GetChunk(nx/Chunk.Width, nz/Chunk.Depth);
            chunk.SetBlock((int) (nx%Chunk.Width), (int) y, (int) (nz%Chunk.Depth), id, metadata);
            BlockChanged?.Invoke(this, new BlockChangedEventArgs(nx, y, nz));
        }

        public event EventHandler<BlockChangedEventArgs> BlockChanged;
        public event EventHandler<ChunkChangedEventArgs> ChunkChanged;
    }
}