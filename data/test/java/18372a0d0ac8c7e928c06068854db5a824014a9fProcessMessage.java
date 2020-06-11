package process;

import models.Process;

/**
 * Class used to send the message from Manager 
 * to Worker to execute the process 
 */
public class ProcessMessage {

	private Process process = null;
	private Integer index = null;
	
	
	public ProcessMessage(Integer index) {
		this.index = index;
	}

	
	public ProcessMessage(Integer index, Process process) {
		this.index = index;
		this.process = process;
	}

	
	public Integer getIndex() {
		return index;
	}


	public void setIndex(Integer index) {
		this.index = index;
	}


	public Process getProcess() {
		return process;
	}

	
	public void setProcess(Process process) {
		this.process = process;
	}
}
