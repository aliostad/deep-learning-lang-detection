package org.camunda.cockpit.plugin.statistics.dto.process;

public class ProcessDefinitionsWithFinishedInstancesDto {

	private String processDefinitionKey;
	
	public ProcessDefinitionsWithFinishedInstancesDto() {
    // TODO Auto-generated constructor stub
  }
	
	public ProcessDefinitionsWithFinishedInstancesDto(String processDefinitionKey) {
	  this.processDefinitionKey = processDefinitionKey;
  }

	public String getProcessDefinitionKey() {
		return processDefinitionKey;
	}

	public void setProcessDefinitionKey(String processDefinitionKey) {
		this.processDefinitionKey = processDefinitionKey;
	}
}
