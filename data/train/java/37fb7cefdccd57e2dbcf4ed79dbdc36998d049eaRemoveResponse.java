package message;

import migratableprocess.MigratableProcess;

public class RemoveResponse extends ResponseMessage {

	private static final long serialVersionUID = -97425729473316935L;
	private MigratableProcess mProcess;
	
	public RemoveResponse(boolean success, MigratableProcess process) {
		super(success);
		mProcess = process;
	}
	
	/**
	 * This handles the process dead case, a dead process is signaled with mProcess = null 
	 * @param success
	 * @param process
	 */
	public RemoveResponse(boolean success) {
		super(success);
		mProcess = null;
	}
	
	public MigratableProcess getProcess() {
		return mProcess;
	}
	
	public boolean isProcessAlive() {
		return mProcess != null;
	}

}
