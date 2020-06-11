using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class SpawnBuildings : MonoBehaviour {

	public GameObject building;
    public GameObject shop;

	public int buildingCount;
    public Vector2 buildingRange;
    private Vector3 spawnPoint;
	List<GameObject> buildingList = new List<GameObject>();
	public static SpawnBuildings buildingSpawnerRef;
	private GameObject PlayerSpawner;
	private Transform Player;
	private Vector3 currentChunk = new Vector3(0,0,0);
	public List<Vector3> chunkList;
	private SpawnBuildings buildingSpawner;
	public int chunkSize = 800;
    public int safetyRadius = 50;

    //Building size modifiers===========================
    private float scaleFactor;
    private float bulkFactor;
    private float bulkOther;

    int shopID; //Used to generate upgrade shop

    void Awake()
	{
		if(buildingSpawnerRef == null)
		{
			buildingSpawnerRef = this;
		}
		else if (buildingSpawnerRef != this)
		{
			Destroy(gameObject);
		}
	}
    
	void Start () {
		Player = GameObject.FindWithTag("Player").transform;
		buildingSpawner = GetComponentInChildren<SpawnBuildings> ();
		buildingSpawner.buildingCount = buildingCount;
		SpawnGrid ();
		currentChunk = Vector3.zero;

	}

	public void SpawnGrid() {
		for (int i = -1; i <= 1; i++) {
			for (int j = -1; j <= 1; j++) {
				buildingSpawner.BuildingSpawn (buildingCount, new Vector3 (chunkSize * i, 0, chunkSize * j));
				chunkList.Add (new Vector3 (chunkSize * i, 0, chunkSize * j));

			}
		}
	}
    
	void Update () {
		Player = GameObject.FindWithTag("Player").transform;

		if (Player.transform.position.z > currentChunk.z + chunkSize) {
			currentChunk = new Vector3(currentChunk.x, 0, currentChunk.z + chunkSize);  //set currentChunk to the one we just entered
			Vector3 newChunk = new Vector3(currentChunk.x, 0, currentChunk.z + chunkSize);
			if (!chunkList.Contains (newChunk)) {
				buildingSpawner.BuildingSpawn (buildingSpawner.buildingCount, newChunk);
				chunkList.Add (newChunk);
			}
			newChunk = new Vector3(currentChunk.x + chunkSize, 0, currentChunk.z + chunkSize);
			if (!chunkList.Contains (newChunk)) {
				buildingSpawner.BuildingSpawn (buildingSpawner.buildingCount, newChunk);
				chunkList.Add (newChunk);
			} //see if newChunk is in chunkList, if not, then generate
			newChunk = new Vector3(currentChunk.x - chunkSize, 0, currentChunk.z + chunkSize);
			if (!chunkList.Contains (newChunk)) {
				buildingSpawner.BuildingSpawn (buildingSpawner.buildingCount, newChunk);
				chunkList.Add (newChunk);
			}
		}

		if (Player.transform.position.z < currentChunk.z - chunkSize) {
			currentChunk = new Vector3(currentChunk.x, 0, currentChunk.z - chunkSize);  //set currentChunk to the one we just entered
			Vector3 newChunk = new Vector3(currentChunk.x, 0, currentChunk.z - chunkSize);

			if (!chunkList.Contains (newChunk)) {
				buildingSpawner.BuildingSpawn (buildingSpawner.buildingCount, newChunk);
				chunkList.Add (newChunk);
			}
			newChunk = new Vector3(currentChunk.x + chunkSize, 0, currentChunk.z - chunkSize);
			if (!chunkList.Contains (newChunk)) {
				buildingSpawner.BuildingSpawn (buildingSpawner.buildingCount, newChunk);
				chunkList.Add (newChunk);
			} //see if newChunk is in chunkList, if not, then generate
			newChunk = new Vector3(currentChunk.x - chunkSize, 0, currentChunk.z - chunkSize);
			if (!chunkList.Contains (newChunk)) {
				buildingSpawner.BuildingSpawn (buildingSpawner.buildingCount, newChunk);
				chunkList.Add (newChunk);
			}
		}

		if (Player.transform.position.x > currentChunk.x + chunkSize) {
			Debug.Log (Player.transform.position.x);
			currentChunk = new Vector3(currentChunk.x + chunkSize, 0, currentChunk.z);  //set currentChunk to the one we just entered
			Vector3 newChunk = new Vector3(currentChunk.x + chunkSize, 0, currentChunk.z);
			if (!chunkList.Contains (newChunk)) {
				buildingSpawner.BuildingSpawn (buildingSpawner.buildingCount, newChunk);
				chunkList.Add (newChunk);
			}
			newChunk = new Vector3(currentChunk.x + chunkSize, 0, currentChunk.z + chunkSize);
			if (!chunkList.Contains (newChunk)) {
				buildingSpawner.BuildingSpawn (buildingSpawner.buildingCount, newChunk);
				chunkList.Add (newChunk);
			} //see if newChunk is in chunkList, if not, then generate
			newChunk = new Vector3(currentChunk.x + chunkSize, 0, currentChunk.z - chunkSize);
			if (!chunkList.Contains (newChunk)) {
				buildingSpawner.BuildingSpawn (buildingSpawner.buildingCount, newChunk);
				chunkList.Add (newChunk);
			}
		}

		if (Player.transform.position.x < currentChunk.x - chunkSize) {
			currentChunk = new Vector3(currentChunk.x - chunkSize, 0, currentChunk.z);  //set currentChunk to the one we just entered
			Vector3 newChunk = new Vector3(currentChunk.x - chunkSize, 0, currentChunk.z);  //newChunk to try to generate
			if (!chunkList.Contains (newChunk)) {
				buildingSpawner.BuildingSpawn (buildingSpawner.buildingCount, newChunk);
				chunkList.Add (newChunk);
			}
			newChunk = new Vector3(currentChunk.x - chunkSize, 0, currentChunk.z + chunkSize);
			if (!chunkList.Contains (newChunk)) {
				buildingSpawner.BuildingSpawn (buildingSpawner.buildingCount, newChunk);
				chunkList.Add (newChunk);
			} //see if newChunk is in chunkList, if not, then generate
			newChunk = new Vector3(currentChunk.x - chunkSize, 0, currentChunk.z - chunkSize);
			if (!chunkList.Contains (newChunk)) {
				buildingSpawner.BuildingSpawn (buildingSpawner.buildingCount, newChunk);
				chunkList.Add (newChunk);
			}
		}
	}

	public void BuildingSpawn(int buildingNumber, Vector3 spawnCenter) {
        shopID = Random.Range(0, buildingNumber);
        
		for (int i = 0; i <= buildingNumber; ++i) {
            //spawnPoint.x = Random.Range (-buildingRange.x, buildingRange.y);
            //spawnPoint.z = Random.Range (-buildingRange.x, buildingRange.y);
            if(CheckSpawnPoint())
            {
                scaleFactor = Random.Range(0,3);
				if (scaleFactor <= 1) {
					scaleFactor = Random.Range(15,40);
				}
				else {
					scaleFactor = Random.Range(40, 100);
				}
                bulkFactor = Random.Range(10, 30);
                bulkOther = Random.Range(1, 20);

                GameObject tempBuild;
                if (i == shopID)
                {
                    tempBuild = (GameObject)Instantiate(shop, spawnPoint + spawnCenter, Quaternion.identity, buildingSpawner.transform);
                }
                else
                {
                    tempBuild = (GameObject)Instantiate(building, spawnPoint + spawnCenter, Quaternion.identity, buildingSpawner.transform);
                    tempBuild.transform.localScale = new Vector3(bulkFactor, scaleFactor, bulkOther);
                }
                //tempBuild.transform.position = new Vector3 (spawnPoint.x, scaleFactor, spawnPoint.z);
                buildingList.Add(tempBuild);
            }
		}
			
	}
    bool CheckSpawnPoint()
    {
        spawnPoint.x = Random.Range(-buildingRange.x, buildingRange.y);
        spawnPoint.z = Random.Range(-buildingRange.x, buildingRange.y);
        float distance = Vector3.Magnitude(spawnPoint);
        if (distance > safetyRadius)
        {
            return true;
        }
        return false;
    }
    public void Reconstruct()
	{
		foreach(GameObject buildingRef in buildingList)
		{
			Destroy(buildingRef);
		}
		buildingList.Clear();
		chunkList.Clear ();
		currentChunk = Vector3.zero;
    }
}
