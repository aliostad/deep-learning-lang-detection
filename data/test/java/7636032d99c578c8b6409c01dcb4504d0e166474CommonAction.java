package com.ces.common.action;

import org.activiti.engine.FormService;
import org.activiti.engine.HistoryService;
import org.activiti.engine.IdentityService;
import org.activiti.engine.ManagementService;
import org.activiti.engine.ProcessEngine;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;

import com.ces.framework.action.BaseAction;

public class CommonAction extends BaseAction {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected ProcessEngine processEngine;
	
	protected RepositoryService repositoryService;
	protected RuntimeService runtimeService;
	protected TaskService taskService;
	protected IdentityService identityService;
	protected FormService formService;
	protected HistoryService historyService;
	
	protected ManagementService managementService;

	public void setProcessEngine(ProcessEngine processEngine) {
		this.processEngine = processEngine;
	}

	public void setRepositoryService(RepositoryService repositoryService) {
		this.repositoryService = repositoryService;
	}

	public void setRuntimeService(RuntimeService runtimeService) {
		this.runtimeService = runtimeService;
	}

	public void setTaskService(TaskService taskService) {
		this.taskService = taskService;
	}

	public void setIdentityService(IdentityService identityService) {
		this.identityService = identityService;
	}

	public void setFormService(FormService formService) {
		this.formService = formService;
	}

	public void setHistoryService(HistoryService historyService) {
		this.historyService = historyService;
	}

	public void setManagementService(ManagementService managementService) {
		this.managementService = managementService;
	}
}
