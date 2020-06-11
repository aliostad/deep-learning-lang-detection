package com.jboss.sample.process;

import java.util.Arrays;
import java.util.Collections;

import org.drools.runtime.process.ProcessInstance;

import bitronix.tm.TransactionManagerServices;

public class Main {
	/**
	 *  Run 1, 2 and 3 should run one at a time
	 */
	public static void main1(String[] args) throws InterruptedException {
		ProcessMigrator migrator = new ProcessMigrator(Arrays.asList("process/process-1.0.bpmn", "process/process-2.0.bpmn"));
		
		// run 1
		ProcessInstance processInstance = startProcess(migrator, "process-1.0");
		System.out.println("ProcessInstanceID : " + processInstance.getId());
		
		// run 2
//		migrateProcess(migrator, 9, "process-2.0");
		
		// run 3
//		signalProcess(migrator, 9);
	}
	
	public static void main(String[] args) throws InterruptedException {
		ProcessMigrator migrator = new ProcessMigrator(Arrays.asList("process/process-1.0.bpmn", "process/process-2.0.bpmn"));
		ProcessInstance processInstance = startProcess(migrator, "process-1.0");
		migrateProcess(migrator, processInstance.getId(), "process-2.0");
		signalProcess(migrator, processInstance.getId());
	}
	
	public static ProcessInstance startProcess(ProcessMigrator migrator, String processId) {
		return migrator.getStatefulKnowledgeSession().startProcess(processId);
	}

	public static void migrateProcess(ProcessMigrator migrator, long id, String processId) {
		migrator.upgradeProcessInstance(id, processId, Collections.<String, Long> emptyMap());
	}
	
	public static void signalProcess(ProcessMigrator migrator, long id) {
		migrator.getStatefulKnowledgeSession().signalEvent("Continue", null, id);
	}
}
