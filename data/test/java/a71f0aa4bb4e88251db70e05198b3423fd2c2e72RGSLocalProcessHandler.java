package codeOrchestra.rgs.local;

import com.intellij.execution.process.OSProcessHandler;
import com.intellij.execution.process.ProcessAdapter;
import com.intellij.execution.process.ProcessEvent;
import com.intellij.execution.process.ProcessTerminatedListener;
import jetbrains.mps.logging.Logger;

import java.security.Key;

/**
 * @author: Alexander Eliseyev
 */
public class RGSLocalProcessHandler extends OSProcessHandler {

  private static final Logger LOG = Logger.getLogger("LRGS");

  public RGSLocalProcessHandler(Process process, String params) {
    super(process, params);

    this.addProcessListener(new ProcessAdapter() {
      public void onTextAvailable(ProcessEvent event, Key k) {
        String text = event.getText();

        LOG.info(text); // TODO: delete

        System.out.println("[LRGS] " + text);
      }
    });
    ProcessTerminatedListener.attach(this);
  }

}
