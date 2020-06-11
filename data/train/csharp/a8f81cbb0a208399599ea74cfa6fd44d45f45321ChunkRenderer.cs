using System.Collections.Generic;
using UnityEngine;

namespace NigelGott.Terra.Terrain
{
    public class ChunkRenderer
    {

        public GameObject BuildGameObject(Chunk chunk)
        {
            var terrainData = new TerrainData
            {
                heightmapResolution = chunk.Size,
                size = TerrainConfig.CreateTerrainWorldSizeFromTile(chunk),
                baseMapResolution = Mathf.Clamp(chunk.Size, 16, 2048)
            };

            terrainData.SetDetailResolution(chunk.Size, 8);
            terrainData.SetHeights(0, 0, chunk.heights);

            return UnityEngine.Terrain.CreateTerrainGameObject(terrainData);
        }

        public GameObject CreateAndSpawnChunk(Chunk chunk, GameObject parent)
        {
            var terrainObject = BuildGameObject(chunk);
            SpawnChunk(chunk, parent, terrainObject);
            return terrainObject;
        }

        public void SpawnChunk(Chunk chunk, GameObject parent, GameObject terrainObject)
        {
            terrainObject.transform.parent = parent.transform;
            var spawnLoc = new Vector3(chunk.Size*chunk.X*TerrainConfig.HeightmapGridSizeInWorldUnits, 0,
                chunk.Size*chunk.Y*TerrainConfig.HeightmapGridSizeInWorldUnits);
            Debug.Log("Spawning chunk at " + spawnLoc);
            terrainObject.transform.position = spawnLoc;
        }
    }
}