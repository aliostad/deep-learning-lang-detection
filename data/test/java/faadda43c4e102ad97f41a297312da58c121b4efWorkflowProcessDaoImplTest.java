package org.wf.testcase;

import java.sql.Timestamp;
import java.util.Date;

import javax.annotation.Resource;

import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;
import org.wf.dao.activiti.WorkflowProcessDao;
import org.wf.service.model.ProcessStatusEnum;
import org.wf.service.model.WorkflowProcess;

@RunWith(SpringJUnit4ClassRunner.class)
@TransactionConfiguration(transactionManager = "transactionManager", defaultRollback = true)
@Transactional
@ContextConfiguration(value = {"classpath:spring/config/applicationContext-all-wf.xml"})
public class WorkflowProcessDaoImplTest {
	
	@Resource(name = "workflowProcessDao")
	private WorkflowProcessDao workflowProcessDao;
	
	final String innerProcessId = "123abc";
	
	@Test
	public void testInsert(){
		WorkflowProcess process = new WorkflowProcess();
		// set fields
		process.setInnerProcessId(innerProcessId);
		process.setAcceptTimeStamp(new Timestamp(new Date().getTime()));
		process.setInitUserName("Jack");
		process.setOuterSequenceId("234asfsfdas");
		process.setProcessDetail("some desc here, a new incoming process.");
		process.setProcessModelKey("Review-company-request-pos");
		process.setSourceSystem("myApp");
		process.setStatus(ProcessStatusEnum.NEW.name());
		
		workflowProcessDao.saveProcess(process);
		
		System.out.println("testInsert success process: " + process);
		
		WorkflowProcess result_process = workflowProcessDao.queryByProcessId(innerProcessId);
		System.out.println("testQuery process: " + result_process);
	}
	
	@Test
	public void testQuery(){
		// nothing.
	}

}
