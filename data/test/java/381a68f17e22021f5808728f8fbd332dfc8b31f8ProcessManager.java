package os;

import machine.Machine;
import os.OS.ProcessState;

public class ProcessManager {
	private OS os;
	
	public ProcessManager(OS os) {
		this.os = os;
	}

	public void execute() {
		Machine.outputArea.append("PROCESS MANAGER\n");
		
		if (os.runProcess != null) {
			Machine.outputArea.append("RUNNING: " + os.runProcess + "\n");
			checkCurrent();
		}
		else {
			Machine.outputArea.append("RUNNING: NOTHING\n");
		}
		
		Process candidate = getTopPriorityReadyProc();
		
		if (candidate != null) {
			prepareProcess(candidate);
			Machine.outputArea.append("NEW RUNNING: " + os.runProcess + "\n");
		}
		else {
			Machine.outputArea.append("NO READY PROCESSES\n");
		}
	}
	
	private void prepareProcess(Process newProcess) {
		os.runProcess = newProcess;
		newProcess.processDescriptor.processState = ProcessState.RUN;
		os.readyProcesses.remove(newProcess);
		newProcess.loadCPU();
	}
	
	private void checkCurrent() {
		Process process = os.runProcess;
		process.saveCPU();
		os.runProcess = null;
		if (process.processDescriptor.processState != ProcessState.BLOCKED) {
			process.processDescriptor.processState = ProcessState.READY;
			os.readyProcesses.add(process);
		}
	}
	
	private Process getTopPriorityReadyProc() {
		Process temp = null;
		if (!os.readyProcesses.isEmpty()) {
			temp = os.readyProcesses.element();
			for (Process process : os.readyProcesses) {
				if (process.processDescriptor.processPriority > temp.processDescriptor.processPriority)
					temp = process;
			}
		}
		return temp;
	}
}
