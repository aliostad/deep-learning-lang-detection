package jbpmdemo.test;

import junit.framework.Assert;

import org.jbpm.api.ExecutionService;
import org.jbpm.api.ProcessInstance;
import org.junit.Before;
import org.junit.Test;

public class ProcessInstanceTest extends TestBase {

    private ExecutionService executionService;

    @Override
    @Before
    public void setUp() {
        super.setUp();
        processEngine.getRepositoryService().createDeployment()//
                .addResourceFromClasspath("helloworld.jpdl.xml").deploy();
        executionService = processEngine.getExecutionService();
    }

    @Override
    @Test
    public void excute() {

        // 流程逐步运行
        ProcessInstance processInstance = executionService.startProcessInstanceByKey("helloworld");
        logger.debug(processInstance + " " + processInstance.findActiveActivityNames());

        processInstance = executionService.signalExecutionById(processInstance.getId());
        logger.debug(processInstance + " " + processInstance.findActiveActivityNames());

        processInstance = executionService.signalExecutionById(processInstance.getId());
        logger.debug(processInstance + " " + processInstance.findActiveActivityNames());
        Assert.assertTrue(processInstance.isEnded());
    }

    @Test
    public void setProcessToEnd() {

        ProcessInstance processInstance = executionService.startProcessInstanceByKey("helloworld");
        logger.debug(processInstance + " " + processInstance.findActiveActivityNames());

        processInstance = executionService.signalExecutionById(processInstance.getId());
        logger.debug(processInstance + " " + processInstance.findActiveActivityNames());

        processInstance = executionService.signalExecutionById(processInstance.getId());
        logger.debug(processInstance + " " + processInstance.findActiveActivityNames());

        // executionService.endProcessInstance(processInstance.getId(), "to end");
        // logger.debug(processInstance + " " + processInstance.findActiveActivityNames());

        Assert.assertTrue(processInstance.isEnded());
    }

}
