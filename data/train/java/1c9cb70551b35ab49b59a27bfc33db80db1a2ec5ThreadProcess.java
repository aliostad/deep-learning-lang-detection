package processes;
import interfaces.MigratableProcess;

/**
 * A helper class type that is used to enclose a migratable
 * process and the thread that is running that process
 *
 */
public class ThreadProcess {
	
	private MigratableProcess p;
	private Thread t;
	
	public ThreadProcess(Thread t, MigratableProcess p) {
		this.t = t;
		this.p = p;
	}
	
	/**
	 * Get thread running the process
	 * @return
	 */
	public Thread getThread() {
		return t;
	}
	
	/**
	 * Get process running here
	 * @return
	 */
	public MigratableProcess getProcess() {
		return p;
	}
	
	/**
	 * Check if the thread running the process is alive
	 * @return
	 */
	public boolean threadIsAlive() {
		return t.isAlive();
	}	
}