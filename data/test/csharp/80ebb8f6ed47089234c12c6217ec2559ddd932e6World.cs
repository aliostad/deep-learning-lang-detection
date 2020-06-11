using System;
using System.Collections;
using System.Collections.Generic;
using OpenTK;
using OpenTK.Graphics.OpenGL;
using MinecraftEditor.Graphics;

namespace MinecraftEditor.Minecraft
{
	public class World : IEnumerable<Chunk>
	{
		Dictionary<PointS, Chunk> _chunks = new Dictionary<PointS, Chunk>();
		byte _light = 15, _minLight = 2;
		
		public Vector2d RenderOrigin { get; set; }
		public int RenderRange { get; set; }
		public int ChunksVisible { get; set; }
		public int ChunksInRange { get; set; }
		
		public int ChunksLoaded {
			get { return _chunks.Count; }
		}
		public byte Light {
			get { return _light; }
			set {
				if (value == _light) return;
				if (value < 0 || value >= 16)
					throw new ArgumentOutOfRangeException();
				_light = value;
				foreach (Chunk chunk in this)
					chunk.Cached = false;
			}
		}
		public byte MinimumLight {
			get { return _minLight; }
			set {
				if (value == _minLight) return;
				if (value < 0 || value >= 16)
					throw new ArgumentOutOfRangeException();
				_minLight = value;
				foreach (Chunk chunk in this)
					chunk.Cached = false;
			}
		}
		
		public World()
		{
			RenderRange = 160;
		}
		
		#region Chunk manipulation
		public Chunk GetChunkAt(int x, int z)
		{
			return GetChunk((short)Math.Floor(x / (double)Chunk.Width),
			                (short)Math.Floor(z / (double)Chunk.Height));
		}
		public Chunk GetChunk(short x, short z)
		{
			PointS p = new PointS(x, z);
			if (!_chunks.ContainsKey(p)) return null;
			else return _chunks[p];
		}
		public void SetChunk(Chunk chunk)
		{
			if (chunk == null)
				throw new ArgumentNullException("chunk");
			Chunk right = GetChunk((short)(chunk.X + 1), chunk.Z);
			Chunk left  = GetChunk((short)(chunk.X - 1), chunk.Z);
			Chunk front = GetChunk(chunk.X, (short)(chunk.Z + 1));
			Chunk back  = GetChunk(chunk.X, (short)(chunk.Z - 1));
			if (right != null) { right.Left = chunk; right.Cached = false; }
			if (left  != null) { left.Right = chunk; left.Cached  = false; }
			if (front != null) { front.Back = chunk; front.Cached = false; }
			if (back  != null) { back.Front = chunk; back.Cached  = false; }
			_chunks[new PointS(chunk.X, chunk.Z)] = chunk;
			chunk.World = this;
			chunk.Right = right;
			chunk.Left  = left;
			chunk.Front = front;
			chunk.Back  = back;
			chunk.Cached = false;
		}
		public void RemoveChunk(Chunk chunk)
		{
			if (chunk == null)
				throw new ArgumentNullException("chunk");
			Chunk right = GetChunk((short)(chunk.X + 1), chunk.Z);
			Chunk left  = GetChunk((short)(chunk.X - 1), chunk.Z);
			Chunk front = GetChunk(chunk.X, (short)(chunk.Z + 1));
			Chunk back  = GetChunk(chunk.X, (short)(chunk.Z - 1));
			if (right != null) { right.Left = chunk; right.Cached = false; }
			if (left  != null) { left.Right = chunk; left.Cached  = false; }
			if (front != null) { front.Back = chunk; front.Cached = false; }
			if (back  != null) { back.Front = chunk; back.Cached  = false; }
			_chunks.Remove(new PointS(chunk.X, chunk.Z));
		}
		#endregion
		
		#region Block manipulation
		public Blocktype GetBlocktype(int x, int y, int z)
		{
			if (y < 0 || y >= Chunk.Depth) return Blocktype.Air;
			Chunk chunk = GetChunkAt(x, z);
			if (chunk == null) return Blocktype.Air;
			return chunk.GetBlocktype(x, y, z);
		}
		public void SetBlocktype(int x, int y, int z, Blocktype type)
		{
			if (y < 0 || y >= Chunk.Depth) return;
			Chunk chunk = GetChunkAt(x, z);
			if (chunk == null) return;
			x = (x % Chunk.Width + Chunk.Width) % Chunk.Width;
			z = (z % Chunk.Height + Chunk.Height) % Chunk.Height;
			chunk.SetBlocktype(x, y, z, type);
			chunk.Cached = false;
			if (x == Chunk.Width - 1 && chunk.Right != null) chunk.Right.Cached = false;
			if (x == 0 && chunk.Left != null) chunk.Left.Cached = false;
			if (z == Chunk.Height - 1 && chunk.Front != null) chunk.Front.Cached = false;
			if (z == 0 && chunk.Back != null) chunk.Back.Cached = false;
		}
		public byte GetData(int x, int y, int z)
		{
			if (y < 0 || y >= Chunk.Depth) return 0;
			Chunk chunk = GetChunkAt(x, z);
			if (chunk == null) return 0;
			return chunk.GetData(x, y, z);
		}
		public void SetData(int x, int y, int z, byte data)
		{
			if (y < 0 || y >= Chunk.Depth) return;
			Chunk chunk = GetChunkAt(x, z);
			if (chunk == null) return;
			x = (x % Chunk.Width + Chunk.Width) % Chunk.Width;
			z = (z % Chunk.Height + Chunk.Height) % Chunk.Height;
			chunk.SetData(x, y, z, data);
			chunk.Cached = false;
			if (x == Chunk.Width - 1 && chunk.Right != null) chunk.Right.Cached = false;
			if (x == 0 && chunk.Left != null) chunk.Left.Cached = false;
			if (z == Chunk.Height - 1 && chunk.Front != null) chunk.Front.Cached = false;
			if (z == 0 && chunk.Back != null) chunk.Back.Cached = false;
		}
		#endregion
		
		#region IEnumerable<Chunk>
		public IEnumerator<Chunk> GetEnumerator()
		{
			return _chunks.Values.GetEnumerator();
		}
		IEnumerator IEnumerable.GetEnumerator()
		{
			return GetEnumerator();
		}
		#endregion
		
		#region Render
		public void Render()
		{
			List<Chunk> chunks = new List<Chunk>((int)(Math.PI * Math.Pow(RenderRange / Chunk.Width, 2)));
			Chunk nearestUncached = null;
			double nearestDistance = double.MaxValue;
			ChunksInRange = 0;
			foreach (Chunk chunk in _chunks.Values) {
				double dist = Math.Sqrt((Math.Pow(RenderOrigin.X + chunk.X * Chunk.Width + Chunk.Width / 2, 2) +
				                         Math.Pow(RenderOrigin.Y + chunk.Z * Chunk.Height + Chunk.Height / 2, 2)));
				if (dist > RenderRange) continue;
				ChunksInRange++;
				if (chunk.ListCached) chunks.Add(chunk);
				if (!chunk.Cached && dist < nearestDistance) {
					nearestDistance = dist;
					nearestUncached = chunk;
				}
			}
			ChunksVisible = chunks.Count;
			if (nearestUncached != null)
				chunks.Remove(nearestUncached);
			
			Display.Texture = Ressources.TerrainTexture;
			foreach (Chunk chunk in chunks) RenderChunk(chunk, false, false);
			if (nearestUncached != null) RenderChunk(nearestUncached, true, false);
			Display.BlendMode = BlendMode.Blend;
			GL.DepthMask(false);
			foreach (Chunk chunk in chunks) RenderChunk(chunk, false, true);
			if (nearestUncached != null) RenderChunk(nearestUncached, true, true);
			GL.DepthMask(true);
			Display.BlendMode = BlendMode.None;
		}
		
		public void RenderPicking(Vector3d origin, float range)
		{
			foreach (Chunk chunk in _chunks.Values) {
				double dist = Math.Sqrt((Math.Pow(origin.X - (chunk.X * Chunk.Width + Chunk.Width / 2), 2) +
				                         Math.Pow(origin.Z - (chunk.Z * Chunk.Height + Chunk.Height / 2), 2))) -
					Chunk.Width * Math.Sqrt(2) / 2;
				if (dist > range) continue;
				GL.PushMatrix();
				GL.Translate(chunk.X * Chunk.Width, 0.0, chunk.Z * Chunk.Height);
				for (int x = (int)Math.Floor(Math.Max(0, origin.X - chunk.X * Chunk.Width - range));
				     x < (int)Math.Ceiling(Math.Min(Chunk.Width, origin.X - chunk.X * Chunk.Width + range)); x++) {
					GL.PushName(chunk.X * 16 + x);
					for (int y = (int)Math.Floor(Math.Max(0, origin.Y - range));
					     y < (int)Math.Ceiling(Math.Min(Chunk.Depth , origin.Y + range)); y++) {
						GL.PushName(y);
						for (int z = (int)Math.Floor(Math.Max(0, origin.Z - chunk.Z * Chunk.Height - range));
						     z < (int)Math.Ceiling(Math.Min(Chunk.Height, origin.Z - chunk.Z * Chunk.Height + range)); z++) {
							dist = Math.Sqrt((Math.Pow(origin.X - (chunk.X * Chunk.Width + x), 2) + Math.Pow(origin.Y - y, 2)) +
							                 Math.Pow(origin.Z - (chunk.Z * Chunk.Height + z), 2));
							if (dist > range) continue;
							Blocktype type = chunk.GetBlocktype(x, y, z);
							if (type == Blocktype.Air) continue;
							BlocktypeInfo info = BlocktypeInfo.Find(type);
							GL.PushName(chunk.Z * 16 + z);
							BlockRenderer.RenderPicking(chunk, info, x, y, z);
							GL.PopName();
						}
						GL.PopName();
					}
					GL.PopName();
				}
				GL.PopMatrix();
			}
		}
		void RenderChunk(Chunk chunk, bool cache, bool transparent)
		{
			GL.PushMatrix();
			GL.Translate(chunk.X * Chunk.Width, 0.0, chunk.Z * Chunk.Height);
			if (!transparent) chunk.Render(cache);
			else chunk.RenderTransparent(cache);
			GL.PopMatrix();
		}
		#endregion
	}
}
