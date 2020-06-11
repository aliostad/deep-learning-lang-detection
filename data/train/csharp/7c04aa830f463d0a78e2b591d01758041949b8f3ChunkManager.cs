using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Xna.Framework;
using System.Collections;
using SharedCode.TileSystem;
using WorldServer.Database;

namespace WorldServer.Region
{
    public class ChunkManager
    {
        private static int ChunkWidth = 40 * 25;
        private static int ChunkHeight = 40 * 25;
        private static Dictionary<Vector2, WorldChunk> LoadedChunks = new Dictionary<Vector2, WorldChunk>();

        public static Vector2 North = new Vector2(0, -1);
        public static Vector2 NorthEast = new Vector2(1, -1);
        public static Vector2 East = new Vector2(1, 0);
        public static Vector2 SouthEast = new Vector2(1, 1);
        public static Vector2 South = new Vector2(0, 1);
        public static Vector2 SouthWest = new Vector2(-1, 1);
        public static Vector2 West = new Vector2(-1, 0);
        public static Vector2 NorthWest = new Vector2(-1, -1);
       
        public static List<WorldChunk> GetLocalChunks(WorldChunk CurrentChunk) {
            Vector2 Location = new Vector2(CurrentChunk.BoundingBox.X,
                CurrentChunk.BoundingBox.Y);
            List<WorldChunk> RetVal = new List<WorldChunk>();
            RetVal.Add(CurrentChunk);
            RetVal.Add(GetChunkViaLocation(Location + North));
            RetVal.Add(GetChunkViaLocation(Location + NorthEast));
            RetVal.Add(GetChunkViaLocation(Location + East));
            RetVal.Add(GetChunkViaLocation(Location + SouthEast));
            RetVal.Add(GetChunkViaLocation(Location + South));
            RetVal.Add(GetChunkViaLocation(Location + SouthWest));
            RetVal.Add(GetChunkViaLocation(Location + West));
            RetVal.Add(GetChunkViaLocation(Location + NorthWest));
            return RetVal;
        }

        public static WorldChunk GetChunk(Vector2 WorldLocation) {
            Vector2 ChunkVector = new Vector2();
            ChunkVector.X = (int)WorldLocation.X / ChunkWidth;
            ChunkVector.Y = (int)WorldLocation.Y / ChunkHeight;
            return GetChunkViaLocation(ChunkVector);
        }

        public static WorldChunk GetChunkViaLocation(Vector2 ChunkLocation) {
            MongoDB.Document ChunkFind = new MongoDB.Document();
            ChunkFind["x"] = ChunkLocation.X;
            ChunkFind["y"] = ChunkLocation.Y;

            if (LoadedChunks.ContainsKey(ChunkLocation))
                return LoadedChunks[ChunkLocation];

            else
            {
                var ChunkDoc = DatabaseManager.GetCollection("test", "world_chunk_bounds").Find(ChunkFind);
                if (ChunkDoc.Documents.Count() > 0)
                {
                    MongoDB.Document Doc = ChunkDoc.Documents.First();
                    var ChunkRect = new Rectangle((int)Doc["x"], (int)Doc["y"], (int)Doc["width"], (int)Doc["height"]);
                    LoadedChunks.Add(ChunkLocation, new WorldChunk(ChunkRect));
                    LoadedChunks[ChunkLocation].LoadFromDB();
                    return LoadedChunks[ChunkLocation];
                }
            }



            LoadedChunks.Add(ChunkLocation, new WorldChunk(new Rectangle(
                (int)ChunkLocation.X,
                (int)ChunkLocation.Y,
                ChunkWidth,
                ChunkHeight)));

            var Chunk = new MongoDB.Document();
            Chunk["x"] = (int)ChunkLocation.X;
            Chunk["y"] = (int)ChunkLocation.X;
            Chunk["width"] = ChunkWidth;
            Chunk["height"] = ChunkHeight;
            DatabaseManager.GetCollection("test", "world_chunk_bounds").Insert(Chunk);

            return LoadedChunks[ChunkLocation];
        }
    }
}
