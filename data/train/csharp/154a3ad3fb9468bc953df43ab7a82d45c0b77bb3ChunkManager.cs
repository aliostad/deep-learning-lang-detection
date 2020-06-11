using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Xna.Framework;
using Voxel.Engine.World;

using SharpNoise.Modules;

namespace Voxel.Engine.Managers
{
    public class ChunkManager : BaseManager
    {
        private Dictionary<Vector3, Chunk> chunks;
        public Dictionary<Vector3, Chunk> Chunks
        {
            get { return chunks; }
        }

        private Perlin perlin;
        public Perlin Perlin
        {
            get { return perlin; }
        }

        public ChunkManager(SceneGame game) : base(game)
        {
            this.chunks = new Dictionary<Vector3, Chunk>();
            this.perlin = new Perlin();

            Initialize();
        }

        protected override void Initialize()
        {
            perlin.Seed = 1414;
            perlin.OctaveCount = 1;
            perlin.Lacunarity = 1;
            perlin.Persistence = 1;
            perlin.Frequency = 0.008;
            perlin.Quality = SharpNoise.NoiseQuality.Standard;
            
            base.Initialize();
        }

        protected override string GetName()
        {
            return "Chunk";
        }

        public override void Update(GameTime gameTime)
        {
            foreach (KeyValuePair<Vector3, Chunk> pair in chunks)
                pair.Value.Update(gameTime);
        }

        public void AddChunk(Chunk chunk)
        {
            if (!chunks.Keys.Contains(chunk.position/32))
            {
                chunks.Add(chunk.position / 32, chunk);
                UpdateSurroundingChunks((int)chunk.position.X / 32, (int)chunk.position.Y / 32, (int)chunk.position.Z / 32);
            }
        }

        public void RemoveChunk(Chunk chunk)
        {
            Chunk checkEntity = null;
            if (!chunks.TryGetValue(chunk.position, out checkEntity))
                throw new Exception("No chunk with position " + chunk.position + " exists in the scene to be removed.");
            chunks.Remove(chunk.position / 32);
        }

        public Chunk GetChunk(Vector3 chunkPosition)
        {
            Chunk chunk = null;
            chunks.TryGetValue(chunkPosition, out chunk);
            return chunk;
        }

        public Chunk GetChunk(int x, int y, int z)
        {
            Chunk chunk = null;
            Vector3 chunkPosition = new Vector3((float)Math.Floor(x / 32f), (float)Math.Floor(y / 32f), (float)Math.Floor(z / 32f));
            chunks.TryGetValue(chunkPosition, out chunk);
            return chunk;
        }

        public void UpdateSurroundingChunks(int x, int y, int z)
        {
            Chunk tempChunk = GetChunk(new Vector3(x + 1, y, z));
            if (tempChunk != null)
                tempChunk.dirty = true;
            tempChunk = GetChunk(new Vector3(x - 1, y, z));
            if (tempChunk != null)
                tempChunk.dirty = true;
            tempChunk = GetChunk(new Vector3(x, y + 1, z));
            if (tempChunk != null)
                tempChunk.dirty = true;
            tempChunk = GetChunk(new Vector3(x, y - 1, z));
            if (tempChunk != null)
                tempChunk.dirty = true;
            tempChunk = GetChunk(new Vector3(x, y, z + 1));
            if (tempChunk != null)
                tempChunk.dirty = true;
            tempChunk = GetChunk(new Vector3(x, y, z - 1));
            if (tempChunk != null)
                tempChunk.dirty = true;
        }

        float mod(float val, int mod)
        {
            return ((val % mod) + mod) % mod;
        }
    }
}
