using System.Collections.Generic;

namespace Xenon {
	public class ProcessManager {

		private List<Process> processes;
		private List<Process> toRemove;
		private List<Process> toStart;

		public ProcessManager() {
			processes = new List<Process>();
			toRemove = new List<Process>();
			toStart = new List<Process>();
		}

		public void LaunchProcess(Process process) {
			processes.Add(process);
			process.Start();
		}

		public void UpdateProcesses(float dt) {
			foreach (Process process in processes) {
				process.Update(dt);
				switch (process.State) {
					case ProcessState.TERMINATED:
						TerminateProcess(process);
						break;
					case ProcessState.CANCELLED:
						CancelProcess(process);
						break;
				}
			}
			UpdateProcessList();
		}

		private void TerminateProcess(Process process) {
			process.OnTerminate();
			process.InvokeTerminateCallback();
			if (process.State == ProcessState.TERMINATED) {
				toRemove.Add(process);
			}
			foreach (Process attached in process.Attached) {
				toStart.Add(attached);
			}
		}

		private void CancelProcess(Process process) {
			toRemove.Add(process);
		}

		private void UpdateProcessList() {
			foreach (Process remProc in toRemove) {
				processes.Remove(remProc);
			}
			toRemove.Clear();
			foreach (Process staProc in toStart) {
				LaunchProcess(staProc);
			}
			toStart.Clear();
		}

	}
}
