package org.vamdc.portal.session.controller.process;

public class ProcessDefinition {
	
	private String processName;
	private String processCode;
	private String processDescription;
	private String iaeaCode;
	public String getProcessName() {
		return processName;
	}
	public void setProcessName(String processName) {
		this.processName = processName;
	}
	public String getProcessCode() {
		return processCode;
	}
	public void setProcessCode(String processCode) {
		this.processCode = processCode;
	}
	public String getProcessDescription() {
		return processDescription;
	}
	public void setProcessDescription(String processDescription) {
		this.processDescription = processDescription;
	}
	public String getIaeaCode() {
		return iaeaCode;
	}
	public void setIaeaCode(String iaeaCode) {
		this.iaeaCode = iaeaCode;
	}

}
