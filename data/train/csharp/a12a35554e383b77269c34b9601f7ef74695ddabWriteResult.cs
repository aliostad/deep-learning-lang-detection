using System.Threading.Tasks;

namespace NEStore
{
	public class WriteResult<T>
	{

		/// <summary>
		/// Public WriteResult constructor
		/// </summary>
		/// <param name="commit">The commit</param>
		/// <param name="dispatchTask">The dispatch task</param>
		public WriteResult(CommitData<T> commit, Task dispatchTask)
		{
			DispatchTask = dispatchTask;
			Commit = commit;
		}

		/// <summary>
		/// Gets the commit persisted to durable storage
		/// </summary>
		public CommitData<T> Commit { get; private set; }

		/// <summary>
		/// Gets the dispatch task belonging to the commit
		/// </summary>
		public Task DispatchTask { get; private set; }
	}
}