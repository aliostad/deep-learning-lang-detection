package br.uff.ic.provmonitor.model;

public class ProcessInstance {
	private String instanceId;
	private String processId;
	private String processName;
	private String swfmsId;
	
	public String getInstanceId() {
		return instanceId;
	}
	public void setInstanceId(String instanceId) {
		this.instanceId = instanceId;
	}
	public String getProcessId() {
		return processId;
	}
	public void setProcessId(String processId) {
		this.processId = processId;
	}
	public String getProcessName() {
		return processName;
	}
	public void setProcessName(String processName) {
		this.processName = processName;
	}
	public String getSwfmsId() {
		return swfmsId;
	}
	public void setSwfmsId(String swfmsId) {
		this.swfmsId = swfmsId;
	}
	
	
}
