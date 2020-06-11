package org.jbpm.sim.def;

import org.jbpm.graph.def.ProcessDefinition;
import org.jbpm.sim.jpdl.SimulationJpdlXmlReader;

import desmoj.core.simulator.Model;

public class DefaultJbpmSimulationModel extends JbpmSimulationModel {
  
  private ProcessDefinition[] processDefinitions;
  
  public DefaultJbpmSimulationModel(String processXml) {
    super();
    readFromXml( new String[] { processXml } );
  }
  
  public DefaultJbpmSimulationModel(String[] processXml) {
    super();
    readFromXml( processXml );
  }
  
  public DefaultJbpmSimulationModel(ProcessDefinition processDefinition) {
    super();
    this.processDefinitions = new ProcessDefinition[] {processDefinition};
  }

  public DefaultJbpmSimulationModel(ProcessDefinition[] processDefinitions) {
    super();
    this.processDefinitions = processDefinitions;
  }

  public ProcessDefinition[] getProcessDefinitions() {
    return processDefinitions;
  }
  
  private ProcessDefinition[] readFromXml(String[] processXml) {
    processDefinitions = new ProcessDefinition[processXml.length];
    for (int i = 0; i < processXml.length; i++) {
      SimulationJpdlXmlReader reader = new SimulationJpdlXmlReader(processXml[i]);
      processDefinitions[i] = reader.readProcessDefinition();
    }
    return processDefinitions;
  }

}
