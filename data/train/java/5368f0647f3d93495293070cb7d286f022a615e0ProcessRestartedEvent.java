package org.sapia.corus.client.services.processor.event;

import org.sapia.corus.client.services.deployer.dist.Distribution;
import org.sapia.corus.client.services.deployer.dist.ProcessConfig;

/**
 * Signals that the Corus server has restarted a non-responding process.
 * 
 * @author yduchesne
 * 
 */
public class ProcessRestartedEvent {

  private Distribution distribution;
  private ProcessConfig process;

  public ProcessRestartedEvent(Distribution dist, ProcessConfig process) {
    this.distribution = dist;
    this.process = process;
  }

  public Distribution getDistribution() {
    return distribution;
  }

  public ProcessConfig getProcess() {
    return process;
  }

}
