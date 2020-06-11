/**
 * PRM scheduler implementation
 * 
 * @author Phillip Igoe & Nick Van Beek
 * 
 */
public class PRMScheduler extends Scheduler {

	/**
	 * Construct a PRM scheduler
	 * 
	 * @param processList
	 *            reference to the process list
	 */
	public PRMScheduler(ProcessList processList) {
		super(processList);
		this.readableName = "PRM"; // PI set the readable name
	}

	@Override
	public void schedule() {
		processList.incrementWaitTimeForProcessesInReadyQueue(); // NV increment the wait time for all processes in ready queue
		processList.decrementCurrentProcessesWaiting(currentProcess); // NV decrement the current processes waiting by looping through all processes in IO and decrmenting their IO time
		processList.moveWaitingToReady(); // NV moves all the processes that are waiting, and if the IO burst is less than or equal to 0, moves them to the ready queue

		if (currentProcess != null) { // PI ensure current process isn't null
			currentProcess.processInstruction(cpu.cycleCount);
		}

		if (processList.hasProcessInReadyQueue()) { // NV are there processes in the ready queue?
			if (currentProcess == null) { // PI ensure current process isn't null
				currentProcess = processWithShortestPeriod(null); // PI grab the process with the shortest CPU burst
			} else {
				if (currentProcess.isTerminated() || currentProcess.isWaiting()) { // NV is the current process terminated or waiting?
					currentProcess = processWithShortestPeriod(null); // PI grab the process with the shortest CPU burst
				} else if (processList.getProcessWithShortestPeriod(currentProcess).getPeriod() < currentProcess.getPeriod()) { // NV does the process we found have a lower period than the current processor's period?
					processList.addtoReadyQueue(currentProcess, this.cpu.cycleCount); // NV add the current process to the ready queue
					currentProcess = processWithShortestPeriod(currentProcess); // PI grab the process with the shortest CPU burst
				}
			}
		} else {
			if (currentProcess != null) { // PI ensure current process isn't null
				if (currentProcess.isTerminated() || currentProcess.isWaiting()) { // NV is the current process terminated or waiting?
					// current process could still be executing, so return it
					currentProcess = null;
				}
			} else {
				currentProcess = null;
			}
		}
	}

	/**
	 * PI take the process with the shortest period from the ready queue and return it
	 * 
	 * @return process
	 */
	private Process processWithShortestPeriod(Process p) {
		Process returnProcess = processList.takeProcessWithShortestPeriod(p); // PI take the process with the shortest period
		cpu.finalReport.addProcess(returnProcess); // PI add the current process to the final report
		return returnProcess;
	}

}
