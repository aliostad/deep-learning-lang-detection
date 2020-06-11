using System;
using Devcat.Core.Collections;

namespace Devcat.Core.Threading
{
	public sealed class LoadFragmentManager
	{
		internal bool IsInThread
		{
			get
			{
				return this.threadLoad.IsInThread;
			}
		}

		public int TotalLoad
		{
			get
			{
				return this.totalLoad;
			}
		}

		public object Tag
		{
			get
			{
				return this.tag;
			}
			set
			{
				this.tag = value;
			}
		}

		public LoadFragmentManager()
		{
			this.jobList = new PriorityQueue<LoadFragment>();
			this.threadLoad = new ThreadLoad();
			this.threadLoad.Operationable += this.ThreadLoad_Operationable;
			this.newLoadFragmentList = new WriteFreeQueue2<LoadFragment>();
		}

		public void Startup(LoadBalancer loadBalancer)
		{
			if (this.loadBalancer != null)
			{
				throw new InvalidOperationException("Already registered to LoadBalancer");
			}
			this.loadBalancer = loadBalancer;
			loadBalancer.Add(this.threadLoad);
		}

		public void Cleanup()
		{
			this.loadBalancer.Remove(this.threadLoad);
		}

		internal void Add(LoadFragment loadFragment)
		{
			this.newLoadFragmentList.Enqueue(loadFragment);
			this.threadLoad.Load = this.totalLoad + 1;
		}

		internal void Remove(LoadFragment loadFragment)
		{
			if (loadFragment.PriorityQueueElement.Valid)
			{
				this.jobList.Remove(loadFragment.PriorityQueueElement);
			}
			this.totalLoad -= loadFragment.PreviousLoad;
			loadFragment.PreviousLoad = 0;
			loadFragment.SetManagerInternal(null);
		}

		internal void Reserve(LoadFragment loadFragment)
		{
			this.Add(loadFragment);
		}

		private void DoReserve(LoadFragment loadFragment)
		{
			if (loadFragment.PriorityQueueElement.Valid)
			{
				return;
			}
			if (loadFragment.Manager == null)
			{
				loadFragment.SetManagerInternal(this);
				loadFragment.InvokeManagerAssign();
			}
			int previousLoad = loadFragment.PreviousLoad;
			int load = loadFragment.Load;
			loadFragment.PreviousLoad = load;
			this.totalLoad += load - previousLoad;
			if (load != 0)
			{
				loadFragment.PriorityQueueElement.Value = loadFragment;
				loadFragment.PriorityQueueElement.Priority = loadFragment.Priority;
				this.jobList.Add(loadFragment.PriorityQueueElement);
				this.threadLoad.Load = this.totalLoad;
			}
		}

		private void AddPendingLoadFragments()
		{
			while (!this.newLoadFragmentList.Empty)
			{
				this.DoReserve(this.newLoadFragmentList.Dequeue());
			}
		}

		private void ThreadLoad_Operationable(ThreadLoad sender, EventArgs e)
		{
			this.threadLoad.Load = this.totalLoad;
			this.AddPendingLoadFragments();
			if (this.jobList.Count == 0)
			{
				return;
			}
			LoadFragment loadFragment = this.jobList.RemoveMin();
			try
			{
				loadFragment.InvokeOperationable();
			}
			finally
			{
				if (loadFragment.Manager == this)
				{
					this.DoReserve(loadFragment);
				}
			}
		}

		private LoadBalancer loadBalancer;

		private ThreadLoad threadLoad;

		private int totalLoad;

		private PriorityQueue<LoadFragment> jobList;

		private WriteFreeQueue2<LoadFragment> newLoadFragmentList;

		private object tag;
	}
}
