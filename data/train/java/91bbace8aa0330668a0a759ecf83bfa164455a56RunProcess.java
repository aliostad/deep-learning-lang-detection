/**
 * Class that runs a specified process, and performs callback operations
 */
package project.ds.processmanager;

import project.ds.migratableprocess.MigratableProcess;

public class RunProcess implements Runnable{
	
	private MigratableProcess process;
	private ProcessCallback callback;
	private String threadId;
	
	public RunProcess(MigratableProcess p, ProcessCallback c, String t) {
		process = p;
		callback = c;
		threadId = t;
	}

	@Override
	public void run() {
		process.run();
		if(process.getFlag() == 1)
			callback.processSuspend(threadId); //Suspended case
		else
			callback.processEnd(threadId); //Process end case
	}

}
