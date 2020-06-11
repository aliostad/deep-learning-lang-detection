using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChunkManager : MonoBehaviour {

    public List<Chunk> chunkList;

    GenerateLevel generator;

    private void Start()
    {
        chunkList = new List<Chunk>();
        generator = GameObject.FindGameObjectWithTag("Core").GetComponent<GenerateLevel>();

        chunkList.Add(new Chunk(generator.AddChunk(0, 0), new Vector2(0,0)));
        chunkList.Add(new Chunk(generator.AddChunk(0, -1), new Vector2(0, -1)));
        chunkList.Add(new Chunk(generator.AddChunk(1, 0), new Vector2(1, 0)));
        chunkList.Add(new Chunk(generator.AddChunk(1, -1), new Vector2(1, -1)));
        chunkList.Add(new Chunk(generator.AddChunk(-1, 0), new Vector2(-1, 0)));
        chunkList.Add(new Chunk(generator.AddChunk(-1, -1), new Vector2(-1, -1)));
    }

    public void EnabledChunk(float _posX, float _posY, bool _enabled)
    {
        _posY = Mathf.Abs(_posY) * -1;

        var chunk = chunkList.Find(x => x.Position.x == _posX && x.Position.y == _posY);
        if (chunk != null)
        {
            chunk.ChunkObject.SetActive(_enabled);
        } else
        {
            chunkList.Add(new Chunk(generator.AddChunk((int)_posX, (int)_posY), new Vector2(_posX, _posY)));
        }
    }
}

[System.Serializable]
public class Chunk
{
    public string Name;
    public GameObject ChunkObject;
    public Vector2 Position;

    public Chunk(GameObject _chunk, Vector2 _pos)
    {
        this.Name = string.Format("Chunk ({0},{1})", _pos.x, _pos.y);
        this.ChunkObject = _chunk;
        this.Position = _pos;
    }
}
