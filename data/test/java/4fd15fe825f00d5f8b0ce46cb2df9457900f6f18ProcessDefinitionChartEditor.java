package org.metaworks.example.ide;

import org.metaworks.annotation.Face;

@Face(
		ejsPath="genericfaces/Window.ejs",
		options={"hideLabels"},
		values ={"true"},
		displayName="BPMN"
		)

public class ProcessDefinitionChartEditor {

	ProcessDefinition processDefinition;
	
		public ProcessDefinition getProcessDefinition() {
			return processDefinition;
		}
	
		public void setProcessDefinition(ProcessDefinition processDefinition) {
			this.processDefinition = processDefinition;
		}
		
	public ProcessDefinitionChartEditor(){
		setProcessDefinition(new ProcessDefinition());
	}
}
