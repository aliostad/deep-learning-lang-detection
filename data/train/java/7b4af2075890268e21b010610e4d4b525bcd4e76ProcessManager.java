package jun.practice.microsoft;

import java.util.ArrayList;
import java.util.PriorityQueue;

public class ProcessManager {
	
	final int PROCESS_TRUNK_SIZE = 256;
	int nextProcessId = 0;
	
	class Process {
		
	}
	
	ArrayList<Process[]> active = new ArrayList<Process[]>();
	PriorityQueue<Integer> available = new PriorityQueue<Integer>();
	
	int allocateProcessId(Process process) {
		int processId = nextProcessId;
		if (available.size() > 0) {
			processId = available.poll();
		} else {
			if (active.size() <= nextProcessId/PROCESS_TRUNK_SIZE) {
				active.add(new Process[PROCESS_TRUNK_SIZE]);
			}
			++nextProcessId;
		}
		active.get(processId/PROCESS_TRUNK_SIZE)[processId%PROCESS_TRUNK_SIZE] = process;
		return processId;
	}
	
	Process findProcess(int processId) {
		try {
			return active.get(processId/PROCESS_TRUNK_SIZE)[processId%PROCESS_TRUNK_SIZE];
		} catch (Exception e) {
			// processId not valid.
		}
		return null;
	}
	
	void releaseProcess(int processId) {
		// release process...
		active.get(processId/PROCESS_TRUNK_SIZE)[processId%PROCESS_TRUNK_SIZE] = null;
		available.add(processId);
	}

}
