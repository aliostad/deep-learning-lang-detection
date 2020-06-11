using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Assets.Code.IO;
using Assets.Code.World;
using Assets.Code.World.Chunks;

namespace Assets.Code.Thread
{
    class SaveChunk : ThreadedJob
    {
        private Chunk _chunk;

        public SaveChunk(Chunk chunk)
        {
            _chunk = chunk;
        }
        protected override void ThreadFunction()
        {
            Serialization.SaveChunk(_chunk);
        }

        protected override void OnFinished()
        {

        }
    }
}
