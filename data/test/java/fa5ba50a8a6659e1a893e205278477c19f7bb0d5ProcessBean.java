package it.peruvianit.bean;

import java.io.Serializable;

public class ProcessBean implements Serializable {
	private static final long serialVersionUID = -2601088079208725178L;

	private Long startProcess;
	private Long endProcess;
	private String nameProcess;
	private Long elapsedTime;
	
	public Long getStartProcess() {
		return startProcess;
	}
	public void setStartProcess(Long startProcess) {
		this.startProcess = startProcess;
	}
	public Long getEndProcess() {
		return endProcess;
	}
	public void setEndProcess(Long endProcess) {
		this.endProcess = endProcess;
	}
	public String getNameProcess() {
		return nameProcess;
	}
	public void setNameProcess(String nameProcess) {
		this.nameProcess = nameProcess;
	}
	public Long getElapsedTime() {
		this.elapsedTime = this.endProcess - this.startProcess;
		
		return elapsedTime;
	}
	public void setElapsedTime(Long elapsedTime) {
		this.elapsedTime = elapsedTime;
	}
	
	{
		startProcess = 0L;
		endProcess = 0L;
		elapsedTime = 0L;
	}
}
