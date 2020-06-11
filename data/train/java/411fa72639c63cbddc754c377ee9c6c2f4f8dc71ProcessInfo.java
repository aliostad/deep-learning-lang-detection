package project1;

public class ProcessInfo {
	
	private int processID;
	private String processName;
	private int slaveID;
	private Enum<Status> status;
	private long time;
	private MigratableProcess process;
	
	public ProcessInfo (MigratableProcess process, int processID, String processName, int slaveID, Enum<Status> status) {
		this.process = process;
		this.processID = processID;
		this.processName = processName;
		this.slaveID = slaveID;
		this.status = status;
	}
	
	public enum Status {
	    INITIALIZING, RUNNING, SUSPENDING, TERNIMATED
	}
	
	public int getProcessID() {
		return processID;
	}
	public void setProcessID(int processID) {
		this.processID = processID;
	}

	public String getProcessName() {
		return processName;
	}
	public void setProcessName(String processName) {
		this.processName = processName;
	}
	public int getSlaveID() {
		return slaveID;
	}
	public void setSlaveID(int slaveID) {
		this.slaveID = slaveID;
	}
	
	public Enum<Status> getStatus() {
		return status;
	}
	public void setStatus(Enum<Status> status) {
		this.status = status;
	}
	public long getTime() {
		return time;
	}
	public void setTime(long time) {
		this.time = time;
	}
	public MigratableProcess getProcess() {
		return process;
	}
	public void setProcess(MigratableProcess process) {
		this.process = process;
	}
	
	
	
	

}
