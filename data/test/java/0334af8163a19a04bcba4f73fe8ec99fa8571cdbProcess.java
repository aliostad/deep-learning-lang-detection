package com.itour.etip.pub.kit.jbpm;

public class Process implements java.io.Serializable{
	private String processName;
	private String processVersion;
	private ProcessTask[] tasks;
	private ProcessTransition[] transitions;
	public String getProcessName() {
		return processName;
	}
	public void setProcessName(String processName) {
		this.processName = processName;
	}
	public String getProcessVersion() {
		return processVersion;
	}
	public void setProcessVersion(String processVersion) {
		this.processVersion = processVersion;
	}
	public ProcessTask[] getTasks() {
		return tasks;
	}
	public void setTasks(ProcessTask[] tasks) {
		this.tasks = tasks;
	}
	public ProcessTransition[] getTransitions() {
		return transitions;
	}
	public void setTransitions(ProcessTransition[] transitions) {
		this.transitions = transitions;
	}
	
}
