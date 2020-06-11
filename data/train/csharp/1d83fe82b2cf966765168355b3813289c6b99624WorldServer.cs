using System;
using System.Collections.Generic;

namespace Sean.World
{
    
    public interface IWorldServer
    {
        ChunkCoords GetChunkCoords(Position position);
        void RegisterChunk(ChunkCoords chunkCoords, PlayerConnection player);
        void UnRegisterChunk(ChunkCoords chunkCoords, PlayerConnection player);

        Chunk GetChunk (ChunkCoords chunkCoords);
        void PutBlock (Position position, Block.BlockType blockType);
        void ChunkEvent (ChunkCoords chunkCoords, ChunkEventTarget target, ChunkEvent chunkEvent);
    }

    public class ChunkEvent
    {
    }
    public class BlockChunkEvent : ChunkEvent
    {
        Position blockLocation;
        ItemAction action;
        Block block;
    }
    public class ItemChunkEvent : ChunkEvent
    {
        Coords coords;
        ItemAction action;
        //Item item;
    }
      

    public enum ChunkEventTarget
    {
        Block,
        Item,
        Character,
        Lighting,
        Projectile,
        Sound,
        Message
    }
    public enum ItemAction
    {
        Add,
        Remove,
        Update       
    }

    public class ChunkEventArgs : EventArgs
    {
    }

    public class PlayerConnection
    {
        public string user;
        public string connection;
    }

    public class WorldServer : IWorldServer
    {
        private Dictionary<ChunkCoords, List<PlayerConnection> > registrations;

        public WorldServer ()
        {
            registrations = new Dictionary<ChunkCoords, List<PlayerConnection> > ();
        }

        public ChunkCoords GetChunkCoords(Position position)
        {
            return new ChunkCoords (position.X / Chunk.CHUNK_SIZE, position.Z / Chunk.CHUNK_SIZE); 
        }
        public void RegisterChunk(ChunkCoords chunkCoords, PlayerConnection player)
        {
            // Ensure chunk loaded or generated
            var chunk = WorldData.WorldMap.Chunk (chunkCoords.X, chunkCoords.Z);
            if (!registrations.ContainsKey (chunkCoords)) {
                registrations [chunkCoords] = new List<PlayerConnection> ();
            }
            registrations[chunkCoords].Add(player);
        }
        public void UnRegisterChunk(ChunkCoords chunkCoords, PlayerConnection player)
        {
            var reg = registrations [chunkCoords];
            if (reg != null)
            {
                reg.Remove (player);
                if (reg.Count == 0) {
                    registrations.Remove (chunkCoords);
                }
            }
        }

        public Chunk GetChunk(ChunkCoords chunkCoords)
        {
            return WorldData.WorldMap.Chunk(chunkCoords);
        }
        public void PutBlock(Position position, Block.BlockType blockType)
        {
            WorldData.PlaceBlock(position, blockType);
        }

        public void ChunkEvent(ChunkCoords chunkCoords, ChunkEventTarget target, ChunkEvent chunkEvent)
        {
        }


    }
}

