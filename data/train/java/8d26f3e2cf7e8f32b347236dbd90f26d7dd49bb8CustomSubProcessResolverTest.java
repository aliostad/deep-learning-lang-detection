package org.jbpm.graph.node;

import java.util.HashMap;
import java.util.Map;

import junit.framework.TestCase;

import org.dom4j.Element;
import org.jbpm.graph.def.ProcessDefinition;

public class CustomSubProcessResolverTest extends TestCase {
  
  MapBasedProcessRepository mapBasedProcessRepository = new MapBasedProcessRepository();
  
  SubProcessResolver originalSubProcessResolver = ProcessState.defaultSubProcessResolver;
  
  public void setUp() {
    // you can set the default used sub process resolver with a static method
    ProcessState.setDefaultSubProcessResolver(mapBasedProcessRepository);
    
    // or you can do it in the jbpm.cfg.xml with a bean named 'jbpm.sub.process.resolver'
  }
  
  public void tearDown() {
    // restore the original subprocess resolver to avoid test interference
    ProcessState.setDefaultSubProcessResolver(originalSubProcessResolver);
  }

  public static class MapBasedProcessRepository implements SubProcessResolver {
    private static final long serialVersionUID = 1L;

    Map processes = new HashMap();

    public void add(ProcessDefinition processDefinition) {
      processes.put(processDefinition.getName(), processDefinition);
    }

    public ProcessDefinition findSubProcess(Element subProcessElement) {
      String processName = subProcessElement.attributeValue("name");
      return (ProcessDefinition) processes.get(processName);
    }
  }
  
  public void testMapBasedProcessResolving() {
    ProcessDefinition subDefinition = ProcessDefinition.parseXmlString(
      "<process-definition name='sub'>" +
      "  <start-state>" +
      "    <transition to='end' />" +
      "  </start-state>" +
      "  <end-state name='end' />" +
      "</process-definition>"
    );
    mapBasedProcessRepository.add(subDefinition);

    ProcessDefinition superDefinition = ProcessDefinition.parseXmlString(
      "<process-definition name='super'>" +
      "  <start-state>" +
      "    <transition to='p' />" +
      "  </start-state>" +
      "  <process-state name='p'>" +
      "    <sub-process name='sub' />" +
      "    <transition to='end' />" +
      "  </process-state>" +
      "  <end-state name='end' />" +
      "</process-definition>"
    );

    ProcessState processState = (ProcessState) superDefinition.getNode("p");
    assertEquals(subDefinition, processState.getSubProcessDefinition());
  }
}
