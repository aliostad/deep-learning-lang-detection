package jml.javax.safetycritical;

import jml.javax.safetycritical.MissionSequencer.State;
import jml.vm.Process;
import jml.vm.Scheduler;


final class CyclicSchedulerImpl implements Scheduler {

	@Override
	public Process getNextProcess() {
		ScjProcess scjProcess = CyclicScheduler.instance().getCurrentProcess();
		
		if (scjProcess.target instanceof MissionSequencer && 
		    ((MissionSequencer)(scjProcess.target)).currState == State.END)
		{
			CyclicScheduler.instance().stop(scjProcess.process);
		}

		return scjProcess.process;
	}
}
