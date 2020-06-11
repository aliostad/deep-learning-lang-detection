package br.net.shima.utils.caffeinate;

public class CaffeinateWatcher implements Runnable
{
	private final CaffeinateRunner thread;
	private final Process process;

	public CaffeinateWatcher(CaffeinateRunner thread, Process process) {
		this.thread = thread;
		this.process = process;
	}

	@Override
	public void run() {
		this.getThread().setProcessNotRunning(this, waitForProcess());
	}

	public int waitForProcess() {
		int status = -1;
		try {
			status = getProcess().waitFor();
		} catch (InterruptedException e) {
		}
		return status;
	}

	public Process getProcess() {
		return this.process;
	}

	public CaffeinateRunner getThread() {
		return thread;
	}
}
