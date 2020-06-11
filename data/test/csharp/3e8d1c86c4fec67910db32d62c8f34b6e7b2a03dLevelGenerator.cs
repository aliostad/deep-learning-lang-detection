using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace Base.Game {

    /// <summary>
    /// Generates levels.
    /// </summary>
    public class LevelGenerator : MonoBehaviour {

        public int currentLevel;

        /// <summary>
        /// The starting chunk of the game.
        /// </summary>
        public GameObject spawnChunkPrefab;

        /// <summary>
        /// The end chunk of a level.
        /// </summary>
        public GameObject endChunkPrefab;

        /// <summary>
        /// The chunks that are spawned in between end and/or spawn chunks.
        /// </summary>
        public List<GameObject> chunkPrefabs;

        private ChunkData spawnChunk;
        private List<ChunkData> endChunk = new List<ChunkData>();
        private List<ChunkData> availableChunks = new List<ChunkData>();
        private List<ChunkData> usedChunks = new List<ChunkData>();
        private GameObject chunkHolder;

        private int generatedLength;
        private int lengthToGenerate;
        private ChunkData lastSpawnedChunk;
        private int lastEndPoint = 0;

        void Awake () {
            //Create a holder for all the chunks.
            chunkHolder = new GameObject("Chunk Holder");
            chunkHolder.transform.parent = this.transform;

            //Create all chunks.
            spawnChunk = CreateChunk(spawnChunkPrefab);
            endChunk.Add(CreateChunk(endChunkPrefab));
            endChunk.Add(CreateChunk(endChunkPrefab));
           
            for (int i = 0; i < chunkPrefabs.Count; i++) {

                ChunkData chunk = CreateChunk(chunkPrefabs[i]);
                availableChunks.Add(chunk);

            }
            
        }

        /// <summary>
        /// Gets the last chunk that is spawned.
        /// </summary>
        /// <returns>The last spawned chunk.</returns>
        public GameObject GetLastChunk () {

            return endChunk[lastEndPoint].gameObject;

        }

        /// <summary>
        /// Called when the Game State is left.
        /// </summary>
        public void Unload () {

            for (int i = 0; i < usedChunks.Count; i++) {

                ChunkData chunk = usedChunks[i];
                chunk.DisableChunk();
                availableChunks.Add(chunk);

            }

            spawnChunk.DisableChunk();
            usedChunks.Clear();

            for (int i = 0; i < endChunk.Count; i++) {

                endChunk[i].GetComponent<EndLevelChunk>().projectileManager.Unload();
                endChunk[i].GetComponent<EndLevelChunk>().DisableChunk();

            }

        }

        /// <summary>
        /// Creates a new Chunk.
        /// </summary>
        /// <param name="_prefab">The chunk prefab.</param>
        /// <returns>The ChunkData of the chunk.</returns>
        public ChunkData CreateChunk(GameObject _prefab) {

            GameObject instantiatedObject = Instantiate(_prefab,new Vector3(0,0,0),Quaternion.identity) as GameObject;
            instantiatedObject.transform.parent = chunkHolder.transform;
            instantiatedObject.name = _prefab.name;
            instantiatedObject.SetActive(false);
      
            return instantiatedObject.GetComponent<ChunkData>();      

        }

        /// <summary>
        /// Places the spawn chunk.
        /// </summary>
        public void SetSpawnChunk () {
            //Place the spawn Chunk.
            currentLevel = 1;
            spawnChunk.SetChunkPosition(new Vector3(-11f, 0, 0));
            spawnChunk.EnableChunk();
            generatedLength = spawnChunk.GetChunkLength();
            lengthToGenerate = 60;
            GenerateLevel(spawnChunk);
            
        }

        /// <summary>
        /// Generates a new level.
        /// </summary>
        public void GenerateNewLevel () {

            for (int i = 0; i < usedChunks.Count; i++) {

                ChunkData chunk = usedChunks[i];
                chunk.DisableChunk();
                availableChunks.Add(chunk);

            }

            //Stop spawning projectiles.
            endChunk[lastEndPoint].GetComponent<EndLevelChunk>().projectileManager.StopSpawning();

            currentLevel++;

            spawnChunk.DisableChunk();
            usedChunks.Clear();
            generatedLength = spawnChunk.GetChunkLength();
            lengthToGenerate = 60;
            GenerateLevel(lastSpawnedChunk);
            
        }

        private void GenerateLevel (ChunkData _previousChunk) {

            if (generatedLength >= lengthToGenerate) {

                endChunk[lastEndPoint].GetComponent<EndLevelChunk>().projectileManager.StopSpawning();
                //Generating level is finished, place end chunk.
                lastEndPoint++;

                if (lastEndPoint == 2) {

                    lastEndPoint = 0;

                }
                endChunk[lastEndPoint].SetChunkPosition(_previousChunk.endPoint.position);
                endChunk[lastEndPoint].EnableChunk();
                lastSpawnedChunk = endChunk[lastEndPoint];
              

            } else {

                ChunkData randomChunk = availableChunks[Random.Range(0, availableChunks.Count)];
                availableChunks.Remove(randomChunk);
                usedChunks.Add(randomChunk);
                randomChunk.SetChunkPosition(_previousChunk.endPoint.position);
                randomChunk.EnableChunk();
                generatedLength += randomChunk.GetChunkLength();
                lastSpawnedChunk = randomChunk;
                GenerateLevel(randomChunk);

            }

        }

    }

}