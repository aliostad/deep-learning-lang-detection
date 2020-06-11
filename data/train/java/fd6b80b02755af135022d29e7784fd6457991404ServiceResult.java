package com.gduranti.processengine.model;

public class ServiceResult {

    private final ProcessInstance processInstance;
    private final ProcessStep doneStep;
    private ProcessStatus processStatus;
    private String argument;

    public ServiceResult(ProcessInstance processInstance) {
        this.processInstance = processInstance;
        this.doneStep = processInstance.getNextStep();
    }

    public ServiceResult withProcessStatus(ProcessStatus processStatus) {
        this.processStatus = processStatus;
        return this;
    }

    public ServiceResult withArgument(String argument) {
        this.argument = argument;
        return this;
    }

    public ProcessStep getDoneStep() {
        return doneStep;
    }

    public ProcessInstance getProcessInstance() {
        return processInstance;
    }

    public ProcessStatus getProcessStatus() {
        return processStatus;
    }

    public String getArgument() {
        return argument;
    }

}
