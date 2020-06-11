using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Assets.Scripts.Utilities;

namespace Assets.Scripts.Land.Features.Implementation
{
    class RoadNetworkImpl : RoadNetwork
    {
        // Variables
        private ChunkGraph mainChunkConnections;

        // Constructors

        // Functions
        public ChunkGraph getMainChunkConnections()
        {
            return mainChunkConnections;
        }

        public void setMainChunkConnections(ChunkGraph chunkGraph)
        {
            this.mainChunkConnections = chunkGraph;
        }
    }
}
