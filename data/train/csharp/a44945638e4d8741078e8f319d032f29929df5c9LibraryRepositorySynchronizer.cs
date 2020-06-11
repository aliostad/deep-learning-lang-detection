using System.Collections.Generic;
using System.Threading;

namespace Tp.MashupManager.MashupLibrary.Repository.Synchronizer
{
	public class LibraryRepositorySynchronizer : ILibraryRepositorySynchronizer
	{
		private class CountableReaderWriterLockSlim : ReaderWriterLockSlim
		{
			public int ReadLockCount { get; set; }
			public int WriteLockCount { get; set; }
		}

		private readonly Dictionary<string, CountableReaderWriterLockSlim> _repositoryLocks;

		public LibraryRepositorySynchronizer()
		{
			_repositoryLocks = new Dictionary<string, CountableReaderWriterLockSlim>();
		}

		public void BeginRead(ISynchronizableLibraryRepository repository)
		{
			CountableReaderWriterLockSlim repositoryLock;
			lock (_repositoryLocks)
			{
				repositoryLock = _repositoryLocks.GetOrAdd(repository.Id, repositoryDescriptor => new CountableReaderWriterLockSlim());
				repositoryLock.ReadLockCount++;
			}
			repositoryLock.EnterReadLock();
		}

		public void EndRead(ISynchronizableLibraryRepository repository)
		{
			lock (_repositoryLocks)
			{
				if (_repositoryLocks.ContainsKey(repository.Id) && _repositoryLocks[repository.Id].ReadLockCount > 0)
				{
					var repositoryLock = _repositoryLocks[repository.Id];
					repositoryLock.ReadLockCount--;
					repositoryLock.ExitReadLock();
					ReleaseLockIfUnused(repository, repositoryLock);
				}
			}
		}

		public bool TryBeginWrite(ISynchronizableLibraryRepository repository)
		{
			CountableReaderWriterLockSlim repositoryLock;
			lock (_repositoryLocks)
			{
				if (_repositoryLocks.ContainsKey(repository.Id))
				{
					repositoryLock = _repositoryLocks[repository.Id];
					if (repositoryLock.WriteLockCount > 0)
					{
						return false;
					}
				}
				else
				{
					repositoryLock = new CountableReaderWriterLockSlim();
					_repositoryLocks.Add(repository.Id, repositoryLock);
				}
				repositoryLock.WriteLockCount++;
			}
			repositoryLock.EnterWriteLock();
			return true;
		}

		public void EndWrite(ISynchronizableLibraryRepository repository)
		{
			lock (_repositoryLocks)
			{
				if (_repositoryLocks.ContainsKey(repository.Id) && _repositoryLocks[repository.Id].WriteLockCount > 0)
				{
					var repositoryLock = _repositoryLocks[repository.Id];
					repositoryLock.WriteLockCount--;
					repositoryLock.ExitWriteLock();
					ReleaseLockIfUnused(repository, repositoryLock);
				}
			}
		}

		private void ReleaseLockIfUnused(ISynchronizableLibraryRepository repository, CountableReaderWriterLockSlim repositoryLock)
		{
			if (repositoryLock.ReadLockCount == 0 && repositoryLock.WriteLockCount == 0)
			{
				_repositoryLocks.Remove(repository.Id);
				repositoryLock.Dispose();
			}
		}
	}
	
}