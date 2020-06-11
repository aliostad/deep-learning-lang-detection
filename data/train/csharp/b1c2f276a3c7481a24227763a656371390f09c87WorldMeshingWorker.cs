public class WorldMeshingWorker : WorkerThread<Chunk>
{
    public static WorldMeshingWorker instance;
    static WorldMeshingWorker()
    {
        instance = new WorldMeshingWorker();
    }

    protected override void Process(Chunk chunk)
    {
        ProceduralMesh mesh = new ProceduralMesh();
        for (int i = 0; i < Chunk.CHUNK_SIZE; i++)
        {
            for (int j = 0; j < Chunk.CHUNK_SIZE; j++)
            {
                for (int k = 0; k < Chunk.CHUNK_SIZE; k++)
                {
                    mesh = chunk.GetVoxel(i, j, k).AppendBlockMesh(chunk, i, j, k, mesh);
                }
            }
        }
        chunk.mesh = mesh;
    }
}
