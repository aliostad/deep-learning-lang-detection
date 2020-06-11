package com.kensai.gui.services;

import com.kensai.gui.services.configuration.ConfigurationService;
import com.kensai.gui.services.connectors.PipelineFactoryService;
import com.kensai.gui.services.model.ModelService;
import com.kensai.gui.services.task.TaskService;


public class ApplicationContext {

	private ConfigurationService confService;
	private ModelService modelService;
	private TaskService taskService;
	private PipelineFactoryService pipelineFactoryService;

	public ApplicationContext(TaskService taskService, ConfigurationService confService, ModelService modelService,
		PipelineFactoryService pipelineFactoryService) {
		this.taskService = taskService;
		this.confService = confService;
		this.modelService = modelService;
		this.pipelineFactoryService = pipelineFactoryService;
	}

	public ConfigurationService getConfigurationService() {
		return confService;
	}

	public ModelService getModelService() {
		return modelService;
	}

	public TaskService getTaskService() {
		return taskService;
	}

	public PipelineFactoryService getPipelineFactoryService() {
		return pipelineFactoryService;
	}

}
