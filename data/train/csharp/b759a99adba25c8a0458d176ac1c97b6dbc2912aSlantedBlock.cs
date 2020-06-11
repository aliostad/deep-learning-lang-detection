using UnityEngine;
using System.Collections;

public abstract class SlantedBlock : IBlock {

    public abstract byte BlockID { get; }

    /// <summary>
    /// Top UV returns the null texture by default. To return a different texture overload this method
    /// and return the UV vector that you wish to display. By default every other face is setup to return
    /// the top UV unless overloaded.
    /// </summary>
    public virtual Vector2 TopUV { get { return BlockDetails.nullUV; } }
    /// <summary>
    /// Return the Top UV by default unless overloaded
    /// </summary>
    public virtual Vector2 NorthUV { get { return TopUV; } }
    /// <summary>
    /// Return the Top UV by default unless overloaded
    /// </summary>
    public virtual Vector2 SouthUV { get { return TopUV; } }
    /// <summary>
    /// Return the Top UV by default unless overloaded
    /// </summary>

    public virtual Vector2 WestUV { get { return TopUV; } }
    /// <summary>
    /// Return the Top UV by default unless overloaded
    /// </summary>

    public virtual Vector2 EastUV { get { return TopUV; } }
    /// <summary>
    /// Return the Top UV by default unless overloaded
    /// </summary>

    public virtual Vector2 BottomUV { get { return TopUV; } }

    public bool IsOpaque
    {
        get { return true; }
    }

    public void ConstructBlock(int x, int y, int z, Chunk chunk)
    {
        // If the block is not air
        if (BlockID != null)
        {
            if (chunk.world.GetBlockWorldCoordinate(chunk.ChunkPosition + new IntVector3(x, y + 1, z)) == null)
            {
                //Block above is air
                CreateTopFace(x, y, z, chunk);
            }

            if (chunk.world.GetBlockWorldCoordinate(chunk.ChunkPosition + new IntVector3(x, y - 1, z)) == null)
            {
                //Block below is air
                CreateBottomFace(x, y, z, chunk);

            }

            if (chunk.world.GetBlockWorldCoordinate(chunk.ChunkPosition + new IntVector3(x + 1, y, z)) == null)
            {
                //Block east is air
                CreateEastFace(x, y, z, chunk);

            }


            if (chunk.world.GetBlockWorldCoordinate(chunk.ChunkPosition + new IntVector3(x - 1, y, z)) == null)
            {
                //Block west is air
                CreateWestFace(x, y, z, chunk);

            }

            if (chunk.world.GetBlockWorldCoordinate(chunk.ChunkPosition + new IntVector3(x, y, z + 1)) == null)
            {
                //Block north is air
                CreateNorthFace(x, y, z, chunk);

            }

            if (chunk.world.GetBlockWorldCoordinate(chunk.ChunkPosition + new IntVector3(x, y, z - 1)) == null)
            {
                //Block south is air
                CreateSouthFace(x, y, z, chunk);

            }
        }
    }
    protected void CreateTopFace(int x, int y, int z, Chunk chunk)
    {
        chunk.meshVertices.Add(new Vector3(x, y - 1, z + 1));
        chunk.meshVertices.Add(new Vector3(x + 1, y, z + 1));
        chunk.meshVertices.Add(new Vector3(x + 1, y, z));
        chunk.meshVertices.Add(new Vector3(x, y - 1, z));

        chunk.colVertices.Add(new Vector3(x, y - 1, z + 1));
        chunk.colVertices.Add(new Vector3(x + 1, y, z + 1));
        chunk.colVertices.Add(new Vector3(x + 1, y, z));
        chunk.colVertices.Add(new Vector3(x, y - 1, z));

        AddMeshTriangles(chunk);
        AddCollisionTriangles(chunk);
        AddUV(TopUV, chunk);
    }
    protected void CreateBottomFace(int x, int y, int z, Chunk chunk)
    {
        chunk.meshVertices.Add(new Vector3(x, y - 1, z));
        chunk.meshVertices.Add(new Vector3(x + 1, y - 1, z));
        chunk.meshVertices.Add(new Vector3(x + 1, y - 1, z + 1));
        chunk.meshVertices.Add(new Vector3(x, y - 1, z + 1));

        chunk.colVertices.Add(new Vector3(x, y - 1, z));
        chunk.colVertices.Add(new Vector3(x + 1, y - 1, z));
        chunk.colVertices.Add(new Vector3(x + 1, y - 1, z + 1));
        chunk.colVertices.Add(new Vector3(x, y - 1, z + 1));

        AddMeshTriangles(chunk);
        AddCollisionTriangles(chunk);
        AddUV(BottomUV, chunk);

    }
    protected void CreateNorthFace(int x, int y, int z, Chunk chunk)
    {
        chunk.meshVertices.Add(new Vector3(x + 1, y - 1, z + 1));
        chunk.meshVertices.Add(new Vector3(x + 1, y, z + 1));
        chunk.meshVertices.Add(new Vector3(x, y - 1, z + 1));
        chunk.meshVertices.Add(new Vector3(x, y - 1, z + 1));

        chunk.colVertices.Add(new Vector3(x + 1, y - 1, z + 1));
        chunk.colVertices.Add(new Vector3(x + 1, y, z + 1));
        chunk.colVertices.Add(new Vector3(x, y - 1, z + 1));
        chunk.colVertices.Add(new Vector3(x, y - 1, z + 1));

        AddMeshTriangles(chunk);
        AddCollisionTriangles(chunk);
        AddUV(NorthUV, chunk);

    }
    protected void CreateSouthFace(int x, int y, int z, Chunk chunk)
    {
        chunk.meshVertices.Add(new Vector3(x, y - 1, z));
        chunk.meshVertices.Add(new Vector3(x, y - 1, z));
        chunk.meshVertices.Add(new Vector3(x + 1, y, z));
        chunk.meshVertices.Add(new Vector3(x + 1, y - 1, z));

        chunk.colVertices.Add(new Vector3(x, y - 1, z));
        chunk.colVertices.Add(new Vector3(x, y - 1, z));
        chunk.colVertices.Add(new Vector3(x + 1, y, z));
        chunk.colVertices.Add(new Vector3(x + 1, y - 1, z));

        AddMeshTriangles(chunk);
        AddCollisionTriangles(chunk);
        AddUV(SouthUV, chunk);

    }
    protected void CreateWestFace(int x, int y, int z, Chunk chunk)
    {
        chunk.meshVertices.Add(new Vector3(x, y - 1, z + 1));
        chunk.meshVertices.Add(new Vector3(x, y - 1, z + 1));
        chunk.meshVertices.Add(new Vector3(x, y - 1, z));
        chunk.meshVertices.Add(new Vector3(x, y - 1, z));

        chunk.colVertices.Add(new Vector3(x, y - 1, z + 1));
        chunk.colVertices.Add(new Vector3(x, y - 1, z + 1));
        chunk.colVertices.Add(new Vector3(x, y - 1, z));
        chunk.colVertices.Add(new Vector3(x, y - 1, z));

        AddMeshTriangles(chunk);
        AddCollisionTriangles(chunk);
        AddUV(WestUV, chunk);

    }
    protected void CreateEastFace(int x, int y, int z, Chunk chunk)
    {
        chunk.meshVertices.Add(new Vector3(x + 1, y - 1, z));
        chunk.meshVertices.Add(new Vector3(x + 1, y, z));
        chunk.meshVertices.Add(new Vector3(x + 1, y, z + 1));
        chunk.meshVertices.Add(new Vector3(x + 1, y - 1, z + 1));

        chunk.colVertices.Add(new Vector3(x + 1, y - 1, z));
        chunk.colVertices.Add(new Vector3(x + 1, y, z));
        chunk.colVertices.Add(new Vector3(x + 1, y, z + 1));
        chunk.colVertices.Add(new Vector3(x + 1, y - 1, z + 1));

        AddMeshTriangles(chunk);
        AddCollisionTriangles(chunk);
        AddUV(EastUV, chunk);
    }

    protected void AddMeshTriangles(Chunk chunk)
    {
        chunk.meshTriangles.Add(chunk.meshFaceCount * 4);
        chunk.meshTriangles.Add(chunk.meshFaceCount * 4 + 1);
        chunk.meshTriangles.Add(chunk.meshFaceCount * 4 + 2);
        chunk.meshTriangles.Add(chunk.meshFaceCount * 4);
        chunk.meshTriangles.Add(chunk.meshFaceCount * 4 + 2);
        chunk.meshTriangles.Add(chunk.meshFaceCount * 4 + 3);
        chunk.meshFaceCount++;
    }

    protected void AddCollisionTriangles(Chunk chunk)
    {
        chunk.colTriangles.Add(chunk.collisionFaceCount * 4);
        chunk.colTriangles.Add(chunk.collisionFaceCount * 4 + 1);
        chunk.colTriangles.Add(chunk.collisionFaceCount * 4 + 2);
        chunk.colTriangles.Add(chunk.collisionFaceCount * 4);
        chunk.colTriangles.Add(chunk.collisionFaceCount * 4 + 2);
        chunk.colTriangles.Add(chunk.collisionFaceCount * 4 + 3);
        chunk.collisionFaceCount++;
    }

    protected void AddUV(Vector2 texturePos, Chunk chunk)
    {
        chunk.uvMap.Add(new Vector2(BlockDetails.tUnit * texturePos.x + BlockDetails.tUnit, BlockDetails.tUnit * texturePos.y));
        chunk.uvMap.Add(new Vector2(BlockDetails.tUnit * texturePos.x + BlockDetails.tUnit, BlockDetails.tUnit * texturePos.y + BlockDetails.tUnit));
        chunk.uvMap.Add(new Vector2(BlockDetails.tUnit * texturePos.x, BlockDetails.tUnit * texturePos.y + BlockDetails.tUnit));
        chunk.uvMap.Add(new Vector2(BlockDetails.tUnit * texturePos.x, BlockDetails.tUnit * texturePos.y));
    }


    public void BlockDestroyed(Chunk chunk)
    {
    //    throw new System.NotImplementedException();
    }


    public void BlockPlaced(Chunk chunk)
    {
    //    throw new System.NotImplementedException();
    }
}
