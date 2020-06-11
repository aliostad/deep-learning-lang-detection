using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
namespace BradGame3D
{
    class World
    {
        public const int seed = 567898765;
        public const int chunkCount = 7;
        Game1 game;
        public Chunk[][] chunks = new Chunk[chunkCount][];
        //Chunk c;
        public World(Game1 g)
        {
            game = g;
            
            for(int i = 0; i < chunkCount; i++)
                chunks[i] = new Chunk[chunkCount];
            //c = new Chunk(game, this, 0, 0);


            init();
            
        }
        public void init()
        {

            for (int i = 0; i < chunkCount*chunkCount; i++)
            {
                // ---------------------------chunks[i / chunkCount][i % chunkCount] = new Chunk(game, this, i % chunkCount, i / chunkCount);
               
                
                /*
                Random r = new Random();
                for (int a = 0; a < Chunk.xSize * Chunk.ySize * Chunk.zSize; i++)
                {
                    chunks[i/chunkCount][i%chunkCount].blocks[a].setSolid(false);

                    if (r.Next(10) >= 9)
                        chunks[i/chunkCount][i%chunkCount].blocks[a].setSolid(true);
                }
                 */
            }

            doPerlin();
            
            //chunks[0][0].doVisible();
            //chunks[0][0].buildList();

            for (int i = 0; i < chunkCount*chunkCount; i++)
            {
                chunks[i / chunkCount][i % chunkCount].doVisible();
                chunks[i / chunkCount][i % chunkCount].buildList();
            }

        }
    

        public void draw(GraphicsDeviceManager g)
        {
            for (int i = 0; i < chunkCount*chunkCount; i++)
            {
                if(chunks[i/chunkCount][i%chunkCount].faceCount!=0)
                    g.GraphicsDevice.DrawUserPrimitives<VertexPositionNormalTexture>(PrimitiveType.TriangleList, chunks[i/chunkCount][i%chunkCount].verticesArray, 0, chunks[i/chunkCount][i%chunkCount].faceCount * 2);
            }
        }
        public Block2 getBlockAt(int x, int y, int z)
        {
            int cx = x / Chunk.xSize;
            int cz = z / Chunk.zSize;
            if (cz >= 0 && cz < chunkCount && cx >= 0 && cx < chunkCount && z>=0 && x>=0 && y>=0 && y<Chunk.ySize && (x-cx*Chunk.xSize)<Chunk.xSize && (z-cz*Chunk.zSize)<Chunk.zSize)
                return chunks[cz][cx].blocks[(x-cx*Chunk.xSize) + y * Chunk.xSize*Chunk.zSize + (z-cz*Chunk.zSize) * Chunk.zSize];
            else
                return null;
        }
    }
}
