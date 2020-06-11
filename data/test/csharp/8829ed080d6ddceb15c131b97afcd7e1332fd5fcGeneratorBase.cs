using UnityEngine;
using System.Collections;

public class GeneratorBase {

	public World world;
	public Chunk chunk;

    public void Generate(World world, Chunk chunk) {
		this.world = world;
		this.chunk = chunk;
        for (int x = chunk.cPosition.x; x < chunk.cPosition.x + Chunk.cWidth; x++)
        {
            for (int z = chunk.cPosition.z; z < chunk.cPosition.z + Chunk.cWidth; z++)
            {
                GenerateColumn(x,z);
            }
        }
        chunk.cGenerated = true;
    }

	public virtual void GenerateColumn(int x, int z) {
	}
}
