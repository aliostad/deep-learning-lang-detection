package org.googlecode.jbpm4experiment.jbpm4struts2spring;

import java.util.List;

import org.jbpm.api.ProcessDefinition;
import org.jbpm.api.ProcessEngine;


public class ProcessAction {
    private ProcessEngine processEngine;
    private List<ProcessDefinition> processDefinitions;

    public String execute() {
        processEngine.getRepositoryService().createDeployment()
                     .addResourceFromClasspath("StartEnd.jpdl.xml").deploy();
        processDefinitions = processEngine.getRepositoryService()
                                          .createProcessDefinitionQuery()
                                          .list();

        return "success";
    }

    public void setProcessEngine(ProcessEngine processEngine) {
        this.processEngine = processEngine;
    }

    public List<ProcessDefinition> getProcessDefinitions() {
        return processDefinitions;
    }
}
