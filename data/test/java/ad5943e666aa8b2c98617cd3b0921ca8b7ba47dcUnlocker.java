package eu.sn7.unlocker;

import eu.sn7.unlocker.process.ProcessFinder;
import eu.sn7.unlocker.process.ProcessKiller;

public class Unlocker {
	private ProcessFinder processListFinder;
	private ProcessKiller processKiller;
	private int numberOfTries;

	public Unlocker(ProcessFinder processListFinder, ProcessKiller processKiller, int numberOfTries) {
		this.processListFinder = processListFinder;
		this.processKiller = processKiller;
		this.numberOfTries = numberOfTries;
	}

	public void unlock() {
		UnlockProcess unlockProcess = new UnlockProcess(processListFinder, processKiller);
		unlockProcess.unlock();

		numberOfTries--;

		retryUnlockIfNecessary(unlockProcess);
	}

	private void retryUnlockIfNecessary(UnlockProcess unlockProcess) {
		if (unlockProcess.hasKilledProcesses() && numberOfTries > 0) {
			unlock();
		}
	}
}
