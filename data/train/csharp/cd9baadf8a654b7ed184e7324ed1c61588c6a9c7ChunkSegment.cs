using System;

namespace Devcat.Core.Memory
{
	public static class ChunkSegment<T>
	{
		internal static ChunkSegment<T>.ChunkSegmentContext Context
		{
			get
			{
				if (ChunkSegment<T>.context == null)
				{
					ChunkSegment<T>.context = new ChunkSegment<T>.ChunkSegmentContext();
				}
				return ChunkSegment<T>.context;
			}
		}

		public static int AllocationSize
		{
			get
			{
				return ChunkSegment<T>.allocationSize;
			}
			set
			{
				ChunkSegment<T>.allocationSize = value;
			}
		}

		public static ArraySegment<T> Get(int size)
		{
			return ChunkSegment<T>.Context.Get(size);
		}

		[ThreadStatic]
		private static ChunkSegment<T>.ChunkSegmentContext context;

		private static int allocationSize = 65512;

		internal class ChunkSegmentContext
		{
			public ChunkSegmentContext()
			{
				this.chunk = new T[ChunkSegment<T>.AllocationSize];
			}

			public ArraySegment<T> Get(int size)
			{
				if (size >= this.chunk.Length)
				{
					return new ArraySegment<T>(new T[size]);
				}
				if (this.index + size > this.chunk.Length)
				{
					this.chunk = new T[ChunkSegment<T>.AllocationSize];
					this.index = 0;
				}
				this.index += size;
				return new ArraySegment<T>(this.chunk, this.index - size, size);
			}

			private int index;

			private T[] chunk;
		}
	}
}
