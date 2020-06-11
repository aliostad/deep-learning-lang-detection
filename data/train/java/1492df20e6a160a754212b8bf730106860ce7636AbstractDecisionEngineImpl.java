package io.onedecision.engine.decisions.impl;

import io.onedecision.engine.decisions.api.DecisionEngine;
import io.onedecision.engine.decisions.api.ModelingService;
import io.onedecision.engine.decisions.api.RepositoryService;
import io.onedecision.engine.decisions.api.RuntimeService;

public abstract class AbstractDecisionEngineImpl implements DecisionEngine {

    protected ModelingService modelingService;

    protected RepositoryService repositoryService;

    protected RuntimeService runtimeService;

    public ModelingService getModelingService() {
        return modelingService;
    }

    public DecisionEngine setModelingService(ModelingService modelingService) {
        this.modelingService = modelingService;
        return this;
    }

    public RepositoryService getRepositoryService() {
        return repositoryService;
    }

    public DecisionEngine setRepositoryService(
            RepositoryService repositoryService) {
        this.repositoryService = repositoryService;
        return this;
    }

    public RuntimeService getRuntimeService() {
        return runtimeService;
    }

    public DecisionEngine setRuntimeService(RuntimeService runtimeService) {
        this.runtimeService = runtimeService;
        return this;
    }

}
