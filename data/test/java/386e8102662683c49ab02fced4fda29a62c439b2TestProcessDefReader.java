/**
 * 
 */
package com.openappengine.bpm.procreader;

import junit.framework.Assert;

import org.junit.Test;

import com.openappengine.bpm.graph.ProcessDefinition;


/**
 * @author hrishi
 *
 */
public class TestProcessDefReader {
	
	private ProcessDefReader processDefReader;
	
	@Test
	public void testReadProcessDefinition() throws ProcessDefinitionException {
		String name = "TestProcessDef.xml";
		ProcessDefinition processDefinition = readProcessDefinition(name);
		Assert.assertNotNull("ProcessDefinition found null..", processDefinition);
	}

	/**
	 * @param name
	 * @return
	 * @throws ProcessDefinitionException
	 */
	private ProcessDefinition readProcessDefinition(String name)
			throws ProcessDefinitionException {
		processDefReader = new ProcessDefReader(getClass().getClassLoader().getResourceAsStream(name));
		ProcessDefinition processDefinition = processDefReader.readProcessDefinition();
		return processDefinition;
	}
	
	@Test
	public void testReadProcessDefinitionIncorrectStartState() {
		try {
			ProcessDefinition processDefinition = readProcessDefinition("TestProcessDef_IncorrectStartState.xml");
			Assert.assertNotNull("ProcessDefinition found null..", processDefinition);
		} catch (ProcessDefinitionException e) {
			Assert.assertFalse("ProcessDefReader did not catch the incorrect start-state",processDefReader.isValidProcessDefinition());
		}
	}
}
