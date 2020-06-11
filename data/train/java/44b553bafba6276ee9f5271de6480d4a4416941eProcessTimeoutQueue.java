package org.dclayer.net.process.queue;

import java.util.ArrayList;

import org.dclayer.listener.net.OnProcessTimeoutListener;
import org.dclayer.net.process.template.Process;

/**
 * a queue for timeout {@link Process}es, calls {@link OnProcessTimeoutListener#onProcessTimeout(Process)} of the {@link OnProcessTimeoutListener} passed to the constructor when a {@link Process} times out
 */
public class ProcessTimeoutQueue extends Thread {
	/**
	 * a class holding a {@link Process} and a timestamp specifying when it times out
	 */
	private class ProcessTime {
		Process process;
		long time;
		ProcessTime(Process process, long time) {
			this.process = process;
			this.time = time;
		}
	}
	
	/**
	 * the {@link OnProcessTimeoutListener} to call on timeout
	 */
	private OnProcessTimeoutListener onProcessTimeoutListener;
	
	/**
	 * {@link ArrayList} containing the timeout {@link Process}es
	 */
	private ArrayList<ProcessTime> processes = new ArrayList<ProcessTime>();
	/**
	 * the timestamp of the next timeout of a process
	 */
	private long time;
	
	public ProcessTimeoutQueue(OnProcessTimeoutListener onProcessTimeoutListener) {
		this.onProcessTimeoutListener = onProcessTimeoutListener;
		this.start();
	}
	
	/**
	 * adds a new Process to time out after the given amount of time
	 * @param process the {@link Process} to time out
	 * @param timeout the time until the {@link Process} times out, in milliseconds
	 */
	public void add(Process process, long timeout) {
		ProcessTime pt = new ProcessTime(process, System.currentTimeMillis() + timeout);
		synchronized(this) {
			processes.add(pt);
			if(time > pt.time) {
				// the new Process needs to be executed sooner than any of the other queued Processes
				this.interrupt();
			}
		}
	}
	
	public void run() {
		for(;;) {
			long delay = 1000, now;
			clean: for(;;) {
				now = System.currentTimeMillis();
				Process process = null;
				synchronized(this) {
					search: for(ProcessTime pt : processes) {
						if(pt.time < now) {
							process = pt.process;
							processes.remove(pt);
							break search;
						}
					}
				}
				if(process == null) break;
				else {
					onProcessTimeoutListener.onProcessTimeout(process);
				}
			}
			long nexttime = now+delay;
			for(ProcessTime pt : processes) {
				if(pt.time < nexttime) {
					nexttime = pt.time;
					delay = pt.time - now;
				}
			}
			synchronized (this) {
				this.time = nexttime;
			}
			try {
				Thread.sleep(delay);
			} catch (InterruptedException e) {}
		}
	}
}
