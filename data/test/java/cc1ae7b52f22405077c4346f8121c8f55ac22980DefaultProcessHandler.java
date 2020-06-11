package jetbrains.mps.execution.api.commands;

/*Generated by MPS */

import com.intellij.execution.process.OSProcessHandler;
import com.intellij.execution.process.ProcessListener;
import com.intellij.execution.process.ProcessTerminatedListener;

public class DefaultProcessHandler extends OSProcessHandler {
  public DefaultProcessHandler(Process process, String parameters, ProcessListener processListener) {
    super(process, parameters);
    addProcessListener(processListener);
    ProcessTerminatedListener.attach(this);
  }
  public DefaultProcessHandler(Process process, String parameters) {
    super(process, parameters);
    ProcessTerminatedListener.attach(this);
  }
}
