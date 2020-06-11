/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ac.at.fhkufstein.activiti;

import org.activiti.engine.FormService;
import org.activiti.engine.ProcessEngine;
import org.activiti.engine.ProcessEngineConfiguration;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.designer.test.ProcessTestMyProcess;

/**
 *
 * @author mike
 */

public class Services {

    private static ProcessEngine processEngine;

    static {
        instantiateProcessEngine();

//        if(getRepositoryService().createProcessDefinitionQuery().processDefinitionKey(InvitationProcess.PROCESS_DEFINITION).list().isEmpty()) {
        for (String process : ProcessTestMyProcess.PROCESSES) {
            getRepositoryService().createDeployment()
                    .addClasspathResource(ProcessTestMyProcess.PROCESS_FILE_LOCATION + process + ProcessTestMyProcess.SUFFIX)
                    .deploy();
            System.out.println("Process "+process+" deployed");
        }
//        }

    }
    
    public static void testProcess() {
        Services.getRuntimeService().createProcessInstanceQuery().processInstanceId("83923").singleResult();
        
        System.out.println("Process tested");
    }

    private static void instantiateProcessEngine() {
        processEngine = ProcessEngineConfiguration.createProcessEngineConfigurationFromResourceDefault().buildProcessEngine();
    }

    public static RuntimeService getRuntimeService() {
        return processEngine.getRuntimeService();
    }

    public static RepositoryService getRepositoryService() {
        return processEngine.getRepositoryService();
    }

    public static TaskService getTaskService() {
        return processEngine.getTaskService();
    }

    public static FormService getFormService() {
        return processEngine.getFormService();
    }
}
