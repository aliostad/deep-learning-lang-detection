using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework;

using NewTake.model;
using NewTake.view.blocks;
using System.Diagnostics;

namespace NewTake.view
{

    //this is the same code as in boundariesChunkRenderer. 
   
    class SolidBoundsChunkRenderer : ChunkRenderer
    {

        public SolidBoundsChunkRenderer(GraphicsDevice graphicsDevice, World world, Chunk chunk) : base(graphicsDevice, world, chunk) { }

        #region BuildVertexList
        public override void BuildVertexList()
        {
            //Debug.WriteLine("building vertexlist ...");
            _vertexList.Clear();

            //lowestSolidBlock and highestSolidBlock come from the terrain gen (Eventually, if the terraingen did not set them you gain nothing)
            //and digging is handled correctly too 
           
            byte yLow = (byte)(chunk.lowestNoneBlock.Y == 0 ? 0 : chunk.lowestNoneBlock.Y - 1);
            byte yHigh = (byte)(chunk.highestSolidBlock.Y == Chunk.CHUNK_YMAX - 1 ? Chunk.CHUNK_YMAX - 1 : chunk.highestSolidBlock.Y + 1);
            
            //Debug.WriteLine("{0} - {1}",yLow,yHigh);
            
            //byte yLow = 0;
            //byte yHigh =  Chunk.CHUNK_YMAX-1 ;
            
            for (byte y = yLow; y < yHigh; y++)
            {
                for (byte x = 0; x < Chunk.CHUNK_XMAX; x++)
                {
                    for (byte z = 0; z < Chunk.CHUNK_ZMAX; z++)
                    {
                        Block block = chunk.Blocks[x, y, z];
                        if (block.Type != BlockType.None)
                        {
                            BuildBlockVertices(ref _vertexList, block, chunk, new Vector3i(x, y, z));
                        }
                        else
                        {
                            //If we're an empty block on a boundary
                            if (x == 0)
                            {
                                Chunk neighbouringChunk = world.viewableChunks[chunk.Index.X - 1, chunk.Index.Z];
                                if (neighbouringChunk != null)
                                {
                                    // If we have a loaded neigbouring chunk
                                    Block neighbouringBlock = neighbouringChunk.Blocks[Chunk.CHUNK_XMAX - 1, y, z];
                                    if (neighbouringBlock.Solid)
                                    {
                                        // And a solid neighbouring block 
                                        // Then render it's adjacent face as if it was part of this chunk
                                        blocksRenderer.BuildFaceVertices(ref _vertexList, neighbouringChunk.Position + new Vector3i(Chunk.CHUNK_XMAX - 1, y, z), BlockFaceDirection.XIncreasing, neighbouringBlock.Type);
                                    }
                                }
                            }
                            else if (x == Chunk.CHUNK_XMAX - 1)
                            {
                                Chunk neighbouringChunk = world.viewableChunks[chunk.Index.X + 1, chunk.Index.Z];
                                if (neighbouringChunk != null)
                                {
                                    // If we have a loaded neigbouring chunk
                                    Block neighbouringBlock = neighbouringChunk.Blocks[0, y, z];
                                    if (neighbouringBlock.Solid)
                                    {
                                        // And a solid neighbouring block 
                                        // Then render it's adjacent face as if it was part of this chunk
                                        blocksRenderer.BuildFaceVertices(ref _vertexList, neighbouringChunk.Position + new Vector3i(0, y, z), BlockFaceDirection.XDecreasing, neighbouringBlock.Type);
                                    }
                                }
                            }
                            if (y == 0)
                            {
                                //TODO Y infinity BuildVertexList
                            }
                            else if (y == Chunk.CHUNK_YMAX - 1)
                            {
                            }
                            if (z == 0)
                            {
                                Chunk neighbouringChunk = world.viewableChunks[chunk.Index.X, chunk.Index.Z - 1];
                                if (neighbouringChunk != null)
                                {
                                    // If we have a loaded neigbouring chunk
                                    Block neighbouringBlock = neighbouringChunk.Blocks[x, y, Chunk.CHUNK_ZMAX - 1];
                                    if (neighbouringBlock.Solid)
                                    {
                                        // And a solid neighbouring block 
                                        // Then render it's adjacent face as if it was part of this chunk
                                        blocksRenderer.BuildFaceVertices(ref _vertexList, neighbouringChunk.Position + new Vector3i(x, y, Chunk.CHUNK_ZMAX - 1), BlockFaceDirection.ZIncreasing, neighbouringBlock.Type);
                                    }
                                }
                            }
                            else if (z == Chunk.CHUNK_ZMAX - 1)
                            {
                                Chunk neighbouringChunk = world.viewableChunks[chunk.Index.X, chunk.Index.Z + 1];
                                if (neighbouringChunk != null)
                                {
                                    // If we have a loaded neigbouring chunk
                                    Block neighbouringBlock = neighbouringChunk.Blocks[x, y, 0];
                                    if (neighbouringBlock.Solid)
                                    {
                                        // And a solid neighbouring block 
                                        // Then render it's adjacent face as if it was part of this chunk
                                        blocksRenderer.BuildFaceVertices(ref _vertexList, neighbouringChunk.Position + new Vector3i(x, y, 0), BlockFaceDirection.ZDecreasing, neighbouringBlock.Type);
                                    }
                                }
                            }
                        }
                    }
                }
            }

            chunk.dirty = false;

            VertexPositionTextureShade[] a = _vertexList.ToArray();

            if (a.Length != 0)
            {

                vertexBuffer = new VertexBuffer(graphicsDevice, typeof(VertexPositionTextureShade), a.Length, BufferUsage.WriteOnly);
                vertexBuffer.SetData(a);

                //Debug.WriteLine("............building Vertexlist done");
            }
        }
        #endregion

        #region BuildBlockVertices
        public void BuildBlockVertices(ref List<VertexPositionTextureShade> vertexList, Block block, Chunk chunk, Vector3i chunkRelativePosition)
        {
            //optimized by using chunk.Blocks[][][] except for "out of current chunk" blocks

            Vector3i blockPosition = chunk.Position + chunkRelativePosition;

            Block blockXDecreasing, blockXIncreasing, blockYDecreasing, blockYIncreasing, blockZDecreasing, blockZIncreasing;

            Block solidBlock = new Block(BlockType.Rock, false);

            // X Boundary
            if (chunkRelativePosition.X == 0)
            {
                Chunk neighbouringChunk = world.viewableChunks[chunk.Index.X - 1, chunk.Index.Z];
                if (neighbouringChunk == null)
                {
                    blockXDecreasing = solidBlock;
                }
                else
                {
                    blockXDecreasing = neighbouringChunk.Blocks[Chunk.CHUNK_XMAX - 1, chunkRelativePosition.Y, chunkRelativePosition.Z];
                }

            }
            else
            {
                blockXDecreasing = chunk.Blocks[chunkRelativePosition.X - 1, chunkRelativePosition.Y, chunkRelativePosition.Z];
            }
            if (chunkRelativePosition.X == Chunk.SIZE.X - 1)
            {
                Chunk neighbouringChunk = world.viewableChunks[chunk.Index.X + 1, chunk.Index.Z];
                if (neighbouringChunk == null)
                {
                    blockXIncreasing = solidBlock;
                }
                else
                {
                    blockXIncreasing = neighbouringChunk.Blocks[0, chunkRelativePosition.Y, chunkRelativePosition.Z];
                }
            }
            else
            {
                blockXIncreasing = chunk.Blocks[chunkRelativePosition.X + 1, chunkRelativePosition.Y, chunkRelativePosition.Z];
            }

            // Y Boundary
            if (chunkRelativePosition.Y == 0)
            {
                blockYDecreasing = solidBlock;
            }
            else
            {
                blockYDecreasing = chunk.Blocks[chunkRelativePosition.X, chunkRelativePosition.Y - 1, chunkRelativePosition.Z];
            }
            if (chunkRelativePosition.Y == Chunk.SIZE.Y - 1)
            {
                blockYIncreasing = solidBlock;
            }
            else
            {
                blockYIncreasing = chunk.Blocks[chunkRelativePosition.X, chunkRelativePosition.Y + 1, chunkRelativePosition.Z];
            }

            // Z Boundary
            if (chunkRelativePosition.Z == 0)
            {
                Chunk neighbouringChunk = world.viewableChunks[chunk.Index.X, chunk.Index.Z - 1];
                if (neighbouringChunk == null)
                {
                    blockZDecreasing = solidBlock;
                }
                else
                {
                    blockZDecreasing = neighbouringChunk.Blocks[chunkRelativePosition.X, chunkRelativePosition.Y, Chunk.CHUNK_ZMAX - 1];
                }
            }
            else
            {
                blockZDecreasing = chunk.Blocks[chunkRelativePosition.X, chunkRelativePosition.Y, chunkRelativePosition.Z - 1];
            }
            if (chunkRelativePosition.Z == Chunk.SIZE.Z - 1)
            {
                Chunk neighbouringChunk = world.viewableChunks[chunk.Index.X, chunk.Index.Z + 1];
                if (neighbouringChunk == null)
                {
                    blockZIncreasing = solidBlock;
                }
                else
                {
                    blockZIncreasing = neighbouringChunk.Blocks[chunkRelativePosition.X, chunkRelativePosition.Y, 0];
                }
            }
            else
            {
                blockZIncreasing = chunk.Blocks[chunkRelativePosition.X, chunkRelativePosition.Y, chunkRelativePosition.Z + 1];
            }



            if (!blockXDecreasing.Solid) blocksRenderer.BuildFaceVertices(ref vertexList, blockPosition, BlockFaceDirection.XDecreasing, block.Type);
            if (!blockXIncreasing.Solid) blocksRenderer.BuildFaceVertices(ref vertexList, blockPosition, BlockFaceDirection.XIncreasing, block.Type);

            if (!blockYDecreasing.Solid) blocksRenderer.BuildFaceVertices(ref vertexList, blockPosition, BlockFaceDirection.YDecreasing, block.Type);
            if (!blockYIncreasing.Solid) blocksRenderer.BuildFaceVertices(ref vertexList, blockPosition, BlockFaceDirection.YIncreasing, block.Type);

            if (!blockZDecreasing.Solid) blocksRenderer.BuildFaceVertices(ref vertexList, blockPosition, BlockFaceDirection.ZDecreasing, block.Type);
            if (!blockZIncreasing.Solid) blocksRenderer.BuildFaceVertices(ref vertexList, blockPosition, BlockFaceDirection.ZIncreasing, block.Type);
        }
        #endregion

    }
}
