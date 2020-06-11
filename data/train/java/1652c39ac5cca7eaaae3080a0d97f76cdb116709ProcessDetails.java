package com.tavant.domain;

public class ProcessDetails {

	private int processId;
	
	private String processName;
	
	private String processDescription;
	
	public ProcessDetails(int processId, String processName, String processDescription){
		this.processId = processId;
		this.processName = processName;
		this.processDescription = processDescription;
	}

	public int getProcessId() {
		return processId;
	}

	public void setProcessId(int processId) {
		this.processId = processId;
	}

	public String getProcessName() {
		return processName;
	}

	public void setProcessName(String processName) {
		this.processName = processName;
	}

	public String getProcessDescription() {
		return processDescription;
	}

	public void setProcessDescription(String processDescription) {
		this.processDescription = processDescription;
	}
}
