using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ChunkHandler
{
    private List<Chunk> chunks = new List<Chunk>();
    private bool autoDestroyLeft;
    private bool autoDestroyRight;
    private bool autoDestroyUp;
    private bool autoDestroyDown;
    private int chunkSize;

    public ChunkHandler(int size)
    {
        chunkSize = size;
    }

    Chunk createNewChunk(Vector2 target)
    {
        Rect rect = new Rect(Mathf.FloorToInt(target.x / chunkSize) * chunkSize, (Mathf.FloorToInt(target.y / chunkSize)) * chunkSize, chunkSize, chunkSize);
        Chunk newChunk = new Chunk(rect);
        Chunks.Add(newChunk);
        return newChunk;
    }

    public void destoryChunksDirection(string direction, Vector2 position)
    {
        if (direction == "left")
        {
            int maxX = (Mathf.FloorToInt(position.x / chunkSize) * chunkSize) - (chunkSize * 2);
            foreach (Chunk chunk in getNonRenderChunks(position))
            {
                if (chunk.ChunkRect.position.x < maxX)
                    destroyChunk(chunk);
            }
        }

        if (direction == "right")
        {
            int minX = (Mathf.FloorToInt(position.x / chunkSize) * chunkSize) + (chunkSize * 2);
            foreach (Chunk chunk in getNonRenderChunks(position))
            {
                if (chunk.ChunkRect.position.x > minX)
                    destroyChunk(chunk);
            }
        }

        if (direction == "up")
        {
            int minY = (Mathf.FloorToInt(position.y / chunkSize) * chunkSize) + (chunkSize * 2);
            foreach (Chunk chunk in getNonRenderChunks(position))
            {
                if (chunk.ChunkRect.position.y > minY)
                    destroyChunk(chunk);
            }
        }

        if (direction == "down")
        {
            int minY = (Mathf.FloorToInt(position.y / chunkSize) - (chunkSize * 2));
            foreach (Chunk chunk in getNonRenderChunks(position))
            {
                if (chunk.ChunkRect.position.y < minY)
                    destroyChunk(chunk);
            }
        }
    }

    public void destroyChunk(Chunk destory)
    {
        foreach (GameObject obj in destory.Objects)
        {
            GameObject.Destroy(obj);
        }
        Chunks.Remove(destory);
    }

    List<Chunk> getNonRenderChunks(Vector2 position)
    {
        List<Chunk> nonRenderChunks = new List<Chunk>(Chunks);
        foreach (Chunk chunk in getRenderChunks(position))
        {
            nonRenderChunks.Remove(chunk);
        }
        return nonRenderChunks;
    }

    public List<Chunk> getEmptyChunks()
    {
        List<Chunk> emptyChunks = new List<Chunk>();
        foreach (Chunk chunk in Chunks)
        {
            if (chunk.Objects.Count == 0)
                emptyChunks.Add(chunk);
        }
        return emptyChunks;
    }

    public List<Chunk> getRenderChunks(Vector2 position)
    {
        List<Chunk> renderChunks = new List<Chunk>();
        renderChunks.Add(getChunk(new Vector2(position.x - chunkSize, position.y)));
        renderChunks.Add(getChunk(position));
        renderChunks.Add(getChunk(new Vector2(position.x + chunkSize, position.y)));
        renderChunks.Add(getChunk(new Vector2(position.x - chunkSize, position.y - chunkSize)));
        renderChunks.Add(getChunk(new Vector2(position.x, position.y - chunkSize)));
        renderChunks.Add(getChunk(new Vector2(position.x + chunkSize, position.y - chunkSize)));
        renderChunks.Add(getChunk(new Vector2(position.x - chunkSize, position.y + chunkSize)));
        renderChunks.Add(getChunk(new Vector2(position.x, position.y + chunkSize)));
        renderChunks.Add(getChunk(new Vector2(position.x + chunkSize, position.y + chunkSize)));
        return renderChunks;
    }

    public Chunk getPreRenderChunk(string direction, Vector2 position)
    {
        Chunk preRenderChunk = null;
        if (direction == "left")
            preRenderChunk = getChunk(new Vector2(position.x - (chunkSize * 2), position.y));

        if (direction == "right")
            preRenderChunk = getChunk(new Vector2(position.x + (chunkSize * 2), position.y));

        if (direction == "up")
            preRenderChunk = getChunk(new Vector2(position.x, position.y + (chunkSize * 2)));

        if (direction == "down")
            preRenderChunk = getChunk(new Vector2(position.x, position.y - (chunkSize * 2)));

        return preRenderChunk;
    }

    public Chunk getChunk(Vector2 position)
    {
        foreach (Chunk chunk in Chunks)
        {
            if (chunk.ChunkRect.Contains(position))
            {
                return chunk;
            }
        }
        return createNewChunk(position);
    }

    public bool AutoDestroyLeft
    {
        get
        {
            return autoDestroyLeft;
        }

        set
        {
            autoDestroyLeft = value;
        }
    }

    public bool AutoDestroyRight
    {
        get
        {
            return autoDestroyRight;
        }

        set
        {
            autoDestroyRight = value;
        }
    }

    public bool AutoDestroyUp
    {
        get
        {
            return autoDestroyUp;
        }

        set
        {
            autoDestroyUp = value;
        }
    }

    public bool AutoDestroyDown
    {
        get
        {
            return autoDestroyDown;
        }

        set
        {
            autoDestroyDown = value;
        }
    }

    public List<Chunk> Chunks
    {
        get
        {
            return chunks;
        }

        set
        {
            chunks = value;
        }
    }
}
