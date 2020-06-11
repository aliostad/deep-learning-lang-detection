package migratable.protocols;

import java.io.Serializable;

import migratable.processes.MigratableProcess;

/**
 * Created by Derek on 9/6/2014.
 *
 * The structure of the response to a ProcessManager to ChildManager request.
 *
 */
public class ProcessToChildResponse implements Serializable {
  private boolean success;
  private MigratableProcess process;

  public ProcessToChildResponse(boolean success, MigratableProcess process) {
    this.success = success;
    this.process = process;
  }

  public boolean getSuccess() {
    return success;
  }

  public MigratableProcess getProcess() {
    return process;
  }
}
