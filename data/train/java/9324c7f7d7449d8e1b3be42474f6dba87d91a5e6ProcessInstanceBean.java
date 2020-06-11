package com.centling.common.module;

import org.activiti.engine.runtime.ProcessInstance;

public class ProcessInstanceBean {
	private ProcessInstance processInstance;
	private String nodeName;
	
	public ProcessInstance getProcessInstance() {
		return processInstance;
	}
	public void setProcessInstance(ProcessInstance processInstance) {
		this.processInstance = processInstance;
	}
	public String getNodeName() {
		return nodeName;
	}
	public void setNodeName(String nodeName) {
		this.nodeName = nodeName;
	}
}
