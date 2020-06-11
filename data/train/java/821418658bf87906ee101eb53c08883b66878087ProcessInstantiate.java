package com.xiaoy.core.bpm.engine.entity;
/**
 * 流程实例
 * 不进行持久化
 * @author 
 *
 */
public class ProcessInstantiate {
	
	private String processInstanceId;
	private String processDefineId;
	
	
	public String getProcessDefineId() {
		return processDefineId;
	}

	public void setProcessDefineId(String processDefineId) {
		this.processDefineId = processDefineId;
	}

	public String getProcessInstanceId() {
		return processInstanceId;
	}

	public void setProcessInstanceId(String processInstanceId) {
		this.processInstanceId = processInstanceId;
	}
	
	
}
