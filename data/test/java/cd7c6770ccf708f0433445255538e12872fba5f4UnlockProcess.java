package eu.sn7.unlocker;

import java.util.List;

import eu.sn7.unlocker.process.ProcessKiller;
import eu.sn7.unlocker.process.ProcessFinder;

public class UnlockProcess {
	private List<String> processIds;
	private ProcessFinder processListFinder;
	private ProcessKiller processKiller;

	public UnlockProcess(ProcessFinder processListFinder, ProcessKiller processKiller) {
		this.processListFinder = processListFinder;
		this.processKiller = processKiller;
	}

	public void unlock() {
		findProcessIds();
		killProcesses();
	}

	private void killProcesses() {
		for (String processId : processIds) {
			processKiller.killProcess(processId);
		}
	}

	private void findProcessIds() {
		try {
			processIds = processListFinder.findProcessIds();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public boolean hasKilledProcesses() {
		return processIds.size() > 0;
	}
}
