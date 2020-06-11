package frank.incubator.testgrid.common;

import org.apache.commons.exec.ExecuteWatchdog;
import org.slf4j.Logger;

public class ProcessTreeWatchDog extends ExecuteWatchdog {

	public ProcessTreeWatchDog(long timeout) {
		super(timeout);
	}
	
	public ProcessTreeWatchDog(long timeout, Logger log) {
		super(timeout);
		this.log = log;
	}

	private Logger log;
	
	private Process rootProcess;

	public Process getRootProcess() {
		return rootProcess;
	}
	
	private int pid;

	@Override
	public synchronized void start(final Process processToMonitor) {
		rootProcess = processToMonitor;
		pid = CommonUtils.getPid(processToMonitor);
		super.start(processToMonitor);
		if(log != null) {
			log.info("start monitor process:"+ pid);
		}
	}

	@Override
	public void destroyProcess() {
		if(log != null) {
			log.info("begin to destroy process:"+ pid);
		}
		try {
			if (rootProcess != null) {
				CommonUtils.killProcess(pid, true, log);
			}
		} catch (Throwable e) {
			e.printStackTrace();
			log.error("kill process failed.pid:" + pid, e);
		}
		try {
			super.destroyProcess();
		} catch (Throwable e) {
			e.printStackTrace();
			log.error("kill super process failed.pid:" + pid, e);
		}
	}
}
