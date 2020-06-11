using System.Collections.Generic;
//using System.Threading.Tasks;
using Voxels.VoxelGenerators;

namespace Voxels.Objects
{
    public class GeneratedVoxelVolume : VoxelVolume
    {
        public IntVector3 SizeInVoxels { get; set; }

        public VoxelGenerator Generator { get; set; }

        public void Generate()
        {
            //GenerateAsync().Wait();
        }

		/*
        public Task GenerateAsync()
        {
            return Task.Factory.StartNew(() =>
            {
                var chunkStart = new IntVector3();
                var chunkEnd = new IntVector3();
                var step = 10;
                var chunks = new List<Task<Chunk>>();

                for (chunkStart.X = 0; SizeInVoxels.X > chunkEnd.X; chunkStart.X += step)
                {
                    chunkEnd.X = chunkStart.X + step - 1;
                    for (chunkStart.Y = 0; SizeInVoxels.Y > chunkEnd.Y; chunkStart.Y += step)
                    {
                        chunkEnd.Y = chunkStart.Y + step - 1;
                        for (chunkStart.Z = 0; SizeInVoxels.Z > chunkEnd.Z; chunkStart.Z += step)
                        {
                            chunkEnd.Z = chunkStart.Z + step - 1;
                            var s = chunkStart;
                            var e = chunkEnd;

                            chunks.Add(Task.Factory.StartNew(() => { return Generator.GenerateChunk(s, e); }));
                        }
                    }
                }

                chunks.ForEach(c => c.ContinueWith((task) => {
                        AddChunk(task.Result);
                    })
                );
            });
        }
        */
    }
}
