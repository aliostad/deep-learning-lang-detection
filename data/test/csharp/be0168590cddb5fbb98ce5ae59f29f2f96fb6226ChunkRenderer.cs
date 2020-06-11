using Arcodia.Blocks;
using Arcodia.Worlds;
using Arcodia.Worlds.Chunks;

namespace Arcodia.Renderer.Worlds
{
    public class ChunkRenderer
    {
        private World WorldObj;
        private Chunk Chunk;

        private VertexBuffer Buffer;

        public ChunkRenderer(Chunk chunk) : this(chunk, chunk.WorldObj) {}

        public ChunkRenderer(Chunk chunk, World world)
        {
            this.WorldObj = world;
            this.Chunk = chunk;

            this.Buffer = new VertexBuffer();
        }

        public void RebuildChunk()
        {
            for (int i = 0; i < 16; i++)
            {
                for (int j = 0; j < 16; j++)
                {
                    for (int k = 0; k < 16; k++)
                    {
                        int x = i + this.Chunk.Pos.X * 16;
                        int y = j + this.Chunk.Pos.Y * 16;
                        int z = k + this.Chunk.Pos.Z * 16;
                        Block block = this.Chunk.GetBlock(i, j, k);
                        var model = block.GetBlockModel();

                        if (model != null)
                        {
                            model.SetWorld(this.WorldObj);
                            model.RenderBlock(ref this.Buffer, block, x, y, z);
                        }
                    }
                }
            }

            this.Chunk.NeedsUpdate = false;
            this.Buffer.Upload();
        }

        public void Render()
        {
            if (this.Chunk.NeedsUpdate)
            {
                this.RebuildChunk();
            }

            this.Buffer.Draw();
        }

        public void Dispose()
        {
            this.Buffer.Dispose();
        }
    }
}