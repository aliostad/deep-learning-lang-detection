using SurvivalGame.src.Entities;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading;

namespace SurvivalGame.src
{
    class World
    {
        private int seed;
        private ChunkManager chunkManager;
        private Unit player;

        public World(int seed, string saveFilePath)
        {
            this.seed = seed;
            this.chunkManager = new ChunkManager(saveFilePath);
            this.chunkManager.Load(0, 0, seed);
            this.player = new Human(32, 32);
            this.player.Inventory = new Inventory(16, 3, true);
            Chunk chunk;
            do
            {
                Thread.Sleep(1);
                chunk = this.chunkManager.GetChunk(0, 0);
            }
            while (chunk == null);
            chunk.AddEntity(this.player);
        }

        public int Seed
        {
            get {return this.seed; }
        }

        public void Draw(Graphics g, View view, float delta)
        {
            int sy = view.GetY() / (Chunk.size * Tile.size) - 2;
            int my = sy + (int) Math.Ceiling(g.VisibleClipBounds.Height / (Chunk.size * Tile.size)) + 3;
            int sx = view.GetX() / (Chunk.size * Tile.size) - 2;
            int mx = sx + (int)Math.Ceiling(g.VisibleClipBounds.Width / (Chunk.size * Tile.size)) + 3;
            for (int y = sy; y <= my; y++)
            {
                for (int x = sx; x <= mx; x++)
                {
                    Chunk chunk = this.chunkManager.GetChunk(x, y);
                    if (chunk == null)
                    {
                        this.chunkManager.Load(x, y, this.seed);
                    }
                    else
                    {
                        chunk.Draw(g, view, this, delta);
                    }
                }
            }
            for (int y = sy; y <= my; y++)
            {
                for (int x = sx; x < mx; x++)
                {
                    Chunk chunk = this.chunkManager.GetChunk(x, y);
                    if (chunk != null)
                    {
                        chunk.DrawEntities(g, view, this, delta);
                    }
                }
            }
        }

        public void Tick(float delta)
        {
            this.chunkManager.Tick(this, delta);
        }

        public int GetTile(int x, int y)
        {
            return this.chunkManager.GetTile(x, y);
        }

        public Chunk GetChunk(int x, int y)
        {
            return this.chunkManager.GetChunk(x, y);
        }

        public bool SetTile(int x, int y, int type)
        {
            int X = (int)Math.Floor((decimal)x / (decimal)Chunk.size);
            int Y = (int)Math.Floor((decimal)y / (decimal)Chunk.size);
            Chunk chunk = this.chunkManager.GetChunk(X, Y);
            if (chunk != null)
            {
                chunk.SetTile(x, y, type);
                return true;
            }
            return false;
        }

        public Entity GetPlayer()
        {
            return this.player;
        }

        public Entity GetEntityAt(int x, int y)
        {
            return this.chunkManager.GetEntityAt(x, y);
        }

        public List<Entity> GetEntitiesAt(int x, int y)
        {
            return this.chunkManager.GetEntitiesAt(x, y);
        }
    }
}
