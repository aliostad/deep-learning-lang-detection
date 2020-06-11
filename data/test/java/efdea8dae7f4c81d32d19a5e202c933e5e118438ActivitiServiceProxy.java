package com.myfeike.activiti.proxy;

import org.activiti.engine.*;
import org.activiti.engine.impl.ServiceImpl;
import org.springframework.transaction.PlatformTransactionManager;

/**
 * Created by izerui.com on 14-5-4.
 */
public class ActivitiServiceProxy extends ServiceImpl{
    protected RepositoryService repositoryService;
    protected RuntimeService runtimeService;
    protected TaskService taskService;
    protected FormService formService;
    protected HistoryService historyService;
    protected ManagementService managementService;
    protected IdentityService identityService;
    protected PlatformTransactionManager transactionManager;


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

    public FormService getFormService() {
        return formService;
    }

    public void setFormService(FormService formService) {
        this.formService = formService;
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

    public IdentityService getIdentityService() {
        return identityService;
    }

    public void setIdentityService(IdentityService identityService) {
        this.identityService = identityService;
    }

    public void setTransactionManager(PlatformTransactionManager transactionManager) {
        this.transactionManager = transactionManager;
    }
}
