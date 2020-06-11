using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ArtifactsRider.MapManager;
using Microsoft.Xna.Framework;

namespace ArtifactsRider.Generators
{
    /// <summary>
    /// Derived class to generate empty Map with floor and walls at edges
    /// </summary>
    public class EmptyMapGenerator : GeneratorBase
    {
        /// <summary>
        /// Overrided method to Generate empty Map
        /// </summary>
        /// <param name="Chunk">Chunk to generate in</param>
        public override void Generate(Chunk Chunk)
        {

            for (int y = 0; y < Chunk.position.Height / Chunk.tileSize; y++)
            {
                for (int x = 0; x < Chunk.position.Width / Chunk.tileSize; x++)
                {
                    Chunk.SetTile(x, y, new Tile(new Rectangle(Chunk.position.X + x * Chunk.tileSize, Chunk.position.Y + y * Chunk.tileSize, Chunk.tileSize, Chunk.tileSize), "dungFloor", 30));
                }
            }

            for (int x = 2; x <= 10; x++)
            {
                Chunk.SetTile(x, 2, new Tile(new Rectangle(Chunk.position.X + x * Chunk.tileSize, Chunk.position.Y + 2 * Chunk.tileSize, Chunk.tileSize, Chunk.tileSize), "dungWall", 0));
                Chunk.SetTile(x, 10, new Tile(new Rectangle(Chunk.position.X + x * Chunk.tileSize, Chunk.position.Y + 10 * Chunk.tileSize, Chunk.tileSize, Chunk.tileSize), "dungWall", 0));
            }

            for (int y = 2; y <= 10; y++)
            {
                Chunk.SetTile(2, y, new Tile(new Rectangle(Chunk.position.X + 2 * Chunk.tileSize, Chunk.position.Y + y * Chunk.tileSize, Chunk.tileSize, Chunk.tileSize), "dungWall", 0));
                Chunk.SetTile(10, y, new Tile(new Rectangle(Chunk.position.X + 10 * Chunk.tileSize, Chunk.position.Y + y * Chunk.tileSize, Chunk.tileSize, Chunk.tileSize), "dungWall", 0));
            }
        }
    }
}
