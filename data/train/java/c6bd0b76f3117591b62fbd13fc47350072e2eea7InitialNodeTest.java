package org.jbpm.graph.exe;

import org.jbpm.AbstractJbpmTestCase;
import org.jbpm.graph.def.ProcessDefinition;

public class InitialNodeTest extends AbstractJbpmTestCase {

  public void testInitialNode() {
    ProcessDefinition processDefinition = ProcessDefinition.parseXmlString(
      "<process-definition initial='first'>" +
      "  <state name='first'/>" +
      "</process-definition>"
    );
    
    assertEquals("first", processDefinition.getStartState().getName());
    ProcessInstance processInstance = new ProcessInstance(processDefinition);
    assertEquals("first", processInstance.getRootToken().getNode().getName());
  }
  
  public void testInitialNodeExecution() {
    ProcessDefinition processDefinition = ProcessDefinition.parseXmlString(
      "<process-definition initial='first'>" +
      "  <node name='first'>" +
      "    <transition to='next'/>" +
      "  </node>" +
      "  <state name='next'>" +
      "  </state>" +
      "</process-definition>"
    );
    
    assertEquals("first", processDefinition.getStartState().getName());
    ProcessInstance processInstance = new ProcessInstance(processDefinition);
    assertEquals("next", processInstance.getRootToken().getNode().getName());
  }

  public void testStartState() {
    ProcessDefinition processDefinition = ProcessDefinition.parseXmlString(
      "<process-definition>" +
      "  <start-state name='first'>" +
      "    <transition to='next'/>" +
      "  </start-state >" +
      "  <state name='next'>" +
      "  </state>" +
      "</process-definition>"
    );
    
    assertEquals("first", processDefinition.getStartState().getName());
    ProcessInstance processInstance = new ProcessInstance(processDefinition);
    assertEquals("first", processInstance.getRootToken().getNode().getName());
  }
}
