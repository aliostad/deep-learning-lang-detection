package com.paul.workflow.service.impl;

import org.activiti.engine.FormService;
import org.activiti.engine.HistoryService;
import org.activiti.engine.IdentityService;
import org.activiti.engine.ManagementService;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.springframework.beans.factory.annotation.Autowired;

import com.paul.workflow.plugins.service.ActivitiPluginService;
import com.paul.workflow.service.BaseService;

public class BaseServiceImpl implements BaseService{
	
	@Autowired
	private RepositoryService repositoryService;
	
	@Autowired
	private RuntimeService runtimeService;
	
	@Autowired
	private TaskService taskService;
	
	@Autowired
	private HistoryService historyService;
	
	@Autowired
	private ManagementService managementService;
	
	@Autowired
	private FormService formService;
	
	@Autowired
	private ActivitiPluginService activitiPluginService;
	
	@Autowired
	private IdentityService identityService;
	
	public RepositoryService getRepositoryService() {
		return repositoryService;
	}
	public void setRepositoryService(RepositoryService repositoryService) {
		this.repositoryService = repositoryService;
	}
	public RuntimeService getRuntimeService() {
		return runtimeService;
	}
	public void setRuntimeService(RuntimeService runtimeService) {
		this.runtimeService = runtimeService;
	}
	public TaskService getTaskService() {
		return taskService;
	}
	public void setTaskService(TaskService taskService) {
		this.taskService = taskService;
	}
	public HistoryService getHistoryService() {
		return historyService;
	}
	public void setHistoryService(HistoryService historyService) {
		this.historyService = historyService;
	}
	public ManagementService getManagementService() {
		return managementService;
	}
	public void setManagementService(ManagementService managementService) {
		this.managementService = managementService;
	}
	public FormService getFormService() {
		return formService;
	}
	public void setFormService(FormService formService) {
		this.formService = formService;
	}
	public ActivitiPluginService getActivitiPluginService() {
		return activitiPluginService;
	}
	public void setActivitiPluginService(ActivitiPluginService activitiPluginService) {
		this.activitiPluginService = activitiPluginService;
	}
	public IdentityService getIdentityService() {
		return identityService;
	}
	public void setIdentityService(IdentityService identityService) {
		this.identityService = identityService;
	}
	
}
