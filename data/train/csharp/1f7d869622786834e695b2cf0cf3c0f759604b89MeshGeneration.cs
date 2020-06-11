using UnityEngine;
using System.Collections;

public static class MeshGeneration
{


    public static Queue q = new Queue(32);

    public static void AddToQueue(ChunkDrawDataArray chunkDrawData)
    {
        //lock (q)
        //{
            q.Enqueue(chunkDrawData);
        //}
    }

    public static ChunkDrawDataArray GetFromQueue()
    {
        ChunkDrawDataArray chunkdrawdata;

        //lock (q)
        //{
            if (q.Count > 0)
            {
                chunkdrawdata = (ChunkDrawDataArray)q.Dequeue();
            }
            else
            {
                chunkdrawdata = null;
            }
        //}

        return chunkdrawdata;
    }

    public static Queue qRemoveChunk = new Queue(32);
    public static void AddToRemoveQueue(Chunk chunk)
    {
        //Debug.Log("ses");
        //lock (qRemoveChunk)
        //{
        qRemoveChunk.Enqueue(chunk);
        //}
    }

    public static Chunk GetFromRemoveQueue()
    {
        Chunk chunk;

        //lock (qRemoveChunk)
       // {
            if (qRemoveChunk.Count > 0)
            {
                chunk = (Chunk)qRemoveChunk.Dequeue();
            }
            else
            {
                chunk = null;
            }
        //}
        return chunk;
    }
}