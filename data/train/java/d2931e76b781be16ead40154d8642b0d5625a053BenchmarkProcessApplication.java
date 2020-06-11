package org.camunda.bpm.examples;

import java.util.List;

import org.camunda.bpm.application.PostDeploy;
import org.camunda.bpm.application.ProcessApplication;
import org.camunda.bpm.application.impl.ServletProcessApplication;
import org.camunda.bpm.engine.ProcessEngine;
import org.camunda.bpm.engine.RuntimeService;
import org.camunda.bpm.engine.repository.ProcessDefinition;

/**
 * Process Application exposing this application's resources the process engine. 
 */
@ProcessApplication
public class BenchmarkProcessApplication extends ServletProcessApplication {

  @PostDeploy
  public void onDeploymentFinished(ProcessEngine processEngine) {
    // start every deployed process as warm-up

    List<ProcessDefinition> processDefinitions = processEngine.getRepositoryService().createProcessDefinitionQuery().list();

    RuntimeService runtimeService = processEngine.getRuntimeService();
    for (ProcessDefinition processDefinition : processDefinitions) {
      runtimeService.startProcessInstanceById(processDefinition.getId());
    }
  }

}
