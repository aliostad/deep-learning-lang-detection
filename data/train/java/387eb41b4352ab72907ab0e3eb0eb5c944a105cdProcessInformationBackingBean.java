/**
 * 
 */
package be.inze.spring.demo.jsf;

import java.util.List;

import org.jbpm.api.Execution;
import org.jbpm.api.ProcessDefinition;
import org.jbpm.api.ProcessInstance;

import be.inze.spring.demo.service.ProcessInformationService;
import be.inze.spring.demo.service.SimpleProcessService;

/**
 * @author Andries Inze
 * 
 */
public class ProcessInformationBackingBean {

	private ProcessInformationService processInformationService;
	private SimpleProcessService simpleProcessService;
	
	public List<ProcessDefinition> getAllProcessDefinitionKeys() {
		return processInformationService.getAllProcessDefinitionKeys();
	}

	public List<ProcessInstance> getAllOpenExecutions() {
		return processInformationService.getAllOpenExecutions();
	}

	public void signal(Execution execution) {
		simpleProcessService.signal(execution);
	}

	public void setProcessInformationService(
			ProcessInformationService processInformationService) {
		this.processInformationService = processInformationService;
	}

	public void setSimpleProcessService(SimpleProcessService simpleProcessService) {
		this.simpleProcessService = simpleProcessService;
	}
}
