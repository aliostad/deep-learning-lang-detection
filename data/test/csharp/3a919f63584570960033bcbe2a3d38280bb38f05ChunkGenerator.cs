//using UnityEngine;
//using System.Collections;
//using System.Collections.Generic;
//public class ChunkGenerator : MonoBehaviour {


//    public GameObject[] ChunkPrefabs;
//    public GameObject currentChunk;
//    public List<GameObject> chunks;
//    int currentChunkIndex;
//    int previousChunkIndex;
//    // Use this for initialization
//    void Start () {
//        currentChunkIndex = 0;
//        currentChunk = chunks[currentChunkIndex];
//        previousChunkIndex = 0;
//        for (int i = 0; i < 10; i++)
//        {
//            GenerateNewChunk();    
//        }
        
//    }

//    void GenerateNewChunk()
//    {
//        GameObject temp = Instantiate(ChunkPrefabs[RandomIntGenerator()], currentChunk.GetComponent<SChunk>().nextChunkPosition.transform.position, Quaternion.identity) as GameObject;

//        chunks.Add(temp);
     
//        UpdateCurrentChunk();
    
//    }
//    void KillPreviousChunk()
//    {
//        previousChunkIndex++;
//    }
//    void UpdateCurrentChunk()
//    {
//        currentChunkIndex++;
//        Debug.Log(currentChunkIndex);
//        currentChunk = chunks[currentChunkIndex];
//    }
//    int RandomIntGenerator()
//    {
//        while (true)
//        {
//            int temp = Random.Range(0, ChunkPrefabs.Length - 1);
            
//                //currentChunkIndex = temp;
//                return temp;
            
//        }
        
//    }
//}
