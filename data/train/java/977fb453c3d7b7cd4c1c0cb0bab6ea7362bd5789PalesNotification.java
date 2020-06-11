package net.sf.pales;

public class PalesNotification {
	private ProcessHandle processHandle;
	private ProcessStatus processStatus;
	private long timestamp;
	
	public PalesNotification(ProcessHandle processHandle, ProcessStatus processStatus, long timestamp) {
		super();
		this.processHandle = processHandle;
		this.processStatus = processStatus;
		this.timestamp = timestamp;
	}
	
	public ProcessHandle getProcessHandle() {
		return processHandle;
	}
	
	public ProcessStatus getProcessStatus() {
		return processStatus;
	}
	
	void setProcessHandle(ProcessHandle processHandle) {
		this.processHandle = processHandle;
	}
	
	void setProcessStatus(ProcessStatus processStatus) {
		this.processStatus = processStatus;
	}
	
	public long getTimestamp() {
		return timestamp;
	}
	
	public void setTimestamp(long timestamp) {
		this.timestamp = timestamp;
	}
}
