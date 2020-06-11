using System;
using Blarg.GameFramework.TileMap.Lighting;
using Blarg.GameFramework.TileMap.Meshes;

namespace Blarg.GameFramework.TileMap
{
	public class TileMap : TileContainer, IDisposable
	{
		#region Fields

		readonly Vector3 _position;
		readonly BoundingBox _bounds;

		#endregion

		#region Properties

		public readonly TileChunk[] Chunks;
		public readonly TileMeshCollection TileMeshes;
		public readonly ChunkVertexGenerator VertexGenerator;
		public readonly ITileMapLighter Lighter;
		public byte AmbientLightValue;
		public byte SkyLightValue;

		public readonly int ChunkWidth;
		public readonly int ChunkHeight;
		public readonly int ChunkDepth;
		public readonly int WidthInChunks;
		public readonly int HeightInChunks;
		public readonly int DepthInChunks;

		public override int Width
		{
			get { return ChunkWidth * WidthInChunks; }
		}

		public override int Height
		{
			get { return ChunkHeight * HeightInChunks; }
		}

		public override int Depth
		{
			get { return ChunkDepth * DepthInChunks; }
		}

		public override int MinX
		{
			get { return 0; }
		}

		public override int MinY
		{
			get { return 0; }
		}

		public override int MinZ
		{
			get { return 0; }
		}

		public override int MaxX
		{
			get { return Width - 1; }
		}

		public override int MaxY
		{
			get { return Height - 1; }
		}

		public override int MaxZ
		{
			get { return Depth - 1; }
		}

		public override Vector3 Position
		{
			get { return _position; }
		}

		public override BoundingBox Bounds
		{
			get { return _bounds; }
		}

		#endregion

		public TileMap(int chunkWidth, int chunkHeight, int chunkDepth,
		               int widthInChunks, int heightInChunks, int depthInChunks,
		               TileMeshCollection tileMeshes,
		               ChunkVertexGenerator vertexGenerator,
		               ITileMapLighter lighter
		               )
		{
			if (tileMeshes == null)
				throw new ArgumentNullException("tileMeshes");
			if (vertexGenerator == null)
				throw new ArgumentNullException("vertexGenerator");

			TileMeshes = tileMeshes;
			VertexGenerator = vertexGenerator;
			Lighter = lighter;
			ChunkWidth = chunkWidth;
			ChunkHeight = chunkHeight;
			ChunkDepth = chunkDepth;
			WidthInChunks = widthInChunks;
			HeightInChunks = heightInChunks;
			DepthInChunks = depthInChunks;

			AmbientLightValue = 0;
			SkyLightValue = Tile.LIGHT_VALUE_SKY;

			int numChunks = widthInChunks * heightInChunks * depthInChunks;
			Chunks = new TileChunk[numChunks];

			for (int y = 0; y < heightInChunks; ++y)
			{
				for (int z = 0; z < depthInChunks; ++z)
				{
					for (int x = 0; x < widthInChunks; ++x)
					{
						TileChunk chunk = new TileChunk(
							x * chunkWidth,
							y * chunkHeight,
							z * chunkDepth,
							chunkWidth,
							chunkHeight,
							chunkDepth,
							this
							);

						int index = GetChunkIndex(x, y, z);
						Chunks[index] = chunk;
					}
				}
			}

			_position = Vector3.Zero;
			_bounds = new BoundingBox();
			_bounds.Min = Vector3.Zero;
			_bounds.Max.Set(Width, Height, Depth);
		}

		public void UpdateVertices()
		{
			for (int i = 0; i < Chunks.Length; ++i)
				UpdateChunkVertices(Chunks[i]);
		}

		private void UpdateChunkVertices(TileChunk chunk)
		{
			chunk.UpdateVertices(VertexGenerator);
		}

		public void UpdateLighting()
		{
			if (Lighter != null)
				Lighter.Light(this);
		}

		#region Bounds Checks

		public bool GetOverlappedChunks(BoundingBox box, Point3 min, Point3 max)
		{
			// make sure the given box actually intersects with the map in the first place
			var bounds = _bounds;
			if (!IntersectionTester.Test(ref bounds, ref box))
				return false;

			// convert to tile coords. this is in "tilemap space" which is how we want it
			// HACK: ceil() calls and "-1"'s keep us from picking up too many/too few
			// blocks. these were arrived at through observation
			int minX = (int)box.Min.X;
			int minY = (int)box.Min.Y;
			int minZ = (int)box.Min.Z;
			int maxX = (int)Math.Ceiling(box.Max.X);
			int maxY = (int)Math.Ceiling(box.Max.Y - 1.0f);
			int maxZ = (int)Math.Ceiling(box.Max.Z);

			// now convert to chunk coords
			int minChunkX = minX / ChunkWidth;
			int minChunkY = minY / ChunkHeight;
			int minChunkZ = minZ / ChunkDepth;
			int maxChunkX = maxX / ChunkWidth;
			int maxChunkY = maxY / ChunkHeight;
			int maxChunkZ = maxZ / ChunkDepth;

			// trim off the excess bounds so that we end up with a min-to-max area
			// that is completely within the chunk bounds of the map
			// HACK: "-1"'s keep us from picking up too many chunks. these were arrived
			// at through observation
			minChunkX = MathHelpers.Clamp(minChunkX, 0, WidthInChunks);
			minChunkY = MathHelpers.Clamp(minChunkY, 0, (HeightInChunks - 1));
			minChunkZ = MathHelpers.Clamp(minChunkZ, 0, DepthInChunks);
			maxChunkX = MathHelpers.Clamp(maxChunkX, 0, WidthInChunks);
			maxChunkY = MathHelpers.Clamp(maxChunkY, 0, (HeightInChunks - 1));
			maxChunkZ = MathHelpers.Clamp(maxChunkZ, 0, DepthInChunks);

			// return the leftover area
			min.X = minChunkX;
			min.Y = minChunkY;
			min.Z = minChunkZ;
			max.X = maxChunkX;
			max.Y = maxChunkY;
			max.Z = maxChunkZ;

			return true;
		}

		#endregion

		#region Tile Retrieval

		public override Tile Get(int x, int y, int z)
		{
			var chunk = GetChunkContaining(x, y, z);
			int chunkX = x - chunk.MinX;
			int chunkY = y - chunk.MinY;
			int chunkZ = z - chunk.MinZ;

			return chunk.Get(chunkX, chunkY, chunkZ);
		}

		public override Tile Get(Point3 p)
		{
			var chunk = GetChunkContaining(p.X, p.Y, p.Z);
			int chunkX = p.X - chunk.MinX;
			int chunkY = p.Y - chunk.MinY;
			int chunkZ = p.Z - chunk.MinZ;

			return chunk.Get(chunkX, chunkY, chunkZ);
		}

		public override Tile GetSafe(int x, int y, int z)
		{
			if (!IsWithinBounds(x, y, z))
				return null;
			else
				return Get(x, y, z);
		}

		public override Tile GetSafe(Point3 p)
		{
			if (!IsWithinBounds(p.X, p.Y, p.Z))
				return null;
			else
				return Get(p.X, p.Y, p.Z);
		}

		#endregion

		#region Chunk Retrieval

		public TileChunk GetChunk(int chunkX, int chunkY, int chunkZ)
		{
			int index = GetChunkIndex(chunkX, chunkY, chunkZ);
			return Chunks[index];
		}

		public TileChunk GetChunkSafe(int chunkX, int chunkY, int chunkZ)
		{
			if ((chunkX >= WidthInChunks) ||
				(chunkY >= HeightInChunks) ||
				(chunkZ >= DepthInChunks)
				)
				return null;
			else
				return GetChunk(chunkX, chunkY, chunkZ);
		}

		public TileChunk GetChunkNextTo(TileChunk chunk, int chunkOffsetX, int chunkOffsetY, int chunkOffsetZ)
		{
			int checkX = chunk.MinX + chunkOffsetX;
			int checkY = chunk.MinY + chunkOffsetY;
			int checkZ = chunk.MinZ + chunkOffsetZ;

			if ((checkX < 0 || checkX >= WidthInChunks) ||
				(checkY < 0 || checkY >= HeightInChunks) ||
				(checkZ < 0 || checkZ >= DepthInChunks)
				)
				return null;
			else
				return GetChunk(checkX, checkY, checkZ);
		}

		public TileChunk GetChunkContaining(int x, int y, int z) {
			int index = GetChunkIndexAt(x, y, z);
			return Chunks[index];
		}

		private int GetChunkIndexAt(int x, int y, int z)
		{
			return GetChunkIndex(x / ChunkWidth, y / ChunkHeight, z / ChunkDepth);
		}

		private int GetChunkIndex(int chunkX, int chunkY, int chunkZ)
		{
			return (chunkY * WidthInChunks * DepthInChunks) + (chunkZ * WidthInChunks) + chunkX;
		}

		#endregion

		#region IDisposable

		public void Dispose()
		{
			for (int i = 0; i < Chunks.Length; ++i)
				Chunks[i].Dispose();
		}

		#endregion
	}
}

