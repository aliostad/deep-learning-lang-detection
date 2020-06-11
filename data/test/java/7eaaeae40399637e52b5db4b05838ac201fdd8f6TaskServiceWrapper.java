package com.rongdu.eloan.modules.workflow.utils.strategy;

import org.activiti.engine.TaskService;

/**
 * 对activiti原生API的一层包装，避免高层设计直接直接与activiti耦合
 * @author FHJ
 *
 */
public class TaskServiceWrapper {
	private TaskService taskService;

	public TaskServiceWrapper(TaskService taskService) {
		this.taskService = taskService;
	}
	
	public TaskService getTaskService() {
		return taskService;
	}

	public void setTaskService(TaskService taskService) {
		this.taskService = taskService;
	}
	
}
