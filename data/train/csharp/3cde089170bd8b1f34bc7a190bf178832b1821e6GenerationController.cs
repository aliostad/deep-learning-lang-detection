using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Random = UnityEngine.Random;
using System.Threading;
using UnityEngine.UI;

public class GenerationController : MonoBehaviour {

	private byte curBlockSelection = 1;
	private Texture dirtTexture;
	private Texture stoneTexture;
	private Texture sandTexture;

	private List<Thread> threads = new List<Thread> ();
	public int maxThreads = 8;

	public int viewDistance = 6;
	private int generationDistance;
	private int initializeDistance;
	
	public int ChunkSizeX = 8;
	public int ChunkSizeY = 64;
	public int ChunkSizeZ = 8;


	public static Material material;

	public GameObject player;
	public Camera camera;

	public GeneratorSpec[] generators;

	private int seed;
	//private List<List<Chunk>> chunks;

	public static Dictionary<string, Chunk> chunkMap;

	private bool initializing;

	// Use this for initialization
	void Start () {
		generationDistance = viewDistance +2;
		initializeDistance = generationDistance + 1;
		material = Resources.Load("Materials/GameWorld", typeof(Material)) as Material;

		dirtTexture = Resources.Load ("textures/dirt", typeof(Texture)) as Texture;
		stoneTexture = Resources.Load ("textures/stone", typeof(Texture)) as Texture;
		sandTexture = Resources.Load ("textures/sand", typeof(Texture)) as Texture;


		//Resources.Load("textureSheet", type

		initializing = true;
		seed = Random.Range(int.MinValue , int.MaxValue);
		chunkMap = new Dictionary<string, Chunk>();

		BlockUVLibrary.Initialize ();
		BlockLibrary.initialize ();

		generators = new GeneratorSpec[1];
		GeneratorSpec testGenerator = new GeneratorSpec (seed, new byte[] {0,1,2,3,4,5});
		generators [0] = testGenerator;

		StartCoroutine( InitialGenerate () );
	}

	
	
	private void OnGUI()
	{
		if (GUI.Button (new Rect (10, 10, 60, 60), "empty")) {
			curBlockSelection = 0;
		}
		if (GUI.Button (new Rect (80, 10, 60, 60), dirtTexture)) {
			curBlockSelection = 1;
		}
		if (GUI.Button (new Rect (150, 10, 60, 60), stoneTexture)) {
			curBlockSelection = 2;
		}
		if (GUI.Button (new Rect (220, 10, 60, 60), sandTexture)) {
			curBlockSelection = 3;
		}
	}

	IEnumerator InitialGenerate()
	{
		player.SetActive (false);

		chunkMap.Add("0,0", new Chunk(0, 0, ChunkSizeX, ChunkSizeY, ChunkSizeZ));
		chunkMap.Add("1,0", new Chunk(1, 0, ChunkSizeX, ChunkSizeY, ChunkSizeZ));
		chunkMap.Add("0,1", new Chunk(0, 1, ChunkSizeX, ChunkSizeY, ChunkSizeZ));
		chunkMap.Add("-1,0", new Chunk(-1, 0, ChunkSizeX, ChunkSizeY, ChunkSizeZ));
		chunkMap.Add("0,-1", new Chunk(0, -1, ChunkSizeX, ChunkSizeY, ChunkSizeZ));

		GenerateChunk (0, 0);
		GenerateChunk (1, 0);
		GenerateChunk (0, 1);
		GenerateChunk (-1, 0);
		GenerateChunk (0, -1);

		yield return StartCoroutine (ShowChunk (0, 0));

		Debug.Log ("INITIALIZATION COMPLETE!!!");
		player.SetActive (true);
		player.transform.position = new Vector3 (ChunkSizeX * .5f, ChunkSizeY + 10, ChunkSizeZ * .5f);
		initializing = false;
	}

	// Update is called once per frame
	int frameCount =0;
	void Update () {
		frameCount ++;
		if (frameCount == 4)
			frameCount = 0;
		if (initializing)
			return;

		int chunkX =  player.transform.position.x >= 0 ? (int)((player.transform.position.x / ChunkSizeX)) : ((int)(player.transform.position.x / ChunkSizeX)) - 1;
		int chunkZ =  player.transform.position.z >= 0 ? (int)((player.transform.position.z / ChunkSizeZ)) : ((int)(player.transform.position.z / ChunkSizeZ)) - 1;

		for (int i = threads.Count-1; i >= 0; i--) {
			if(!threads[i].IsAlive)
				threads.RemoveAt (i);
		}

		//Debug.Log ("cx = " + chunkX + "  cy = " + chunkZ);
		if (frameCount % 2 == 0) {
			for (int x = chunkX - (initializeDistance); x <= chunkX + (initializeDistance); x++) {
				for (int z = chunkZ - (initializeDistance); z <= chunkZ + (initializeDistance); z++) {
					if (! chunkMap.ContainsKey (x + "," + z)) {
						Chunk c = new Chunk (x, z, ChunkSizeX, ChunkSizeY, ChunkSizeZ);
						chunkMap.Add (x + "," + z, c);
					}
				}
			}
		}

		if (frameCount % 2 == 1) {
			for (int x = chunkX - (generationDistance); x <= chunkX + (generationDistance); x++) {
				for (int z = chunkZ - (generationDistance); z <= chunkZ + (generationDistance); z++) {
					if (threads.Count < maxThreads && chunkMap.ContainsKey (x + "," + z) && chunkMap [x + "," + z].isReadyToGenerate) {
						chunkMap [x + "," + z].isReadyToGenerate = false;
						chunkMap [x + "," + z].isGenerating = true;
						//StartCoroutine(GenerateChunk(x,z));

						ChunkGenerationController cg = new ChunkGenerationController (x, z, ChunkSizeX, ChunkSizeY, ChunkSizeZ, generators);
						Thread oThread = new Thread (new ThreadStart (cg.GenerateChunk));
						oThread.Start ();

						threads.Add (oThread);
						//return;
					}

					if (x == chunkX - (viewDistance + 1) || x == chunkX + (viewDistance + 1)
						|| z == chunkZ - (viewDistance + 1) || z == chunkZ + (viewDistance + 1)) {
						if (chunkMap.ContainsKey (x + "," + z) && chunkMap [x + "," + z].gameObject != null && chunkMap [x + "," + z].isGenerating == false) {
							DestroyChunk (x, z);
							//return;
						}
					}
				}
			}
		}


		for (int x = chunkX - (viewDistance); x <= chunkX + (viewDistance); x++) {
			for (int z = chunkZ - (viewDistance); z <= chunkZ + (viewDistance); z++) {
				if(chunkMap.ContainsKey(x+","+z) )
				{
					Chunk c = chunkMap[x+","+z];
					if(c != null && c.gameObject == null && ! c.isGenerating && !c.isReadyToGenerate
					   && chunkMap.ContainsKey((x+1)+","+z) && !chunkMap[(x+1)+","+z].isGenerating && !chunkMap[(x+1)+","+z].isReadyToGenerate
					   && chunkMap.ContainsKey((x-1)+","+z) && ! chunkMap[(x-1)+","+z].isGenerating && !chunkMap[(x-1)+","+z].isReadyToGenerate
					   && chunkMap.ContainsKey(x+","+(z+1)) &&!chunkMap[x+","+(z+1)].isGenerating && !chunkMap[x+","+(z+1)].isReadyToGenerate
					   && chunkMap.ContainsKey(x+","+(z-1)) &&! chunkMap[x+","+(z-1)].isGenerating && !chunkMap[x+","+(z-1)].isReadyToGenerate
					   )
                    {
						if(c.isReadyToView)
						{
							StartCoroutine(ShowChunk(x, z));
							//return;
						}
						else if(threads.Count < maxThreads && !c.isInitializingArrays)
						{
							c.isInitializingArrays = true;
							Thread oThread = new Thread(new ThreadStart( c.InitializeArrays ));
							oThread.Start();

							threads.Add(oThread);
							//return;
						}
                    }
				}
			}
		}


		if (Input.GetMouseButton(0)) {
			OnMouseDown();
		}
	}

	public void GenerateChunk(int x, int z)
	{
		Debug.Log("Generating " +x +" , " + z);
		//Chunk c = new Chunk(x, z, ChunkSizeX, ChunkSizeY, ChunkSizeZ);						
		Chunk c = chunkMap [x + "," + z];

		//chunkMap.Add (x + "," + z, c);
		c.isGenerating = true;
		for (int i = 0; i < generators.Length; i++) {

			//generators [i].Generate (c) ;
			new ChunkGenerator(generators[i]).Generate(c, null);
		}

		c.isGenerating = false;

		//TODO Using dictionary to hold x,y of chunks
		//this feels super hacky, but not sure the right way to do it.  
		//Doubly linked lists might be slightly better and worth exploring later.
	}

	public IEnumerator ShowChunk(int x, int z)
	{
		Chunk c = chunkMap [x + "," + z];
		//Debug.Log("Building View " +x +" , " + z);
		if (c.isReadyToView) 
		{
			yield return StartCoroutine( c.InitializeView () );
		}
		else if(! c.isInitializingArrays)
		{
			c.InitializeArrays() ;
			yield return StartCoroutine( c.InitializeView () );
		}
	}
	public void DestroyChunk(int x, int z)
	{
		chunkMap [x + "," + z].DestroyView ();
	}

	private void OnMouseDown() {

		RaycastHit hit;

		Ray ray = new Ray(player.transform.position, camera.transform.forward);//ScreenPointToRay(Camera.);//Input.mousePosition
		if (Physics.Raycast (ray, out hit, 10)) {
			//Transform objectHit = hit.transform;

			if(hit.distance < 3 && curBlockSelection != 0)
				return;


			Vector3 v = hit.point + camera.transform.forward * .1f;
			int x = (int)v.x;
			int y = (int)v.y;
			int z = (int)v.z;
			int chunkX = (int)(x / ChunkSizeX);
			int chunkZ = (int)(z / ChunkSizeZ);
			int localX = x % ChunkSizeX;
			if (localX < 0) {
				localX += ChunkSizeX;
				chunkX -=1;
			}
			int localZ = z % ChunkSizeZ;
			if (localZ < 0)
			{
				localZ += ChunkSizeZ;
				chunkZ -=1;
			}
			//Chunk c = chunkMap[chunkX+","+ chunkZ];
			//Debug.Log ("Block is : " + c.blocks[localX, y, localZ]);

			bool px = false,pz = false,pxpz = false,nx = false,nz = false,nxnz = false,pxnz = false, nxpz = false;

			for(var i = localX-1; i<= localX +1; i++)
			{
				for(var j = y-1; j<= y +1; j++)
				{
					if(j >= 0 && j < ChunkSizeY)
					{
					
						for(var k = localZ-1; k<= localZ +1; k++)
						{
							if(i < 0)
							{
								if(k < 0)
								{
									chunkMap[(chunkX-1)+","+(chunkZ-1)].blocks[i+ChunkSizeX, j,k+ChunkSizeZ] = curBlockSelection;
									nxnz = true;
								}
								else if(k >= ChunkSizeZ)
								{
									chunkMap[(chunkX-1)+","+(chunkZ+1)].blocks[i+ChunkSizeX, j,k-ChunkSizeZ] = curBlockSelection;
									nxpz = true;
								}
								else
								{
									chunkMap[(chunkX-1)+","+chunkZ].blocks[i+ChunkSizeX, j,k] = curBlockSelection;
								}

								nx = true;
							}
							else if(i >= ChunkSizeX)
							{
								if(k < 0)
								{
									chunkMap[(chunkX+1)+","+(chunkZ-1)].blocks[i-ChunkSizeX, j,k+ChunkSizeZ] = curBlockSelection;
									pxnz = true;
								}
								else if(k >= ChunkSizeZ)
								{
									chunkMap[(chunkX+1)+","+(chunkZ+1)].blocks[i-ChunkSizeX, j,k-ChunkSizeZ] = curBlockSelection;
									pxpz = true;
								}
								else
								{
									chunkMap[(chunkX+1)+","+chunkZ].blocks[i-ChunkSizeX, j,k] = curBlockSelection;
								}

								px = true;
							}
							else if(k < 0)
							{
								chunkMap[chunkX+","+(chunkZ-1)].blocks[i, j,k+ChunkSizeZ] = curBlockSelection;
								nz = true;
							}
							else if(k >= ChunkSizeZ)
							{
								chunkMap[chunkX+","+(chunkZ+1)].blocks[i, j,k-ChunkSizeZ] = curBlockSelection;
								pz = true;
							}
							else
							{
								chunkMap[chunkX+","+chunkZ].blocks[i, j,k] = curBlockSelection;
								if(i == 0)
									nx = true;
								if(k == 0)
									nz = true;
								if(i == ChunkSizeX-1)
									px = true;
								if(k == ChunkSizeZ-1)
									pz = true;
							}
						}
					}
				}
			}

			updateChunk(chunkX,chunkZ);
			if(px)
				updateChunk(chunkX+1, chunkZ);
			if(nx)
				updateChunk(chunkX-1, chunkZ);
			if(pz)
				updateChunk(chunkX, chunkZ+1);
			if(nz)
				updateChunk(chunkX, chunkZ-1);

			if(pxpz)
				updateChunk(chunkX+1, chunkZ+1);
			if(nxpz)
				updateChunk(chunkX-1, chunkZ+1);
			if(pxnz)
				updateChunk(chunkX+1, chunkZ-1);
			if(nxnz)
				updateChunk(chunkX-1, chunkZ-1);
			// Do something with the object that was hit by the raycast.
		}
	}

	private void updateChunk(int x, int z)
	{
		chunkMap[x+","+z].isInitializingArrays = true;

		chunkMap[x+","+z].InitializeArrays() ;
		chunkMap[x+","+z].UpdateView();
	}
}


public class ChunkGenerationController
{
	private int x, z, ChunkSizeX, ChunkSizeY, ChunkSizeZ;
	private GeneratorSpec[] generators;

	Chunk c;

	public ChunkGenerationController(int x , int z, int chunkSizeX, int chunkSizeY, int chunkSizeZ, GeneratorSpec[] generators)
	{
		this.generators = generators;
		this.x = x; this.z = z;
		this.ChunkSizeX = chunkSizeX;
		this.ChunkSizeY = chunkSizeY;
		this.ChunkSizeZ = chunkSizeZ;
	}

	public void GenerateChunk()
	{
		//Debug.Log("Generating " +x +" , " + z);
		
		Chunk c = GenerationController.chunkMap [x + "," + z];

		c.isGenerating = true;
		for (int i = 0; i < generators.Length; i++) {
			new ChunkGenerator(generators[i]).Generate(c, null);
			//generators [i].Generate (c);
		}

		c.isGenerating = false;
		
		//TODO Using dictionary to hold x,y of chunks
		//this feels super hacky, but not sure the right way to do it.  
		//Doubly linked lists might be slightly better and worth exploring later.
	}

}
