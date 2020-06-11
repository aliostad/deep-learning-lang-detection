package cn;

import org.activiti.engine.ProcessEngine;
import org.activiti.engine.ProcessEngines;
import org.activiti.engine.history.HistoricProcessInstance;
import org.junit.Test;

/**
 * Created by max.lu on 2016/3/17.
 */
public class HistoryTest {

    @Test
    public void queryHistoryProcess() {
        ProcessEngine processEngine = ProcessEngines.getDefaultProcessEngine();
        HistoricProcessInstance historicProcessInstance = processEngine.getHistoryService().createHistoricProcessInstanceQuery().processInstanceId("40001").singleResult();
        System.out.println(historicProcessInstance.getId());
        System.out.println(historicProcessInstance.getProcessDefinitionId());
        System.out.println(historicProcessInstance.getStartTime());
        System.out.println(historicProcessInstance.getDurationInMillis());
    }
}
