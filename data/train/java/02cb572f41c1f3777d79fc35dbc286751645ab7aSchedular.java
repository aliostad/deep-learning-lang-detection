package spira.os.scheduler;

import java.util.ArrayList;
import java.util.List;

public class Schedular {
	// holds my list of processees

	private static final int QUANTUM = 10;

	List<FakeProcess> list;
	SchedulerAlgorithm algorithm;

	public Schedular(SchedulerAlgorithm algorithm) {
		this.algorithm = algorithm;
		list = new ArrayList<>();
	}

	public void run() {
		while (!list.isEmpty()) {

			FakeProcess process = algorithm.getNextProcess(list);
			list.remove(process);// remove from list
			if (algorithm.isPreemtive()) {
				process.run(QUANTUM);
				process.setTimeRan(System.currentTimeMillis());
				
				if (process.isStillRunning()) {
					list.add(process);
				}
			}
			else{
				process.run(process.getTimeToCompletion());
			}

		}
	}
	

	public void addProcess(FakeProcess process) {
		list.add(process);
	}
}
