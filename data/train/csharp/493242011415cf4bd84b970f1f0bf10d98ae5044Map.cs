using Microsoft.Xna.Framework.Graphics;
using System.Collections.Generic;

namespace Plasma_Rev
{
    public class Map
    {
        public Player player = new Player(0, 0);
        public List<Chunk> loadedChunks = new List<Chunk>();

        public Map()
        {
            player = new Player(0, 0);
            checkChunks();
        }

        public Map(Player newPlayer)
        {
            player = newPlayer;
            checkChunks();
        }

        public void checkChunks()
        {
            int playerChunkX = MathHelper.fastFloor(player.posX / (double)Ref.tileAmountX);
            int playerChunkY = MathHelper.fastFloor(player.posY / (double)Ref.tileAmountY);

            /** Unload chunks */
            unloadChunks(playerChunkX, playerChunkY);

            /** Load chunks */
            loadChunks(playerChunkX, playerChunkY);

        }

        public void Draw(SpriteBatch spriteBatch)
        {
            loadedChunks.ForEach(chunk => chunk.Draw(spriteBatch));
        }

        private void unloadChunks(int playerChunkX, int playerChunkY)
        {
            Chunk chunk = new Chunk(0, 0);

            loadedChunks.ForEach(thisChunk => chunk = thisChunk);

            if(chunk.chunkX > playerChunkX + (Ref.chunkAmountX - 1) / 2 || chunk.chunkX < playerChunkX - (Ref.chunkAmountX - 1) / 2 || chunk.chunkY > playerChunkY + (Ref.chunkAmountY - 1) / 2 || chunk.chunkY < playerChunkY - (Ref.chunkAmountY  -1) / 2)
                loadedChunks.Remove(chunk);
        }

        private void loadChunks(int playerChunkX, int playerChunkY)
        {
            for (int x = playerChunkX - (Ref.chunkAmountX - 1) / 2; x <= playerChunkX + (Ref.chunkAmountX - 1) / 2; x++)
            {
                for (int y = playerChunkY - (Ref.chunkAmountY - 1) / 2; y <= playerChunkY + (Ref.chunkAmountY - 1) / 2; y++)
                {
                    if (!loadedChunks.Contains(new Chunk(x, y)))
                    {

                        Chunk chunk = new Chunk(x, y);
                        chunk.populate();
                        loadedChunks.Add(chunk);
                    }
                }
            }
        }
    }
}