using System.Collections.Generic;
using Assets.Scripts.AccessLayer.Material;
using Assets.Scripts.EngineLayer.Voxels.Data;
using UnityEngine;

namespace Assets.Scripts.EngineLayer.Voxels.Containers.Chunks
{
    public class Chunk : VoxelContainer
    {
        public const int ChunkSize = 16;
        
        public static Chunk CreateChunk(int x, int y, int z, Map map)
        {
            var chunk = new GameObject(string.Format("Chunk [{0}, {1}, {2}]", x, y, z));
            var chunkC = chunk.gameObject.AddComponent<Chunk>();
            chunkC.CanBeHighlighted = false;
            chunkC.tag = "Chunk";
            chunk.transform.parent = map.transform;
            chunkC.InitializeContainer(new Vector3(x * ChunkSize, y * ChunkSize, z * ChunkSize), map.MapData.Chunks[x, y, z], MaterialRegistry.Instance.Materials);
            return chunkC;
        }
        
        protected override List<Vector3> UpdateMesh()
        {
            var up = base.UpdateMesh();
            var cd = (ChunkData) ContainerData;
            cd.LocalAStar.RefreshNetwork(cd, up);
            return up;
        }

        public override void Update()
        {
            base.Update();
            var chunkData = ContainerData as ChunkData;
            if (chunkData != null) chunkData.CheckDirtyVoxels();
        }
    }
}
