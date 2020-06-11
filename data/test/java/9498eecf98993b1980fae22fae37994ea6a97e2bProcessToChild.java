package migratable.protocols;

import java.io.Serializable;

import migratable.processes.MigratableProcess;

/**
 * Created by Derek on 9/6/2014.
 *
 * The structure of a ProcessManager to ChildManager request.
 *
 */

public class ProcessToChild implements Serializable {
  private String command, name;
  private MigratableProcess process;

  public ProcessToChild(String command, String name, MigratableProcess process) {
    this.command = command;
    this.name = name;
    this.process = process;
  }

  public String getCommand() {
    return command;
  }

  public String getName() {
    return name;
  }

  public MigratableProcess getProcess() {
    return process;
  }
}
