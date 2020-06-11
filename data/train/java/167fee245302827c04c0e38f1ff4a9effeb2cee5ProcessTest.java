package com.idee.eonothem.process;

import org.drools.runtime.StatefulKnowledgeSession;
import org.drools.runtime.process.ProcessInstance;
import org.jbpm.test.JbpmJUnitTestCase;
import org.junit.Test;

/**
 * Eonothem process test
 */
public class ProcessTest extends JbpmJUnitTestCase {

	@Test
	public void testProcess() {
		StatefulKnowledgeSession ksession = createKnowledgeSession("eonothem.bpmn");
		ProcessInstance processInstance = ksession.startProcess("com.idee.eonothem.process.eonothem");
		// check whether the process instance has completed successfully
		assertProcessInstanceCompleted(processInstance.getId(), ksession);
		assertNodeTriggered(processInstance.getId(), "Start Process", "Collect images");
	}

}