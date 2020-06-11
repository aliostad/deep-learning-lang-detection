package com.ru.usty.scheduling.process;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import com.ru.usty.scheduling.Policy;
import com.ru.usty.scheduling.Scheduler;

/**
 * 
 * DO NOT CHANGE THIS CLASS
 *
 */

public class ProcessHandler implements ProcessExecution {

/**
 * ONLY THE BOTTOM TWO OPERATIONS SHOULD BE CALLED BY THE SCHEDULER
 * They are the only ones implementing the ProcessExecution interface
 */

	private Map<Integer, Process> processes;
	private Process currentProcess = null;
	private Scheduler scheduler;

	public ProcessHandler() {
		processes = new HashMap<Integer, Process>();
		scheduler = new Scheduler(this);
	}

	public void startSceduling(Policy policy, int quantum) {
		processes.clear();
		scheduler.startScheduling(policy, quantum);
	}

	public void addProcess(int processID, long timeToRun) {
		processes.put(processID, new Process(processID, timeToRun));
		scheduler.processAdded(processID);
	}

	public Collection<Process> getProcesses() {
		return processes.values();
	}

	public void update() {
		if(currentProcess != null) {
			currentProcess.update();
			if(currentProcess.isFinished()) {
				int processID = currentProcess.getID();
				processes.remove(processID);
				currentProcess = null;
				scheduler.processFinished(processID);
			}
		}
	}


/**
 * 
 * BELOW ARE THE OPERATIONS THE SCHEDULER SHOULD USE
 * 
 */

	public ProcessInfo getProcessInfo(int processID) {
		Process process = processes.get(processID);
		return new ProcessInfo(	process.getElapsedWaitingTime(),
								process.getElapsedExecutionTime(),
								process.getTotalServiceTime());
	}

	public void switchToProcess(int processID) {
		if(currentProcess != null) {
			currentProcess.stopRunning();
		}
		currentProcess = processes.get(processID);
		if(currentProcess != null) {
			currentProcess.startRunning();
		}
	}
}
