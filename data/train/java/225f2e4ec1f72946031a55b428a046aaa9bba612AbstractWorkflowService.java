package me.kafeitu.activiti.jpa.service.base;

import me.kafeitu.activiti.jpa.service.RuntimeJpaService;

import org.activiti.engine.FormService;
import org.activiti.engine.HistoryService;
import org.activiti.engine.IdentityService;
import org.activiti.engine.ManagementService;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * 抽象工作流Service，提供一些常用的方法以及需要子类实现的方法
 *
 * @author HenryYan
 */
public abstract class AbstractWorkflowService {

	protected Logger logger = LoggerFactory.getLogger(getClass());

	//-- seven service interface --//
	protected RuntimeService runtimeService;
	protected TaskService taskService;
	protected RepositoryService repositoryService;
	protected HistoryService historyService;
	protected IdentityService identityService;
	protected FormService formService;
	protected ManagementService managementService;
	
	//-- seven service interface for jpa --//
	protected RuntimeJpaService runtimeJpaService;

	@Autowired
	public void setRuntimeService(RuntimeService runtimeService) {
		this.runtimeService = runtimeService;
	}

	@Autowired
	public void setTaskService(TaskService taskService) {
		this.taskService = taskService;
	}

	@Autowired
	public void setRepositoryService(RepositoryService repositoryService) {
		this.repositoryService = repositoryService;
	}

	@Autowired
	public void setHistoryService(HistoryService historyService) {
		this.historyService = historyService;
	}

	@Autowired
	public void setIdentityService(IdentityService identityService) {
		this.identityService = identityService;
	}

	@Autowired
	public void setFormService(FormService formService) {
		this.formService = formService;
	}

	@Autowired
	public void setManagementService(ManagementService managementService) {
		this.managementService = managementService;
	}

	@Autowired
	public void setRuntimeJpaService(RuntimeJpaService runtimeJpaService) {
		this.runtimeJpaService = runtimeJpaService;
	}
	
	public abstract void flush();

}
