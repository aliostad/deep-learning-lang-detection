using System.Diagnostics;

using Voxels.Universe.Chunks;
using Voxels.Universe.Blocks;

namespace Voxels.Workers {

    class RasterizeWorker : Worker {

        private Chunk chunk;

        private ChunkMesh mesh;
        private ChunkView chunkView;
        private ChunkRenderer renderer;        

        private Stopwatch timer = new Stopwatch();

        public RasterizeWorker(Chunk chunk) {
            this.chunk = chunk;
            this.chunk.Working = true;            

            mesh = new ChunkMesh();
            renderer = new ChunkRenderer();
            chunkView = new ChunkView(chunk);
        }

        public override void Process() {
            timer.Start();

            if (chunk.Dirty) {

                // TODO: look into ways of iterating only known visible blocks (i.e not AIR)
                foreach (var position in Configuration.ChunkRegion) {

                    Block block = chunkView.GetBlock(position);

                    if (block.IsVisible)
                        renderer.GenerateMesh(mesh, chunkView, block, position);

                }

                Statistics.ChunkMeshes++;
            }

            chunk.ChunkMesh = mesh;
            chunk.ChunkState = ChunkState.TESSELATED;
            chunk.Working = false;

            timer.Stop();
            Statistics.ChunkTotal += timer.ElapsedMilliseconds;
        }
        
    }

}