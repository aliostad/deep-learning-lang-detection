package com.dragonflow.siteview.websphere.util;

public class ProcessWaiter extends Thread
{
//  private static Log logger = LogFactory.getEasyLog(ProcessWaiter.class);
  RMIProcessProperties processProps;
  Process process;

  public ProcessWaiter(RMIProcessProperties p)
  {
    this.processProps = p;
    this.process = this.processProps.getProcess();
  }

  public ProcessWaiter(Process p) {
    this.processProps = null;
    this.process = p;
  }

  public void run() {
    boolean completed = false;
    while (!(completed)) {
      completed = waitForProcess();
    }
    if (this.process.exitValue() != 0) {
//      logger.error("Exit code of WebSphereService process was nonzero: " + this.process.exitValue());
    }

    if (this.processProps != null)
      this.processProps.setRunning(false);
  }

  private boolean waitForProcess()
  {
    try
    {
      this.process.waitFor();
    } catch (InterruptedException e) {
//      logger.error("Caught InterruptedException while waiting for WebSphereService Process, will wait again.");
      return false;
    }
    return true;
  }
}