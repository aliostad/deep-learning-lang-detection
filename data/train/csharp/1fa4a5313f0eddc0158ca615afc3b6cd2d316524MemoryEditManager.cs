using System.Collections.Generic;

namespace IntelOrca.MemPatch
{
	public class MemoryEditManager
	{
		AppProcess mProcess;
		Stack<IMemoryEdit> mMemoryEdits = new Stack<IMemoryEdit>();

		public MemoryEditManager(AppProcess process)
		{
			mProcess = process;
		}

		public void Activate(IMemoryEdit edit)
		{
			mProcess.SuspendProcess();

			edit.Process = mProcess;
			edit.Activate();
			mMemoryEdits.Push(edit);

			mProcess.ResumeProcess();
		}

		public void DeactivateAll()
		{
			mProcess.SuspendProcess();

			while (mMemoryEdits.Count > 0) {
				mMemoryEdits.Pop().Deactivate();
			}

			mProcess.ResumeProcess();
		}

		public int Count
		{
			get
			{
				return mMemoryEdits.Count;
			}
		}

		public AppProcess Process
		{
			get
			{
				return mProcess;
			}
		}
	}
}
