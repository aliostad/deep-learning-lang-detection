package de.spqrinfo.bpmn;

import org.activiti.engine.ProcessEngine;
import org.activiti.engine.ProcessEngineConfiguration;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.repository.DeploymentBuilder;
import org.activiti.engine.repository.ProcessDefinition;
import org.activiti.engine.repository.ProcessDefinitionQuery;
import org.activiti.engine.runtime.ProcessInstance;

/**
 * Simple main program for creating an Activiti Process Engine and automatic deployment of a BPMN2.0 filename
 * given as argument.
 */
public class Main {

    public static final String PROCESS_NAME = "brotkaufen";//"first";
    public static final String PROCESS_FILENAME = "brotkaufen.bpmn20.xml";//"first.bpmn20.xml";

    public static void main(String[] args) {
        ProcessEngine processEngine = null;
        try {
            processEngine = createProcessEngine();

            RepositoryService repositoryService = processEngine.getRepositoryService();
            DeploymentBuilder deploymentBuilder = repositoryService.createDeployment();

            deploymentBuilder.addClasspathResource(PROCESS_FILENAME);
            deploymentBuilder.deploy();

            System.out.println("------------------------------------");
            ProcessDefinitionQuery processDefinitionQuery = repositoryService.createProcessDefinitionQuery();
            for (ProcessDefinition proc : processDefinitionQuery.list()) {
                System.out.println(proc);
            }

            ProcessInstance processInstance = processEngine.getRuntimeService().startProcessInstanceByKey(PROCESS_NAME);
            

            System.out.println("ProcessInstance.isEnded " + processInstance.isEnded());

        } catch (Exception ex) {
            System.err.println("Caught exception: " + ex);
        } finally {
            processEngine.close();
            processEngine = null;
        }
    }

    private static ProcessEngine createProcessEngine() {
        ProcessEngineConfiguration processEngineConfiguration;
        ProcessEngine processEngine;

        processEngineConfiguration = ProcessEngineConfiguration.createStandaloneInMemProcessEngineConfiguration();
        processEngine = processEngineConfiguration.buildProcessEngine();

        return processEngine;
    }
}
