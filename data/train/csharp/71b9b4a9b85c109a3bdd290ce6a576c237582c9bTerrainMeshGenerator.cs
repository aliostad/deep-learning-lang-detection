// ----------------------------------------------------------------------------
// <copyright file="TerrainMeshGenerator.cs" company="Acidwashed Games">
//     Copyright 2012 Acidwashed Games. All right reserved.
// </copyright>
// ----------------------------------------------------------------------------

using System;

/// <summary>
/// Generates meshes for terrain blocks.
/// </summary>
public abstract class TerrainMeshGenerator
{
    #region Constants

    /// <summary>
    /// The default block depth.
    /// </summary>
    public const int DefaultBlockDepth = 2;

    #endregion

    #region Constructor

    /// <summary>
    /// Initializes a new instance of the TerrainMeshGenerator class.
    /// </summary>
    public TerrainMeshGenerator()
    {
        this.BlockDepth = DefaultBlockDepth;
        this.MaterialLookup = new MaterialLookup();
    }

    #endregion

    #region Properties

    /// <summary>
    /// Gets or sets how many blocks should be rendered depth-wise for terrain walls.
    /// </summary>
    public int BlockDepth { get; set; }

    /// <summary>
    /// Gets or sets the material lookup instance.
    /// </summary>
    protected MaterialLookup MaterialLookup { get; set; }

    #endregion

    #region Public Methods

    /// <summary>
    /// Update the terrain's mesh for the given chunk.
    /// </summary>
    /// <param name="terrain">The terrain.</param>
    /// <param name="chunkIndex">The index of the chunk to update the mesh for.</param>
    public virtual void UpdateChunkMesh(Terrain terrain, Vector2I chunkIndex)
    {
        Chunk chunk = terrain.Blocks[chunkIndex];

        // Ensure that the chunk is of the render type
        if ((chunk.Usage & ChunkUsage.Rendering) == 0)
        {
            throw new ApplicationException(string.Format("The chunk {0} does not support rendering.", chunkIndex));
        }

        // Get the neighbouring chunks so that boundary checks can be made. If a neighbour cannot be retrieved, then
        // we may be at the edge of the world, in which case that region shouldn't be accessible so all is ok
        Chunk chunkUp, chunkRight, chunkDown, chunkLeft;
        terrain.Blocks.TryGetChunk(new Vector2I(chunkIndex.X, chunkIndex.Y + 1), out chunkUp);
        terrain.Blocks.TryGetChunk(new Vector2I(chunkIndex.X + 1, chunkIndex.Y), out chunkRight);
        terrain.Blocks.TryGetChunk(new Vector2I(chunkIndex.X, chunkIndex.Y - 1), out chunkDown);
        terrain.Blocks.TryGetChunk(new Vector2I(chunkIndex.X - 1, chunkIndex.Y), out chunkLeft);

        // Update the block meshes
        for (int x = 0; x < Chunk.SizeX; x++)
        {
            for (int y = 0; y < Chunk.SizeY; y++)
            {
                this.UpdateBlockMesh(terrain, x, y, chunk, chunkIndex, chunkUp, chunkRight, chunkDown, chunkLeft);
            }
        }
    }

    /// <summary>
    /// Update the block at the given world position.
    /// </summary>
    /// <param name="terrain">The terrain.</param>
    /// <param name="position">The position in world coordinates.</param>
    /// <param name="updateNeighbours">Indicates whether the neighbours (up/down/left/right) should be updated.</param>
    public void UpdateBlock(Terrain terrain, Vector2I position, bool updateNeighbours)
    {
        Vector2I chunkIndex = TerrainBlocks.GetChunkIndex(position.X, position.Y);
        Chunk chunk = terrain.Blocks[chunkIndex];

        // Ensure that the chunk is of the render type
        if ((chunk.Usage & ChunkUsage.Rendering) == 0)
        {
            throw new ApplicationException(string.Format("The chunk {0} does not support rendering.", chunkIndex));
        }

        // Get the neighbouring chunks so that boundary checks can be made. If a neighbour cannot be retrieved, then
        // we may be at the edge of the world, in which case that region shouldn't be accessible so all is ok
        Vector2I chunkIndexUp = new Vector2I(chunkIndex.X, chunkIndex.Y + 1);
        Vector2I chunkIndexRight = new Vector2I(chunkIndex.X + 1, chunkIndex.Y);
        Vector2I chunkIndexDown = new Vector2I(chunkIndex.X, chunkIndex.Y - 1);
        Vector2I chunkIndexLeft = new Vector2I(chunkIndex.X - 1, chunkIndex.Y);
        Chunk chunkUp, chunkRight, chunkDown, chunkLeft;
        terrain.Blocks.TryGetChunk(chunkIndexUp, out chunkUp);
        terrain.Blocks.TryGetChunk(chunkIndexRight, out chunkRight);
        terrain.Blocks.TryGetChunk(chunkIndexDown, out chunkDown);
        terrain.Blocks.TryGetChunk(chunkIndexLeft, out chunkLeft);

        // Get the position in chunk coordiantes
        int chunkX = position.X & Chunk.MaskX;
        int chunkY = position.Y & Chunk.MaskY;

        // Update the block
        this.UpdateBlockMesh(terrain, chunkX, chunkY, chunk, chunkIndex, chunkUp, chunkRight, chunkDown, chunkLeft);

        if (updateNeighbours)
        {
            // Update the block above this one
            if (chunkY != Chunk.SizeY - 1)
            {
                this.UpdateBlockMesh(
                    terrain, chunkX, chunkY + 1, chunk, chunkIndex, chunkUp, chunkRight, chunkDown, chunkLeft);
            }
            else if (chunkUp != null)
            {
                this.UpdateBlockMesh(
                    terrain, chunkX, 0, chunkUp, chunkIndexUp, null, chunkRight, chunk, chunkLeft);
            }

            // Update the block to the right of this one
            if (chunkX != Chunk.SizeX - 1)
            {
                this.UpdateBlockMesh(
                    terrain, chunkX + 1, chunkY, chunk, chunkIndex, chunkUp, chunkRight, chunkDown, chunkLeft);
            }
            else if (chunkRight != null)
            {
                this.UpdateBlockMesh(
                       terrain, 0, chunkY, chunkRight, chunkIndexRight, chunkUp, null, chunkDown, chunk);
            }

            // Update the block below this one
            if (chunkY != 0)
            {
                this.UpdateBlockMesh(
                    terrain, chunkX, chunkY - 1, chunk, chunkIndex, chunkUp, chunkRight, chunkDown, chunkLeft);
            }
            else if (chunkDown != null)
            {
                this.UpdateBlockMesh(
                    terrain, chunkX, Chunk.SizeY - 1, chunkDown, chunkIndexDown, chunk, chunkRight, null, chunkLeft);
            }

            // Update the block to the left of this one
            if (chunkX != 0)
            {
                this.UpdateBlockMesh(
                    terrain, chunkX - 1, chunkY, chunk, chunkIndex, chunkUp, chunkRight, chunkDown, chunkLeft);
            }
            else if (chunkLeft != null)
            {
                this.UpdateBlockMesh(
                   terrain, Chunk.SizeX - 1, chunkY, chunkLeft, chunkIndexLeft, chunkUp, chunk, chunkDown, null);
            }
        }
    }

    /// <summary>
    /// Remove the terrain's mesh for the given chunk. This will not generate walls for bordering chunks that are cut
    /// off, as this method is to be used for cleanup/housekeeping purposes.
    /// </summary>
    /// <param name="terrain">The terrain.</param>
    /// <param name="chunkIndex">The index of the chunk to remove the mesh for.</param>
    public virtual void RemoveChunkMesh(Terrain terrain, Vector2I chunkIndex)
    {
        // Get the origin of the chunk in world coordinates
        Vector2I chunkOrigin = new Vector2I(chunkIndex.X * Chunk.SizeX, chunkIndex.Y * Chunk.SizeY);

        // Remove all blocks for the chunk from the mesh
        for (int x = chunkOrigin.X; x < chunkOrigin.X + Chunk.SizeX; x++)
        {
            for (int y = chunkOrigin.Y; y < chunkOrigin.Y + Chunk.SizeY; y++)
            {
                terrain.Mesh.RemoveMesh(new Vector2I(x, y));
            }
        }
    }

    #endregion

    #region Protected Methods

    /// <summary>
    /// Update the block mesh in regards to its neighbours.
    /// </summary>
    /// <param name="terrain">The terrain.</param>
    /// <param name="chunkX">The x position in chunk coordinates.</param>
    /// <param name="chunkY">The y position in chunk coordinates.</param>
    /// <param name="chunk">The chunk.</param>
    /// <param name="chunkIndex">The index of the chunk.</param>
    /// <param name="chunkUp">The chunk above.</param>
    /// <param name="chunkRight">The chunk to the right.</param>
    /// <param name="chunkDown">The chunk below.</param>
    /// <param name="chunkLeft">The chunk to the left.</param>
    protected virtual void UpdateBlockMesh(
        Terrain terrain,
        int chunkX,
        int chunkY,
        Chunk chunk,
        Vector2I chunkIndex,
        Chunk chunkUp,
        Chunk chunkRight,
        Chunk chunkDown,
        Chunk chunkLeft)
    {
        // Get the block index
        int index = Chunk.GetBlockIndex(chunkX, chunkY);

        // Get the block
        Block block = chunk[index];

        // Calculate the block position in world coordinates
        var blockPos = new Vector2I((chunkIndex.X * Chunk.SizeX) + chunkX, (chunkIndex.Y * Chunk.SizeY) + chunkY);

        // If there is no block here, remove any mesh that may exist at this position and continue
        if (block.BlockType == BlockType.None)
        {
            terrain.Mesh.RemoveMesh(blockPos);
            return;
        }

        // Get the block above this one
        Block blockUp;
        if (chunkY != Chunk.SizeY - 1)
        {
            blockUp = chunk[chunkX, chunkY + 1];
        }
        else if (chunkUp != null)
        {
            blockUp = chunkUp[chunkX, 0];
        }
        else
        {
            blockUp = Block.None;
        }

        // Get the block to the right of this one
        Block blockRight;
        if (chunkX != Chunk.SizeX - 1)
        {
            blockRight = chunk[chunkX + 1, chunkY];
        }
        else if (chunkRight != null)
        {
            blockRight = chunkRight[0, chunkY];
        }
        else
        {
            blockRight = Block.None;
        }

        // Get the block below this one
        Block blockDown;
        if (chunkY != 0)
        {
            blockDown = chunk[chunkX, chunkY - 1];
        }
        else if (chunkDown != null)
        {
            blockDown = chunkDown[chunkX, Chunk.SizeY - 1];
        }
        else
        {
            blockDown = Block.None;
        }

        // Get the block to the left of this one
        Block blockLeft;
        if (chunkX != 0)
        {
            blockLeft = chunk[chunkX - 1, chunkY];
        }
        else if (chunkLeft != null)
        {
            blockLeft = chunkLeft[Chunk.SizeX - 1, chunkY];
        }
        else
        {
            blockLeft = Block.None;
        }

        // Create the mesh for this block
        BlockMesh mesh = this.CreateBlockMesh(block, blockPos, blockUp, blockRight, blockDown, blockLeft);

        // Add the mesh to the cloud
        terrain.Mesh.SetMesh(blockPos, mesh);
    }

    /// <summary>
    /// Create a mesh for the given block.
    /// </summary>
    /// <param name="block">The block to create the mesh for.</param>
    /// <param name="position">The position of the block.</param>
    /// <param name="blockUp">The block above.</param>
    /// <param name="blockRight">The block to the right.</param>
    /// <param name="blockDown">The block below.</param>
    /// <param name="blockLeft">The block to the left.</param>
    /// <returns>The mesh data for the block.</returns>
    protected abstract BlockMesh CreateBlockMesh(
        Block block,
        Vector2I position,
        Block blockUp,
        Block blockRight,
        Block blockDown,
        Block blockLeft);

    #endregion
}