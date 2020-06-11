package processes;

import java.util.ArrayList;
import java.util.List;

public class ProcessManager implements IProcessManager {

	private List<Process> processList;
	private List<Process> processQueue;

	public ProcessManager() {
		processList = new ArrayList<Process>();
		processQueue = new ArrayList<Process>();
	}
	
	@Override
	public void addProcess(Process p) {
		processQueue.add(p);
	}

	@Override
	public void update(long nanoSeconds) {
		processList.addAll(processQueue);
		processQueue.clear();
		List<Process> toRemove = new ArrayList<Process>();
		for (Process p: processList) {
			if (!p.isInitialized()) {
				p.initialize();
			}
			if (p.isRunning()) {
				p.update(nanoSeconds);
			}
			if (p.isDead()) {
				if (p.isFinished() && p.getChild() != null) {
					processQueue.add(p.getChild());
				}
				toRemove.add(p);
			}
		}
		processList.removeAll(toRemove);
	}

	@Override
	public void clearProcesses(boolean executeExitMethod) {
		if (executeExitMethod) {
			for (Process p : processList) {
				p.onAbort();
			}
		}
		processList.clear();
		processQueue.clear();
	}

}
