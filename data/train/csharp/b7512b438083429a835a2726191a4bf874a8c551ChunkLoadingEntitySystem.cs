
using EveFortressModel;
using EveFortressModel.Components;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EveFortressServer
{
    public class ChunkLoadingEntitySystem : EntitySystem
    {
        public override List<Type> ComponentSubscriptions
        {
            get { return new List<Type> { typeof(ChunkLoading) }; }
        }

        public override void Update(Entity entity)
        {
            var chunkLoadDistance = entity.GetComponent<ChunkLoading>().SquareRadius;
            var chunkPos = Chunk.GetChunkCoords(entity.Position);

            for (var x = chunkPos.X - chunkLoadDistance; x < chunkPos.X + chunkLoadDistance; x++)
            {
                for (var y = chunkPos.Y - chunkLoadDistance; y < chunkPos.Y + chunkLoadDistance; y++)
                {

                }
            }
        }
    }
}
