using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace RPG.src
{
    class MapManager
    {
        List<Chunk> chunkList = new List<Chunk>();

        internal Point playerRegion;
        internal Point loadedRegion;

        //Mini Map
        private RenderTarget2D miniMapRenderTarget2D;
        internal Texture2D miniMapTexture2d;
        internal Rectangle miniMapAuxRetangle;

        public MapManager()
        {
            miniMapRenderTarget2D = new RenderTarget2D(Game1.graphicsDeviceManager.GraphicsDevice, 200, 200);
            miniMapAuxRetangle = new Rectangle(0, 0, 1, 1);
        }

        internal void update()
        {
            playerRegion.X = (int)(Game1.mission.player.position.X / Config.chunkSize);
            playerRegion.Y = (int)(Game1.mission.player.position.Y / Config.chunkSize);

            if (playerRegion != loadedRegion)
            {
                loadMap();
                loadedRegion = playerRegion;
            }
        }

        private void loadMap()
        {
            if (playerRegion.X < loadedRegion.X)
            {
                loadA();
            }
            if (playerRegion.Y < loadedRegion.Y)
            {
                loadS();
            }
            if (playerRegion.X > loadedRegion.X)
            {
                loadD();
            }
            if (playerRegion.Y > loadedRegion.Y)
            {
                loadW();
            }
            reloadMiniMap();
        }

        private void reloadMiniMap()
        {
            Game1.graphicsDeviceManager.GraphicsDevice.SetRenderTarget(miniMapRenderTarget2D);
            Game1.spriteBatch.Begin();

            foreach (var chunk in chunkList)
            {
                chunk.drawOnMiniMap();
            }

            Game1.spriteBatch.End();
            Game1.graphicsDeviceManager.GraphicsDevice.SetRenderTarget(null);

            Game1.graphicsDeviceManager.GraphicsDevice.ScissorRectangle =  Game1.display.centerViewport.Bounds;
            Game1.graphicsDeviceManager.GraphicsDevice.Viewport = Game1.display.centerViewport;

            miniMapTexture2d = (Texture2D)miniMapRenderTarget2D;
        }

        private void loadW()
        {
            chunkList[6] = chunkList[3];
            chunkList[7] = chunkList[4];
            chunkList[8] = chunkList[5];

            chunkList[3] = chunkList[0];
            chunkList[4] = chunkList[1];
            chunkList[5] = chunkList[2];

            chunkList[0] = new Chunk(playerRegion.X - 1, playerRegion.Y + 1);
            chunkList[1] = new Chunk(playerRegion.X + 0, playerRegion.Y + 1);
            chunkList[2] = new Chunk(playerRegion.X + 1, playerRegion.Y + 1);
        }

        private void loadD()
        {
            chunkList[0] = chunkList[1];
            chunkList[3] = chunkList[4];
            chunkList[6] = chunkList[7];

            chunkList[1] = chunkList[2];
            chunkList[4] = chunkList[5];
            chunkList[7] = chunkList[8];

            chunkList[2] = new Chunk(playerRegion.X + 1, playerRegion.Y + 1);
            chunkList[5] = new Chunk(playerRegion.X + 1, playerRegion.Y + 0);
            chunkList[8] = new Chunk(playerRegion.X + 1, playerRegion.Y - 1);
        }

        private void loadS()
        {
            chunkList[0] = chunkList[3];
            chunkList[1] = chunkList[4];
            chunkList[2] = chunkList[5];

            chunkList[3] = chunkList[6];
            chunkList[4] = chunkList[7];
            chunkList[5] = chunkList[8];

            chunkList[6] = new Chunk(playerRegion.X - 1, playerRegion.Y - 1);
            chunkList[7] = new Chunk(playerRegion.X + 0, playerRegion.Y - 1);
            chunkList[8] = new Chunk(playerRegion.X + 1, playerRegion.Y - 1);
        }

        private void loadA()
        {
            chunkList[2] = chunkList[1];
            chunkList[5] = chunkList[4];
            chunkList[8] = chunkList[7];

            chunkList[1] = chunkList[0];
            chunkList[4] = chunkList[3];
            chunkList[7] = chunkList[6];

            chunkList[0] = new Chunk(playerRegion.X - 1, playerRegion.Y + 1);
            chunkList[3] = new Chunk(playerRegion.X - 1, playerRegion.Y + 0);
            chunkList[6] = new Chunk(playerRegion.X - 1, playerRegion.Y - 1);
        }

        public void reLoadMap()
        {
            playerRegion.X = (int)(Game1.mission.player.position.X / Config.chunkSize);
            playerRegion.Y = (int)(Game1.mission.player.position.Y / Config.chunkSize);

            chunkList.Clear();
            for (int y = playerRegion.Y + 1; y >= playerRegion.Y - 1; y--)
            {
                for (int x = playerRegion.X - 1; x <= playerRegion.X + 1; x++)
                {
                    chunkList.Add(new Chunk(x, y));
                }
            }

            reloadMiniMap();

            loadedRegion = playerRegion;
        }

        public void drawMapFloor()
        {
            foreach (Chunk chunk in chunkList)
            {
                chunk.drawChunkFloor();
            }
        }

        public void drawMapRoof()
        {
            foreach (Chunk chunk in chunkList)
            {
                chunk.drawChunkRoof();
            }
        }
    }
}
