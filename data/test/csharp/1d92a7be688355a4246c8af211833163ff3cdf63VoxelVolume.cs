using System.Collections.Generic;
using System.Linq;
using Voxels;

namespace Voxels.Objects
{
    public delegate void BoundsUpdatedEvent(IntVector3 startDifference, IntVector3 endDifference);
    public class VoxelVolume : VoxelContainer
    {
        public event VoxelContainerEvent ChunkAdded;
        public event VoxelContainerEvent ChunkRemoved;

        public int VoxelCount { get { return Voxels.Count; } }

		public VoxelVolume () : base()
		{
			
		}

        public VoxelVolume(List<Chunk> chunks)
            : this()
        {
            AddChunks(chunks);
        }

        public Chunk GetChunk(IntVector3 start, IntVector3 end)
        {
            var chunk = new Chunk(start, end);
            var pos = new IntVector3(start);

            for (pos.X = chunk.Start.X; pos.X < chunk.End.X; pos.X++)
                for (pos.Y = chunk.Start.Y; pos.Y < chunk.End.Y; pos.Y++)
                    for (pos.Z = chunk.Start.Z; pos.Z < chunk.End.Z; pos.Z++)
                        chunk.SetVoxel(pos, GetVoxel(pos));

            return chunk;
        }

        public void AddChunk(Chunk chunk)
        {
            var pos = new IntVector3(chunk.Start);

            for (pos.X = chunk.Start.X; pos.X < chunk.End.X; pos.X++)
                for (pos.Y = chunk.Start.Y; pos.Y < chunk.End.Y; pos.Y++)
                    for (pos.Z = chunk.Start.Z; pos.Z < chunk.End.Z; pos.Z++)
                        SetVoxel(pos, chunk.GetVoxel(pos));

            if (ChunkAdded != null)
                ChunkAdded(chunk);
        }

        public void AddChunks(List<Chunk> newChunks)
        {
            if (newChunks != null)
                newChunks.ForEach(AddChunk);
        }

        public void RemoveChunk(Chunk chunk)
        {
            var pos = new IntVector3(chunk.Start);

            for (pos.X = chunk.Start.X; pos.X < chunk.End.X; pos.X++)
				for (pos.Y = chunk.Start.Y; pos.Y < chunk.End.Y; pos.Y++)
					for (pos.Z = chunk.Start.Z; pos.Z < chunk.End.Z; pos.Z++) {
						if (Voxels.ContainsKey (pos))
							Voxels.Remove (pos);
					}

            if (ChunkRemoved != null)
                ChunkRemoved(chunk);
        }
    }
}