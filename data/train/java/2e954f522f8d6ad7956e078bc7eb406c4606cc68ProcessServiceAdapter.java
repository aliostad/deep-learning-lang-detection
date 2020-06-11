package org.jbpm.ee.client.adapter;

import java.io.Serializable;
import java.util.Map;

import org.jbpm.ee.services.ProcessService;
import org.jbpm.ee.services.model.JaxbMapResponse;
import org.jbpm.ee.services.model.JaxbObjectRequest;
import org.jbpm.ee.services.model.JaxbObjectResponse;
import org.jbpm.ee.services.model.KieReleaseId;
import org.jbpm.ee.services.ws.ProcessServiceWS;
import org.jbpm.ee.services.ws.exceptions.RemoteServiceException;
import org.jbpm.ee.services.ws.request.JaxbInitializeProcessRequest;
import org.kie.api.runtime.process.ProcessInstance;

/**
 * Adapts the WS Services JAXB responses to the {@link ProcessService} interface. 
 * 
 * @see ProcessService
 * 
 * @author bradsdavis
 *
 */
public class ProcessServiceAdapter implements ProcessService {

	private final ProcessServiceWS processService;
	
	public ProcessServiceAdapter(ProcessServiceWS restService) {
		this.processService = restService;
	}
	
	@Override
	public ProcessInstance startProcess(KieReleaseId releaseId, String processId) {
		JaxbInitializeProcessRequest request = new JaxbInitializeProcessRequest();
		request.setReleaseId(releaseId);
		
		return this.processService.startProcess(processId, request);
	}

	@Override
	public ProcessInstance startProcess(KieReleaseId releaseId, String processId, Map<String, Object> parameters) {
		try {
			JaxbInitializeProcessRequest request = new JaxbInitializeProcessRequest();
			request.setReleaseId(releaseId);
			request.setVariables(parameters);
			
			return this.processService.startProcess(processId, request);
		} catch (Exception e) {
			throw new RemoteServiceException(e);
		}
	}

	@Override
	public void signalEvent(long processInstanceId, String type, Object event) {
		this.processService.signalEvent(processInstanceId, type, event);
	}

	@Override
	public ProcessInstance getProcessInstance(long processInstanceId) {
		return this.processService.getProcessInstance(processInstanceId);
	}

	@Override
	public void abortProcessInstance(long processInstanceId) {
		this.processService.abortProcessInstance(processInstanceId);
	}

	@Override
	public void setProcessInstanceVariable(long processInstanceId, String variableName, Object variable) {
		JaxbObjectRequest request = new JaxbObjectRequest((Serializable)variable);
		this.processService.setProcessInstanceVariable(processInstanceId, variableName, request);
	}

	@Override
	public Object getProcessInstanceVariable(long processInstanceId, String variableName) {
		JaxbObjectResponse response = this.processService.getProcessInstanceVariable(processInstanceId, variableName);
		return response.getObject();
	}

	@Override
	public Map<String, Object> getProcessInstanceVariables(long processInstanceId) {
		JaxbMapResponse response = this.processService.getProcessInstanceVariables(processInstanceId);
		return response.getMap();
	}

	@Override
	public KieReleaseId getReleaseId(long processInstanceId) {
		return this.processService.getReleaseId(processInstanceId);
	}

}
