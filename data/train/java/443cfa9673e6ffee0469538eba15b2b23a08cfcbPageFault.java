/**
 * COMP2240 Assignment 3
 * @author Simon Hartcher
 * @studentno c3185790
 */

package system;

public class PageFault {
  private Process process;
  private int tick;

  public PageFault(Process process, int tick) {
    this.process = process;
    this.tick = tick;
  }

  public Process getProcess() {
    return this.process;
  }

  public void setProcess(Process process) {
    this.process = process;
  }

  public int getTick() {
    return this.tick;
  }

  public void setTick(int tick) {
    this.tick = tick;
  }
}
