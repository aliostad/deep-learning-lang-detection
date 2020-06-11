using UnityEngine;

public class PriorityWorker_Chunk_Load : PriorityWorker
{
    public static int PRIORITY = 2;

    public Chunk Chunk;

    public delegate void AfterDespawnCallback(Chunk chunk);
    public event AfterDespawnCallback CallBack;

    public static void Create(Chunk chunk, AfterDespawnCallback callBack)
    {
        PriorityWorker_Chunk_Load worker = new PriorityWorker_Chunk_Load();
        worker.Chunk = chunk;
        worker.CallBack += callBack;
        PriorityWorkerQueue.AddWorker(PRIORITY, worker);
    }

    public override void Work()
    {
        Chunk.Load();
        if (CallBack != null) CallBack(Chunk);
    }
}
