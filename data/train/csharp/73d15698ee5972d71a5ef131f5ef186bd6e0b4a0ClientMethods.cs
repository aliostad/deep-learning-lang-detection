using EveFortressModel;
using System;
using System.Collections.Generic;
using System.Linq;

namespace EveFortressClient
{
    public class ClientMethods
    {
        public void ChatMessage(string message)
        {
            Game.GetSystem<ChatManager>().AddMessage(message);
        }

        public void UpdateChunk(Point<long> chunkPosition, List<Patch> patches)
        {
            var chunk = Game.GetSystem<ChunkManager>().GetChunk(chunkPosition);

            foreach (var patch in patches)
            {
                chunk.ApplyPatch(patch);
            }
        }

        public void SendNewEntity(Entity entity)
        {
            var chunkLoc = Chunk.GetChunkCoords(entity.Position);
            var chunk = Game.GetSystem<ChunkManager>().GetChunk(chunkLoc);
            chunk.Entities[entity.ID] = entity;
        }
    }
}