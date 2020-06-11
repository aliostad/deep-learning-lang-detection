package emulator;

import gui.Window;

public class CPU {

	private Process runningProcess; // running process
	private int timeToNextContextSwitch; // time to next interrupt
	private int lastProcessStartTime; // time that last process starts

	// constructor
	public CPU() {

	}

	// insert process to execute
	public void addProcess(Process process) {
		runningProcess = process;
		Window.getConsole().appendCpuMessage("+CPU: Added process to cpu");
		Window.getConsole().appendCpuMessage(runningProcess.toString());

	}

	// extracting running process from CPU
	public Process removeProcessFromCpu() {
		Process temp = runningProcess;
		runningProcess = null;

		Window.getConsole().appendCpuMessage("-CPU: Removed process from cpu");
		Window.getConsole().appendCpuMessage(temp.toString());

		return temp;

	}

	// executing process and reducing time of its execution
	public void execute() {

		if (runningProcess != null) {
			if (runningProcess.getCpuRemainingTime() > 0) {
				runningProcess.changeCpuRemainingTime(runningProcess.getCpuRemainingTime() - 1);
				Window.getConsole().appendExecuteMessage("+Exec: Executed process at cpu");
				Window.getConsole().appendExecuteMessage(runningProcess.toString());

			}
		}

	}

	public Process peekCpuProcess() {
		return runningProcess;
	}

	public int getLastProcessStartTime() {
		return lastProcessStartTime;
	}

	public void setLastProcessStartTime(int lastProcessStartTime) {
		this.lastProcessStartTime = lastProcessStartTime;
	}
}
