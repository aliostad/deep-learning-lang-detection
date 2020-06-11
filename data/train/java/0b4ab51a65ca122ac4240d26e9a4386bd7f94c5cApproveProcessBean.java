package com.pinhuba.common.module;

import org.activiti.engine.repository.ProcessDefinition;
import com.pinhuba.core.pojo.SysProcessConfig;

public class ApproveProcessBean {
	private ProcessDefinition processDefinition;
	private String deploymentTime;
	private SysProcessConfig config;

	public ProcessDefinition getProcessDefinition() {
		return processDefinition;
	}

	public void setProcessDefinition(ProcessDefinition processDefinition) {
		this.processDefinition = processDefinition;
	}

	public String getDeploymentTime() {
		return deploymentTime;
	}

	public void setDeploymentTime(String deploymentTime) {
		this.deploymentTime = deploymentTime;
	}

	public SysProcessConfig getConfig() {
		return config;
	}

	public void setConfig(SysProcessConfig config) {
		this.config = config;
	}
}
