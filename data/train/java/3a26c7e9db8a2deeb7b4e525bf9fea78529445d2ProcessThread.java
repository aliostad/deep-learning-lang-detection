package migratable.processes;

/**
 * Created by Derek on 9/7/2014.
 */
public class ProcessThread {
  MigratableProcess process;
  Thread thread;

  public ProcessThread(MigratableProcess process, Thread thread) {
    this.process = process;
    this.thread = thread;
  }

  public MigratableProcess getProcess() {
    return process;
  }

  public Thread getThread() {
    return thread;
  }

  public void setProcess(MigratableProcess process) {
    this.process = process;
  }

  public void setThread(Thread thread) {
    this.thread = thread;
  }
}
