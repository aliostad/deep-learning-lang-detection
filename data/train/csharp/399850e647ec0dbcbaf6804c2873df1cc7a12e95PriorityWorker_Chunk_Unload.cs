using UnityEngine;

public class PriorityWorker_Chunk_Unload : PriorityWorker
{
    public static int PRIORITY = 2;

    public Chunk Chunk;

    public delegate void AfterDespawnCallback(Chunk chunk);
    public event AfterDespawnCallback CallBack;

    public static void Create(Chunk chunk, AfterDespawnCallback callBack)
    {
        PriorityWorker_Chunk_Unload worker = new PriorityWorker_Chunk_Unload();
        worker.Chunk = chunk;
        worker.CallBack += callBack;
        PriorityWorkerQueue.AddWorker(PRIORITY, worker);
    }

    public override void Work()
    {
        Chunk.Unload();
        if (CallBack != null) CallBack(Chunk);
    }
}
