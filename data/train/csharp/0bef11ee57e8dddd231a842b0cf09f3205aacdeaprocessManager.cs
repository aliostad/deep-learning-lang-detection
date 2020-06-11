using Cross;
using System;

namespace GameFramework
{
	public class processManager : BaseCrossPlugin
	{
		private processQueue _processQMaster = null;

		private processQueue _processQ = null;

		private processQueue _renderQ = null;

		private processQueue _renderQMaster = null;

		public static processManager instance;

		public override string pluginName
		{
			get
			{
				return "processManager";
			}
		}

		public processManager()
		{
			processManager.instance = this;
			this._processQMaster = new processQueue();
			this._processQ = new processQueue();
			this._renderQ = new processQueue();
			this._renderQMaster = new processQueue();
			this._processQMaster.setDebug("processManager master proc ");
			this._processQ.setDebug("processManager proc");
			this._renderQMaster.setDebug("processManager master _render ");
			this._renderQ.setDebug("processManager _render");
		}

		public override void onRender(float tmSlice)
		{
			this._renderQMaster.process(tmSlice);
			this._renderQ.process(tmSlice);
		}

		public override void onProcess(float tmSlice)
		{
			this._processQMaster.process(tmSlice);
			this._processQ.process(tmSlice);
		}

		public void addProcess(IProcess p, bool master = false)
		{
			bool flag = p == null;
			if (!flag)
			{
				if (master)
				{
					this._processQMaster.addProcess(p);
				}
				else
				{
					this._processQ.addProcess(p);
				}
			}
		}

		public void removeProcess(IProcess p, bool master = false)
		{
			if (master)
			{
				this._processQMaster.removeProcess(p);
			}
			else
			{
				this._processQ.removeProcess(p);
			}
		}

		public void addRender(IProcess p, bool master = false)
		{
			bool flag = p == null;
			if (!flag)
			{
				if (master)
				{
					this._renderQMaster.addProcess(p);
				}
				else
				{
					this._renderQ.addProcess(p);
				}
			}
		}

		public void removeRender(IProcess p, bool master = false)
		{
			if (master)
			{
				this._renderQMaster.removeProcess(p);
			}
			else
			{
				this._renderQ.removeProcess(p);
			}
		}
	}
}
