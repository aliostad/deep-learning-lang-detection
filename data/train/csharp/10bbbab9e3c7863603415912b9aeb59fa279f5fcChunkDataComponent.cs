using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using monotest.Rendering;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Nez;
using monotest.Util;

namespace monotest.Components.World
{
    public class ChunkDataComponent : Component
    {

        public int ChunkX;
        public int ChunkY;
        public TileData[,] ChunkTileData;

        public bool IsDirty { get; internal set; }

        public void Init(int X, int Y)
        {
            ChunkX = X;
            ChunkY = Y;
            
            var  MapData = Noise2d.GenerateNoiseMap(ChunkX * ChunkManager.Instance.ChunkWidth, ChunkY * ChunkManager.Instance.ChunkHeight,
             ChunkManager.Instance.ChunkWidth, ChunkManager.Instance.ChunkHeight, 8, 256);
            var  BaseTileData = new int[ChunkManager.Instance.ChunkWidth, ChunkManager.Instance.ChunkHeight];
            var DecorationTileData = new int[ChunkManager.Instance.ChunkWidth, ChunkManager.Instance.ChunkHeight];

            ChunkTileData = new TileData[ChunkManager.Instance.ChunkWidth, ChunkManager.Instance.ChunkHeight];

            for (var i = 0; i < ChunkManager.Instance.ChunkWidth; i++)
            {
                for (var j = 0; j < ChunkManager.Instance.ChunkHeight; j++)
                {
                    BaseTileData[i, j]
                        = TerrainGen.TileForHeight((ChunkX * ChunkManager.Instance.ChunkWidth) + i, (ChunkY * ChunkManager.Instance.ChunkHeight) + j,
                            MapData[i, j]);


                    DecorationTileData[i, j] = -1;

                    //527 
                    var tree = TerrainGen.WantTree(
                        (ChunkX * ChunkManager.Instance.ChunkWidth) + i, (ChunkY * ChunkManager.Instance.ChunkHeight) + j, MapData[i, j]);


                    TileData tData = new TileData();
                    tData.ChunkTileOffsetX = i;
                    tData.ChunkTileOffsetY = j;
                    tData.TileBaseType = BaseTileData[i, j];
                    tData.TileDetailType = DecorationTileData[i, j];
                    tData.TileX = (ChunkX * ChunkManager.Instance.ChunkWidth) + i;
                    tData.TileY = (ChunkY * ChunkManager.Instance.ChunkHeight) + j;
                    tData.TileEntity =  new Entity();

                    if (tree)
                    {
                        tData.TileEntity.addComponent<TIleCollider>();

                        tData.TileEntity.addComponent(new ResourceTile("wood", 527, tData));
                    }

                    tData.UpdateWalkableState();
                    ChunkTileData[i, j] = tData;
                }
            }
        }
    }
}
