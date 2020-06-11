using Assets.Scripts.AccessLayer.Worlds;
using Assets.Scripts.EngineLayer.Voxels.Data;
using UnityEngine;

namespace Assets.Scripts.EngineLayer.Voxels.Containers.Chunks
{
    public class ChunkBorder
    {
        public bool IsSolid;
        public bool[,] VoxelAtPositionSolid;
        public ChunkData MyChunk;
        public ChunkData NeighbourChunk;
        public int Side;

        public ChunkBorder(ChunkData myChunk, int side)
        {
            MyChunk = myChunk;
            Side = side;
            UpdateBorder();
        }

        public void UpdateBorder()
        {
            VoxelAtPositionSolid = new bool[Chunk.ChunkSize, Chunk.ChunkSize];
            for (var a = 0; a < Chunk.ChunkSize; a++)
            {
                for (var b = 0; b < Chunk.ChunkSize; b++)
                {
                    VoxelAtPositionSolid[a, b] = MyChunk.GetVoxelActive(SideToOuterPlane(Side, a, b));
                    IsSolid = VoxelAtPositionSolid[a, b] && IsSolid;
                }
            }
            UpdateNeighbour();
        }

        public bool[,] GetNeighbourBorder()
        {
            if(GetNeighbourChunk() == null)
                return new bool[Chunk.ChunkSize,Chunk.ChunkSize];
            return NeighbourChunk.ChunkBorders[Side % 2 == 0 ? Side + 1 : Side - 1].VoxelAtPositionSolid;
        }
        public bool IsNeighbourSolid()
        {
            if (GetNeighbourChunk() == null)
                return false;
            return NeighbourChunk.ChunkBorders[Side % 2 == 0 ? Side + 1 : Side - 1].IsSolid;
        }

        private void UpdateNeighbour()
        {
            var neighbour = GetNeighbourChunk();
            if (neighbour != null)
                neighbour.BorderUpdate(Side % 2 == 0 ? Side + 1 : Side - 1);
        }

        private ChunkData GetNeighbourChunk()
        {
            return NeighbourChunk ?? (NeighbourChunk = World.At(MyChunk.Position + SideToDirection(Side) * Chunk.ChunkSize).GetChunkData());
        }

        private static Vector3 SideToOuterPlane(int side, float a, float b)
        {
            switch (side)
            {
                case 0: return new Vector3(Chunk.ChunkSize-1, a, b);
                case 1: return new Vector3(0, a, b);
                case 2: return new Vector3(a, Chunk.ChunkSize - 1, b);
                case 3: return new Vector3(a, 0, b);
                case 4: return new Vector3(a, b, Chunk.ChunkSize - 1);
                case 5: return new Vector3(a, b, 0);
            }
            return Vector3.zero;
        }
        private static Vector3 SideToDirection(int side)
        {
            switch (side)
            {
                case 0: return Vector3.right;
                case 1: return Vector3.left;
                case 2: return Vector3.up;
                case 3: return Vector3.down;
                case 4: return Vector3.forward;
                case 5: return Vector3.back;
            }
            return Vector3.zero;
        }
    }
}