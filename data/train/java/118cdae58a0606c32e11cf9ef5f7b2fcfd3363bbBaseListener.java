package com.reed.workflow.listener;

import org.activiti.engine.FormService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

public abstract class BaseListener {
	/** Logger */
	static final Logger LOGGER = LoggerFactory.getLogger(BaseListener.class);

	@Autowired
	private TaskService taskService;

	@Autowired
	private FormService formService;

	@Autowired
	private RuntimeService runTimeService;

	public TaskService getTaskService() {
		return taskService;
	}

	public void setTaskService(TaskService taskService) {
		this.taskService = taskService;
	}

	public FormService getFormService() {
		return formService;
	}

	public void setFormService(FormService formService) {
		this.formService = formService;
	}

	public RuntimeService getRunTimeService() {
		return runTimeService;
	}

	public void setRunTimeService(RuntimeService runTimeService) {
		this.runTimeService = runTimeService;
	}

}
