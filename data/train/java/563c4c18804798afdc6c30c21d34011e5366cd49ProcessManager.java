package laba1_example;

import java.util.ArrayList;
import java.util.List;

public class ProcessManager {
	private List<Process> processes = new ArrayList<Process>();
	
	public ProcessManager() {	}
	
	public void addNewProcess(Process process) {
		processes.add(process);
	}
	
	public void run() throws InterruptedException {
		int cvarks = 3;
		int current = 0;
		int activeProcess = 0;
		
		while(checkQueue()) {
			while(current < cvarks) {
				processes.get(activeProcess).step();
				current++;
			}
			current=0;
			
			activeProcess = changeActiveProcess(activeProcess);
		}
		
		System.out.println("All processes was completed!!!");
	}
	
	private int changeActiveProcess(int activeProcess) {		
		activeProcess++;
		
		while(processes.get(activeProcess).isCompleted()) {
			activeProcess++;
		}

		if(activeProcess >= (processes.size()-1)) {
			activeProcess = 0;
		}
		return activeProcess;
	}
	
	private boolean checkQueue() {
		
		for(Process process : processes) {
			if(!process.isCompleted()) { return true; }
		}
		
		return false;
	}

}
