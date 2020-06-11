package com.gduranti.processengine;

import javax.inject.Inject;

import com.gduranti.processengine.model.Process;
import com.gduranti.processengine.model.ProcessInstance;
import com.gduranti.processengine.model.ProcessType;
import com.gduranti.processengine.util.ProcessBuilder;

public class ProcessFacade {

    @Inject
    private ServiceExecutor serviceExecutor;

    @Inject
    private ProcessBuilder processBuilder;

    @Inject
    private ProcessRepository repository;

    public <T> ProcessInstance openProcess(ProcessType processType, T payload) {
        Process process = processBuilder.buildProcess(processType);
        return serviceExecutor.executeService(process.getInstances().get(0), payload);
    }

    public <T> ProcessInstance executeService(ProcessInstance processInstance, T payload) {
        return serviceExecutor.executeService(processInstance, payload);
    }

    public Process load(Long id) {
        return repository.load(id);
    }

}
