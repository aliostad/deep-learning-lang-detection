using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using UnityEngine;

public class ChunkLoader : MonoBehaviour
{
    private World _world;
    private Vector2I _currentChunk;
    private Vector2I _lastChunk;

    /// <summary>
    /// Set the position of the loader relative to the block grid
    /// </summary>
    /// <param name="position"></param>
    public void setPosition(Vector2I position)
    {
        _currentChunk = position;
        _lastChunk = _currentChunk;
        transform.position = new Vector2(_currentChunk.x * Chunk.tileDimension, _currentChunk.y * Chunk.tileDimension);
    }

    public void setWorld(World world)
    {
        _world = world;
    }

    void Update()
    {
        _lastChunk = _currentChunk;

        Vector2I chunkPos = BlockUtil.chunkPositionFromWorld(transform.position);

        _currentChunk = chunkPos;

        // The chunk loader has moved!
        if(_lastChunk != _currentChunk)
        {
            //Debug.Log(String.Format("Chunk changed from {0} to {1}", _lastChunk, _currentChunk));
            _world.loaderMoved(chunkPos);
        }
    }
    
}