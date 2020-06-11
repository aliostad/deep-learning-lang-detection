using System;
using System.Threading;

namespace psl.memento.pervasive.hermes.client.util
{
	/// <summary>
	/// This is a runloop that works on the compact framework.
	/// </summary>
	public class Runloop
	{
		private DispatchManager _dispatchManager;
		/// <summary>
		/// DMT is dispatch manager thread
		/// </summary>
		private Thread _dmt;

		public Runloop(Dispatcher dispatcher)
		{
			this._dispatchManager = new DispatchManager(dispatcher);
			this._dispatchManager.setRunning(false);
			this._dmt = new Thread(new ThreadStart(this._dispatchManager.dispatch));
			this._dmt.Start();
		}

		public void start()
		{
			this._dispatchManager.setRunning(true);
		}

		public void add(Object obj)
		{
			lock(this._dispatchManager._list)
			{
				this._dispatchManager.enqueue(obj);
			}
		}

		public void stop()
		{
			this._dispatchManager.setRunning(false);
		}

		public void kill()
		{
			lock(this._dispatchManager)
			{
				this._dispatchManager.kill();
			}
		}
	}
}
