package com.paul.workflow.service;

import org.activiti.engine.FormService;
import org.activiti.engine.HistoryService;
import org.activiti.engine.IdentityService;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;

import com.paul.workflow.plugins.service.ActivitiPluginService;

public interface BaseService {
	public RuntimeService getRuntimeService();
	public TaskService getTaskService();
	public HistoryService getHistoryService();
	public FormService getFormService();
	public ActivitiPluginService getActivitiPluginService();
//	public ActFlowDao getActFlowDao();
	public RepositoryService getRepositoryService();
	public IdentityService getIdentityService();
}
