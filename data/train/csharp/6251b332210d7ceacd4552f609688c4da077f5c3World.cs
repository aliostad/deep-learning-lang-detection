using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class World : MonoBehaviour {

  public Dictionary<WorldPos, Chunk> chunks = new Dictionary<WorldPos, Chunk>();
  public GameObject chunkPrefab;

  public string worldName = "world";
  public GameObject terrainObject;
  [HideInInspector]
  public Generator terrain;

  void Start()
  {
    terrain = terrainObject.GetComponent<Generator>();
  }

  // Update is called once per frame
  void Update()
  {

  }

  public void CreateChunk(int x, int y, int z)
  {
    WorldPos worldPos = new WorldPos(x, y, z);

    //Instantiate the chunk at the coordinates using the chunk prefab
    GameObject newChunkObject = Instantiate(
                                  chunkPrefab, new Vector3(worldPos.x, worldPos.y, worldPos.z),
                                  Quaternion.Euler(Vector3.zero)
                                ) as GameObject;

    newChunkObject.transform.SetParent(transform);

    Chunk newChunk = newChunkObject.GetComponent<Chunk>();

    newChunk.pos = worldPos;
    newChunk.world = this;

    //Add it to the chunks dictionary with the position as the key
    chunks.Add(worldPos, newChunk);

    newChunk.Generate(terrain);

    if(newChunk.save) {
      Serialization.Load(newChunk);
    }
    newChunk.update = true;
  }

  public void DestroyChunk(int x, int y, int z)
  {
    Chunk chunk = null;
    if (chunks.TryGetValue(new WorldPos(x, y, z), out chunk))
    {
      if(chunk.save && chunk.rendered) {
        Serialization.SaveChunk(chunk);
      }
      Object.Destroy(chunk.gameObject);
      chunks.Remove(new WorldPos(x, y, z));
    }
  }

  public Chunk GetChunk(int x, int y, int z)
  {
    WorldPos pos = new WorldPos();
    float multiple = Chunk.chunkSize;
    pos.x = Mathf.FloorToInt(x / multiple) * Chunk.chunkSize;
    pos.y = Mathf.FloorToInt(y / multiple) * Chunk.chunkSize;
    pos.z = Mathf.FloorToInt(z / multiple) * Chunk.chunkSize;

    Chunk containerChunk = null;

    chunks.TryGetValue(pos, out containerChunk);

    return containerChunk;
  }

  public Block GetBlock(int x, int y, int z)
  {
    Chunk containerChunk = GetChunk(x, y, z);

    if (containerChunk != null && containerChunk.generated)
    {
      Block block = containerChunk.GetBlock(
      x - containerChunk.pos.x,
      y - containerChunk.pos.y,
      z - containerChunk.pos.z);

      return block;
    }
    else
    {
      return new BlockAir();
    }

  }

  public void SetBlock(int x, int y, int z, Block block)
  {
    Chunk chunk = GetChunk(x, y, z);

    if (chunk != null)
    {
      chunk.SetBlock(x - chunk.pos.x, y - chunk.pos.y, z - chunk.pos.z, block);
      chunk.update = true;

      UpdateIfEqual(x - chunk.pos.x, 0, new WorldPos(x - 1, y, z));
      UpdateIfEqual(x - chunk.pos.x, Chunk.chunkSize - 1, new WorldPos(x + 1, y, z));
      UpdateIfEqual(y - chunk.pos.y, 0, new WorldPos(x, y - 1, z));
      UpdateIfEqual(y - chunk.pos.y, Chunk.chunkSize - 1, new WorldPos(x, y + 1, z));
      UpdateIfEqual(z - chunk.pos.z, 0, new WorldPos(x, y, z - 1));
      UpdateIfEqual(z - chunk.pos.z, Chunk.chunkSize - 1, new WorldPos(x, y, z + 1));

      UpdateIfBothEqual(x - chunk.pos.x, 0, new WorldPos(x - 1, y, z - 1), y - chunk.pos.y, 0);
      UpdateIfBothEqual(x - chunk.pos.x, Chunk.chunkSize - 1, new WorldPos(x + 1, y, z - 1), y - chunk.pos.y, 0);
      UpdateIfBothEqual(x - chunk.pos.x, 0, new WorldPos(x - 1, y, z + 1), y - chunk.pos.y, Chunk.chunkSize - 1);
      UpdateIfBothEqual(x - chunk.pos.x, Chunk.chunkSize - 1, new WorldPos(x + 1, y, z + 1), y - chunk.pos.y, Chunk.chunkSize - 1);
    }
  }

  public void UpdateAround(WorldPos pos) {
    for(int y = pos.y-1 ; y <= pos.y+1 ; y++) {
      Chunk chunk = GetChunk(pos.x, pos.y, pos.z);
      if (chunk != null) chunk.update = true;

      chunk = GetChunk(pos.x-1, pos.y, pos.z);
      if (chunk != null) chunk.update = true;

      chunk = GetChunk(pos.x+1, pos.y, pos.z);
      if (chunk != null) chunk.update = true;

      chunk = GetChunk(pos.x, pos.y, pos.z-1);
      if (chunk != null) chunk.update = true;

      chunk = GetChunk(pos.x, pos.y, pos.z+1);
      if (chunk != null) chunk.update = true;

      chunk = GetChunk(pos.x-1, y, pos.z-1);
      if (chunk != null) chunk.update = true;

      chunk = GetChunk(pos.x+1, y, pos.z+1);
      if (chunk != null) chunk.update = true;

      chunk = GetChunk(pos.x+1, y, pos.z-1);
      if (chunk != null) chunk.update = true;

      chunk = GetChunk(pos.x-1, y, pos.z+1);
      if (chunk != null) chunk.update = true;
    }
  }

  void UpdateIfEqual(int value1, int value2, WorldPos pos)
  {
    if (value1 == value2)
    {
      Chunk chunk = GetChunk(pos.x, pos.y, pos.z);
      if (chunk != null && chunk.generated)
        chunk.update = true;
    }
  }

  void UpdateIfBothEqual(int value1, int value2, WorldPos pos, int value3, int value4)
  {
    if (value1 == value2 && value3 == value4)
    {
      Chunk chunk = GetChunk(pos.x, pos.y, pos.z);
      if (chunk != null && chunk.generated)
        chunk.update = true;
    }
  }

  void OnDestroy() {
    foreach (Chunk chunk in chunks.Values) {
      if(chunk.save && chunk.rendered) {
        Serialization.SaveChunk(chunk);
      }
    }
  }
}
