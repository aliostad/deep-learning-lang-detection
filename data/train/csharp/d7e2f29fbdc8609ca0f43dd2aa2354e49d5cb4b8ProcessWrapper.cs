using System;
using System.Diagnostics;

namespace ProfNet.Model.Profiling.ProcessModel
{
	public class ProcessWrapper : IProcess
	{
		private readonly Process _process;

		public ProcessWrapper(Process process)
		{
			_process = process;
		}

		public ProcessStartInfo StartInfo
		{
			get { return _process.StartInfo; }
		}

		public bool EnableRaisingEvents
		{
			get { return _process.EnableRaisingEvents; }
			set { _process.EnableRaisingEvents = value; }
		}
		public event EventHandler Exited
		{
			add { _process.Exited += value; }
			remove { _process.Exited -= value; }
		}

		public void Dispose()
		{
			_process.Dispose();
		}


		public bool HasExited
		{
			get
			{
				return _process.HasExited;
			}
		}

		public void Kill()
		{
			_process.Kill();
		}


		bool IProcess.HasExited
		{
			get
			{
				return _process.HasExited;
			}
		}
	}
}