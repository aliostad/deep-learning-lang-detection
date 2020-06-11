package de.codecentric.es.camunda.integration.model.event;

import de.codecentric.es.camunda.integration.model.payload.ESProcessDefinition;

public class ProcessEndedEvent extends BaseEvent{

	private final ESProcessDefinition processDefinitionPayload;

	public ProcessEndedEvent(String processInstanceId, ESProcessDefinition processDefinitionPayload) {
		super(processInstanceId);
		this.processDefinitionPayload = processDefinitionPayload;
	}

	public ESProcessDefinition getProcessDefinitionPayload() {
		return processDefinitionPayload;
	}

	@Override
	public String toString() {
		return "ProcessEndedEvent [processDefinitionPayload="
				+ processDefinitionPayload + ", processInstanceId="
				+ processInstanceId + "]";
	}

	
}
