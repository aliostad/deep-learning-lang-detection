using System;
using System.Diagnostics;
using System.Diagnostics.Contracts;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Xu.Core;
using Xu.Types;

namespace Xu.Genres.VoxelBased
{
	[DebuggerDisplay("Chunk ({Position.X}, {Position.Y}, {Position.Z})")]
	public class Chunk : IDisposable
	{
		public const int ChunkSizeX = 32;
		public const int ChunkSizeY = 32;
		public const int ChunkSizeZ = 32;

		public readonly BoundingBox BoundingBox;
		public readonly Vector3 Center;
		public Block[] Blocks;

		private Chunk _leftChunk;
		private Chunk _downChunk;
		private Chunk _forwardChunk;
		private Chunk _rightChunk;
		private Chunk _upChunk;
		private Chunk _backwardChunk;

		private ChunkState _state;

		public Chunk(IntVector3 position)
		{
			Position = position;

			Center.X = Position.X * ChunkSizeX + ChunkSizeX / 2;
			Center.Y = Position.Y * ChunkSizeY + ChunkSizeY / 2;
			Center.Z = Position.Z * ChunkSizeZ + ChunkSizeZ / 2;

			BoundingBox.Min.X = Position.X * ChunkSizeX;
			BoundingBox.Min.Y = Position.Y * ChunkSizeY;
			BoundingBox.Min.Z = Position.Z * ChunkSizeZ;
			BoundingBox.Max.X = (Position.X + 1) * ChunkSizeX;
			BoundingBox.Max.Y = (Position.Y + 1) * ChunkSizeY;
			BoundingBox.Max.Z = (Position.Z + 1) * ChunkSizeZ;

			State = ChunkState.New;
		}

		public IntVector3 Position { get; private set; }

		public ChunkState State
		{
			get { return _state; }
			set { _state = value; }
		}

		public bool HasAllNeighbors
		{
			get { return _leftChunk != null && _rightChunk != null && _downChunk != null && _upChunk != null && _forwardChunk != null && _backwardChunk != null; }
		}

		public VertexBuffer VertexBuffer { get; set; }
		public IndexBuffer IndexBuffer { get; set; }
		public bool HasGraphicsData { get; set; }

		#region IDisposable Members

		public void Dispose()
		{
			DisposeBuffers();
		}

		#endregion

		public static void TranslateWorldToChunkCoord(IntVector3 worldCoordinate, out IntVector3 chunkCoordinate)
		{
			chunkCoordinate.X = worldCoordinate.X >= 0 ? worldCoordinate.X / ChunkSizeX : (worldCoordinate.X + 1) / ChunkSizeX - 1;
			chunkCoordinate.Y = worldCoordinate.Y >= 0 ? worldCoordinate.Y / ChunkSizeY : (worldCoordinate.Y + 1) / ChunkSizeY - 1;
			chunkCoordinate.Z = worldCoordinate.Z >= 0 ? worldCoordinate.Z / ChunkSizeZ : (worldCoordinate.Z + 1) / ChunkSizeZ - 1;
		}

		public static void TranslateWorldToChunkBlockCoord(IntVector3 worldCoordinate, out IntVector3 chunkCoordinate, out IntVector3 blockCoordinate)
		{
			chunkCoordinate.X = worldCoordinate.X >= 0 ? worldCoordinate.X / ChunkSizeX : (worldCoordinate.X + 1) / ChunkSizeX - 1;
			chunkCoordinate.Y = worldCoordinate.Y >= 0 ? worldCoordinate.Y / ChunkSizeY : (worldCoordinate.Y + 1) / ChunkSizeY - 1;
			chunkCoordinate.Z = worldCoordinate.Z >= 0 ? worldCoordinate.Z / ChunkSizeZ : (worldCoordinate.Z + 1) / ChunkSizeZ - 1;
			blockCoordinate.X = XuMath.Modulo(worldCoordinate.X, ChunkSizeX);
			blockCoordinate.Y = XuMath.Modulo(worldCoordinate.Y, ChunkSizeY);
			blockCoordinate.Z = XuMath.Modulo(worldCoordinate.Z, ChunkSizeZ);
		}

		public void DisposeBuffers()
		{
			if (VertexBuffer != null)
			{
				VertexBuffer.Dispose();
				VertexBuffer = null;
			}

			if (IndexBuffer != null)
			{
				IndexBuffer.Dispose();
				IndexBuffer = null;
			}

			HasGraphicsData = false;
		}

		public static Block[] AllocateBlocks()
		{
			return new Block[ChunkSizeX * ChunkSizeY * ChunkSizeZ];
		}

		public void Connect(Chunk neighbor)
		{
			Contract.Requires(Blocks != null);
			Contract.EndContractBlock();

			if (HasAllNeighbors)
			{
				return;
			}

			IntVector3 delta = neighbor.Position - Position;

			if (delta.X == -1)
			{
				if (neighbor.Blocks != null && _leftChunk == null)
				{
					_leftChunk = neighbor;
				}
				if (neighbor._rightChunk == null)
				{
					neighbor._rightChunk = this;
				}
			}
			else if (delta.X == 1)
			{
				if (neighbor.Blocks != null && _rightChunk == null)
				{
					_rightChunk = neighbor;
				}
				if (neighbor._leftChunk == null)
				{
					neighbor._leftChunk = this;
				}
			}

			else if (delta.Y == -1)
			{
				if (neighbor.Blocks != null && _downChunk == null)
				{
					_downChunk = neighbor;
				}
				if (neighbor._upChunk == null)
				{
					neighbor._upChunk = this;
				}
			}
			else if (delta.Y == 1)
			{
				if (neighbor.Blocks != null && _upChunk == null)
				{
					_upChunk = neighbor;
				}
				if (neighbor._downChunk == null)
				{
					neighbor._downChunk = this;
				}
			}

			else if (delta.Z == -1)
			{
				if (neighbor.Blocks != null && _forwardChunk == null)
				{
					_forwardChunk = neighbor;
				}
				if (neighbor._backwardChunk == null)
				{
					neighbor._backwardChunk = this;
				}
			}
			else if (delta.Z == 1)
			{
				if (neighbor.Blocks != null && _backwardChunk == null)
				{
					_backwardChunk = neighbor;
				}
				if (neighbor._forwardChunk == null)
				{
					neighbor._forwardChunk = this;
				}
			}
		}

		public void Disconnect()
		{
			if (_leftChunk != null)
			{
				_leftChunk._rightChunk = null;
				_leftChunk = null;
			}
			if (_rightChunk != null)
			{
				_rightChunk._leftChunk = null;
				_rightChunk = null;
			}
			if (_downChunk != null)
			{
				_downChunk._upChunk = null;
				_downChunk = null;
			}
			if (_upChunk != null)
			{
				_upChunk._downChunk = null;
				_upChunk = null;
			}
			if (_forwardChunk != null)
			{
				_forwardChunk._backwardChunk = null;
				_forwardChunk = null;
			}
			if (_backwardChunk != null)
			{
				_backwardChunk._forwardChunk = null;
				_backwardChunk = null;
			}
		}

		public static int BlockIndex(IntVector3 blockCoord)
		{
			return BlockIndex(blockCoord.X, blockCoord.Y, blockCoord.Z);
		}

		public static int BlockIndex(int x, int y, int z)
		{
			return x + ChunkSizeX * (y + ChunkSizeY * z);
		}

		public BlockFaces GetVisibleFaces(int x, int y, int z)
		{
			Contract.Requires(HasAllNeighbors);
			Contract.EndContractBlock();

			BlockFaces result = BlockFaces.None;

			if (Blocks[BlockIndex(x, y, z)].Type != BlockType.Empty)
			{
				bool isInside = x > 0 && y > 0 && z > 0 && x < ChunkSizeX - 1 && y < ChunkSizeY - 1 && z < ChunkSizeZ - 1;

				BlockType leftType, rightType, downType, upType, backwardType, forwardType;

				if (isInside)
				{
					leftType = Blocks[BlockIndex(x - 1, y, z)].Type;
					rightType = Blocks[BlockIndex(x + 1, y, z)].Type;
					downType = Blocks[BlockIndex(x, y - 1, z)].Type;
					upType = Blocks[BlockIndex(x, y + 1, z)].Type;
					backwardType = Blocks[BlockIndex(x, y, z + 1)].Type;
					forwardType = Blocks[BlockIndex(x, y, z - 1)].Type;
				}
				else
				{
					leftType = FindBlock(x - 1, y, z).Type;
					rightType = FindBlock(x + 1, y, z).Type;
					downType = FindBlock(x, y - 1, z).Type;
					upType = FindBlock(x, y + 1, z).Type;
					backwardType = FindBlock(x, y, z + 1).Type;
					forwardType = FindBlock(x, y, z - 1).Type;
				}

				if (leftType == BlockType.Empty)
				{
					result |= BlockFaces.Left;
				}

				if (rightType == BlockType.Empty)
				{
					result |= BlockFaces.Right;
				}

				if (downType == BlockType.Empty)
				{
					result |= BlockFaces.Down;
				}

				if (upType == BlockType.Empty)
				{
					result |= BlockFaces.Up;
				}

				if (backwardType == BlockType.Empty)
				{
					result |= BlockFaces.Backward;
				}

				if (forwardType == BlockType.Empty)
				{
					result |= BlockFaces.Forward;
				}
			}

			return result;
		}

		public bool Equals(Chunk other)
		{
			if (ReferenceEquals(null, other))
			{
				return false;
			}
			if (ReferenceEquals(this, other))
			{
				return true;
			}
			return other.Position.Equals(Position);
		}

		public override bool Equals(object obj)
		{
			if (ReferenceEquals(null, obj))
			{
				return false;
			}
			if (ReferenceEquals(this, obj))
			{
				return true;
			}
			if (obj.GetType() != typeof (Chunk))
			{
				return false;
			}
			return Equals((Chunk) obj);
		}

		public override int GetHashCode()
		{
			return Position.GetHashCode();
		}

		public bool TryGetBlock(IntVector3 blockCoord, out Block result)
		{
			if (Blocks != null)
			{
				result = Blocks[BlockIndex(blockCoord)];
				return true;
			}

			result = default (Block);
			return false;
		}

		private Block FindBlock(int x, int y, int z)
		{
			// Contract.Requires(HasAllNeighbors);
			Contract.Requires(Blocks != null);
			Contract.EndContractBlock();

			if (x < 0)
			{
				return _leftChunk.FindBlock(ChunkSizeX + x, y, z);
			}
			if (x >= ChunkSizeX)
			{
				return _rightChunk.FindBlock(x - ChunkSizeX, y, z);
			}

			if (y < 0)
			{
				return _downChunk.FindBlock(x, ChunkSizeY + y, z);
			}
			if (y >= ChunkSizeY)
			{
				return _upChunk.FindBlock(x, y - ChunkSizeY, z);
			}

			if (z < 0)
			{
				return _forwardChunk.FindBlock(x, y, ChunkSizeZ + z);
			}
			if (z >= ChunkSizeZ)
			{
				return _backwardChunk.FindBlock(x, y, z - ChunkSizeZ);
			}

			return Blocks[BlockIndex(x, y, z)];
		}

		public bool SetBlock(int x, int y, int z, BlockType blockType)
		{
			if (Blocks == null)
			{
				return false;
			}

			if (x < 0)
			{
				return _leftChunk != null && _leftChunk.SetBlock(x + ChunkSizeX, y, z, blockType);
			}
			if (x >= ChunkSizeX)
			{
				return _rightChunk != null && _rightChunk.SetBlock(x - ChunkSizeX, y, z, blockType);
			}

			if (y < 0)
			{
				return _downChunk != null && _downChunk.SetBlock(x, y + ChunkSizeY, z, blockType);
			}
			if (y >= ChunkSizeY)
			{
				return _upChunk != null && _upChunk.SetBlock(x, y - ChunkSizeY, z, blockType);
			}

			if (z < 0)
			{
				return _forwardChunk != null && _forwardChunk.SetBlock(x, y, z + ChunkSizeZ, blockType);
			}
			if (z >= ChunkSizeZ)
			{
				return _backwardChunk != null && _backwardChunk.SetBlock(x, y, z - ChunkSizeZ, blockType);
			}

			if (Blocks[BlockIndex(x, y, z)].Type != blockType)
			{
				State = ChunkState.DataOutOfSync;

				Blocks[BlockIndex(x, y, z)].Type = blockType;
				if (x == 0)
				{
					MarkNeighborChunkForUpdate(_leftChunk);
				}
				if (x == ChunkSizeX - 1)
				{
					MarkNeighborChunkForUpdate(_rightChunk);
				}

				if (y == 0)
				{
					MarkNeighborChunkForUpdate(_downChunk);
				}

				if (y == ChunkSizeY - 1)
				{
					MarkNeighborChunkForUpdate(_upChunk);
				}

				if (z == 0)
				{
					MarkNeighborChunkForUpdate(_forwardChunk);
				}
				if (z == ChunkSizeZ - 1)
				{
					MarkNeighborChunkForUpdate(_backwardChunk);
				}

				return true;
			}

			return false;
		}

		private void MarkNeighborChunkForUpdate(Chunk neighbor)
		{
			if (neighbor != null && neighbor.State == ChunkState.DataInSync)
			{
				neighbor.State = ChunkState.DataOutOfSync;
			}
		}
	}
}
