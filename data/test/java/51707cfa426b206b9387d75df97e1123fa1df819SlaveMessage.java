package slave;

import java.io.Serializable;
import migratableProcess.ProcessStatus;
public class SlaveMessage implements Serializable {
	private static final long serialVersionUID = 9147196061382241902L;
	private ProcessStatus processStatus;
	private int pid;
	
	public void setProcessStatus(ProcessStatus processStatus) {
		this.processStatus = processStatus;
	}

	public void setPid(int pid) {
		this.pid = pid;
	}

	public SlaveMessage(ProcessStatus processStatus, int pid) {
		this.processStatus = processStatus;
		this.pid = pid;
	}
	
	public ProcessStatus getProcessStatus() {
		return processStatus;
	}

	public int getPid() {
        return pid;
    }
}
