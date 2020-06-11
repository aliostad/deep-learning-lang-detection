using System.Collections.Generic;
using System.Diagnostics.Contracts;
using System.Threading;
using Common.Collections.Extensions;

namespace Common.Collections.Concurrent
{
	public class ChunkedArray<T>: TailableCollectionBase<T>, IAppendableCollection<T>
	{
		private readonly ConcurrentLinkedList<T[]> chunkList
			= new ConcurrentLinkedList<T[]>();

		private readonly int chunkSize;
		private readonly ReaderWriterLockSlim lockSlim = new ReaderWriterLockSlim();
		private long count;

		public ChunkedArray(int chunkSize)
		{
			Contract.Requires(chunkSize > 0);
			this.chunkSize = chunkSize;
			chunkList.Add(new T[chunkSize]);
		}

		#region IAppendableCollection<T> Members

		public override long Count
		{
			get { return count; }
		}

		public override T this[long index]
		{
			get
			{
				long chunkNumber = index / chunkSize;
				long indexInChunk = index % chunkSize;
				return chunkList[chunkNumber][indexInChunk];
			}
		}

		public void Add(IEnumerable<T> values)
		{
			lockSlim.EnterWriteLock();
			values.ForEach(AppendInternal);
			lockSlim.ExitWriteLock();
		}

		public override IEnumerable<T> ReadFrom(long index)
		{
			long chunkNumber = index / chunkSize;
			IEnumerator<T[]> chunks = chunkList.ReadFrom(chunkNumber).GetEnumerator();
			T[] arrayChunk = null;
			while(index < count) {
				long numberInChunk = index % chunkSize;
				if(numberInChunk == 0 || arrayChunk == null) {
					chunks.MoveNext();
					arrayChunk = chunks.Current;
				}
				yield return arrayChunk[numberInChunk];

				index++;
			}
		}

		public void Add(T value)
		{
			lockSlim.EnterWriteLock();
			AppendInternal(value);
			lockSlim.ExitWriteLock();
		}

		#endregion

		private void AppendInternal(T data)
		{
			long chunkNumber = count / chunkSize;
			long indexInChunk = count % chunkSize;
			chunkList[chunkNumber][indexInChunk] = data;
			count++;
			if(indexInChunk == chunkSize - 1)
				chunkList.Add(new T[chunkSize]);
		}
	}
}