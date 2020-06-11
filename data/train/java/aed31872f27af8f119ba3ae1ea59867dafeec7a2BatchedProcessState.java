
package hu.rgai.yako.beens;

public class BatchedProcessState {

  private int mProcessDone;
  private final int mTotalProcess;

  public BatchedProcessState(int mTotalProcess) {
    this.mProcessDone = 0;
    this.mTotalProcess = mTotalProcess;
  }

  public int getProcessDone() {
    return mProcessDone;
  }

  public int getTotalProcess() {
    return mTotalProcess;
  }

  public void increaseDoneProcesses() {
    this.mProcessDone++;
  }
  
  public boolean isDone() {
    return mProcessDone == mTotalProcess;
  }

  @Override
  public String toString() {
    return "BatchedProcessState{" + "mProcessDone=" + mProcessDone + ", mTotalProcess=" + mTotalProcess + '}';
  }
  
}
