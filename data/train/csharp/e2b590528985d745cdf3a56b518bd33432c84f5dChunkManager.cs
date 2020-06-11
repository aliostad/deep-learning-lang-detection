using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using System.Collections;
using System.Collections.Generic;
using System.Linq;


public class ChunkManager : MonoBehaviour {

    public int totalChunks;
    public float lutFadeTime = 2;

    [Space]

    public List<Chunk> glitchChunkList = new List<Chunk>();
    public List<Chunk> airbnbChunkList = new List<Chunk>();
    public List<Chunk> squareChunkList = new List<Chunk>();
    public List<Chunk> awardsChunkList = new List<Chunk>();
    public List<Chunk> gdcChunkList = new List<Chunk>();

    [Space]

    public List<GameObject> glitchObjectList = new List<GameObject>();
    public List<GameObject> airbnbObjectList = new List<GameObject>();
    public List<GameObject> squareObjectList = new List<GameObject>();
    public List<GameObject> awardsObjectList = new List<GameObject>();
    public List<GameObject> gdcObjectList = new List<GameObject>();

    [Space]

    public Texture airbnbLUT;
    public Texture squareLUT;
    public Texture awardsLUT;
    public Texture gdcLUT;

    List<Chunk> currentChunkList;
    Chunk lastChunk;


    public Chunk startChunk { get; set; }                  // The chunk the player starts on, to be destroyed after a set period of time TODO: Messy
    public Chunk activeChunk { get; set; }                 // The reference to the original chunk currently being looped
    public Chunk newestChunk { get; set; }                 // Reference to the most recent chunk created to actually be used

    public Chunk currentChunk { get; set; }                // The instantiated chunk the player is currently riding on


    int currentSection = 1;
    int currentChunkInList;
    List<GameObject> chunkList = new List<GameObject>();

    List<GameObject> specialObjectList = new List<GameObject>();


    void Awake() {

        Manager.chunkManager = this;
    }

    void Start() {

        currentChunkList = glitchChunkList;

        activateObjects(glitchObjectList, null);

        initialize();
    }

    void Update() {

        if (Input.GetKeyUp(KeyCode.Return)) {

            StartCoroutine(moveToNextSection());
        }
    }



    public void initialize() {

        Manager.cameraController.init();


        // Check if there is already a level chunk to start from            
        //foreach (Transform child in transform) {

        //    if (child.GetComponent<Chunk>() && child.GetComponent<Chunk>().startChunk) {

        //        chunkList.Add(child.gameObject);
        //    }

        //    // Go through all children chunks just to turn them off and find the start chunk
        //    if (child.GetComponent<Chunk>() && !child.GetComponent<Chunk>().startChunk) {

        //        // Add it to our list of chunks
        //        //originalChunkList.Add(child.GetComponent<Chunk>());

        //        // All chunks need to be run their awake and start methods so they need to be activated temporarily. LevelChunk will disable it's own gameobject once initialization is complete
        //        if (!child.GetComponent<Chunk>().initialized)
        //            child.gameObject.SetActive(true);
        //    }
        //    else if (child.GetComponent<Chunk>() && child.name.Equals("LevelChunk (Start)")) {
        //        startChunk = child.GetComponent<Chunk>();
        //    }
        //}

        //Chunk chunk = findChunk(firstChunk);
        //if (chunk == null)
        //    Debug.Log("Level Manager: initialize() : Can't find firstChunk: " + firstChunk);
        //else
        //    activeChunk = chunk;                 

        createChunk(new Vector3(0, 0, -360));
        createNextChunk();        
    }

    void createChunk(Vector3 pos) {

        activeChunk = currentChunkList[currentChunkInList];

        Chunk newChunk = Instantiate(activeChunk, pos, Quaternion.identity) as Chunk;
        newChunk.motherChunk = activeChunk;
        newChunk.name += " " + Mathf.Floor(Random.Range(0, 101));    // Random number used to differentiate between chunks at runtime

        // Move        
        newChunk.gameObject.SetActive(true);
        newChunk.updatePositions();

        chunkList.Add(newChunk.gameObject);

        currentChunkInList++;
        if (currentChunkInList == currentChunkList.Count)
            currentChunkInList = 0;
    }

    // Instantiate a chunk in front of the current one
    void createNextChunk() {
                

        Vector3 newChunkPosition = Vector3.zero;      // The first chunk created should be at zeros
        
        // If this is not the first chunk
        if (newestChunk != null) newChunkPosition = new Vector3(newestChunk.endPoint.transform.position.x, newestChunk.endPoint.transform.position.y, newestChunk.endPoint.transform.position.z);


        activeChunk = currentChunkList[currentChunkInList];

        Chunk newChunk = Instantiate(activeChunk, newChunkPosition, Quaternion.identity) as Chunk;
        newChunk.motherChunk = activeChunk;
        newChunk.name += " " + Mathf.Floor(Random.Range(0,101));    // Random number used to differentiate between chunks at runtime
        
        // Move        
        newChunk.gameObject.SetActive(true);
        newChunk.updatePositions();

        chunkList.Add(newChunk.gameObject);

        if (chunkList.Count >= totalChunks) {
            GameObject chunkToDestroy = chunkList[0];
            chunkList.Remove(chunkToDestroy);
            Destroy(chunkToDestroy, 1f);
        }

        // Variables
        lastChunk = newestChunk;
        newestChunk = newChunk;

        currentChunkInList++;
        if (currentChunkInList == currentChunkList.Count)
            currentChunkInList = 0;
    }
   

    // When the next chunk in the list has been changed via a switch, replace the chunk
    void updateNextChunk() {

        var newChunkPosition = newestChunk.transform.position;

        Chunk newChunk = Instantiate(activeChunk, newChunkPosition, Quaternion.identity) as Chunk;
        newChunk.motherChunk = activeChunk;
        newChunk.updatePositions();

        newChunk.gameObject.SetActive(true);
        Destroy(newestChunk.gameObject);

        // Variables        
        newestChunk = newChunk;   
    }    

    // Player collides with a level chunk collider
    public void playerTrigger(string transitionToChunk, ChunkCollider chunkCollider) {
      
        createNextChunk();                
    }

    public void destroyStartChunk() {

        Destroy(startChunk.gameObject, 30f);
    }

    IEnumerator disableChunk(Chunk chunk) {
        
        yield return new WaitForSeconds(1.0f);

        chunk.gameObject.SetActive(false);
    }

    IEnumerator moveToNextSection() {

        Manager.cameraController.fadeToBlack();

        currentSection++;
        currentChunkInList = 0;

        switch (currentSection) {

            case 2:
                currentChunkList = airbnbChunkList;
                StartCoroutine(activateObjects(airbnbObjectList, glitchObjectList));
                StartCoroutine(lutChange(airbnbLUT));
                break;

            case 3:
                currentChunkList = squareChunkList;
                StartCoroutine(activateObjects(squareObjectList, airbnbObjectList));
                StartCoroutine(lutChange(squareLUT));
                break;

            case 4:
                currentChunkList = awardsChunkList;
                StartCoroutine(activateObjects(awardsObjectList, squareObjectList));
                StartCoroutine(lutChange(awardsLUT));
                break;

            case 5:
                currentChunkList = gdcChunkList;
                StartCoroutine(activateObjects(gdcObjectList, awardsObjectList));
                StartCoroutine(lutChange(gdcLUT));
                break;
            case 6:
                end();
                break;
        }

        yield return new WaitForSeconds(2f);

        foreach (GameObject chunk in chunkList) {


            Destroy(chunk);
        }

        chunkList.Clear();
        newestChunk = null;

        initialize();
    }

    IEnumerator activateObjects(List<GameObject> objectsToActivate, List<GameObject> objectsToDeactivate) {

        yield return new WaitForSeconds(2.0f);

        if (objectsToDeactivate != null) {
            foreach (GameObject obj in objectsToDeactivate) {

                obj.SetActive(false);
            }
        }
        foreach (GameObject obj in objectsToActivate) {
            
            obj.SetActive(true);
        }
    }

    IEnumerator lutChange(Texture lut) {

        yield return new WaitForSeconds(2.0f);

        System.Action showMethod = delegate() { callback(); };
        Manager.postController.GetComponent<AmplifyColorBase>().BlendTo(lut, lutFadeTime, showMethod);
    }

    void callback() {


    }

    void end() {

        print("FIN");
    }
}