package org.jbpm.ee.services;

import java.util.Map;

import org.jbpm.ee.services.ejb.annotations.LazilyDeserialized;
import org.jbpm.ee.services.ejb.annotations.PreprocessClassloader;
import org.jbpm.ee.services.ejb.annotations.ReleaseId;
import org.jbpm.ee.services.ejb.annotations.ProcessInstanceId;
import org.jbpm.ee.services.model.KieReleaseId;
import org.kie.api.runtime.process.ProcessInstance;
/**
 * 
 * @author bdavis, abaxter 
 * 
 * For starting, creating, and aborting processes and signaling events to a process
 */
public interface ProcessService {
	
	/**
	 * Starts a process with no variables
	 * 
	 * @param releaseId Deployment information for the process's kjar
	 * @param processId The process's name 
	 * @return Process instance information
	 */
	ProcessInstance startProcess(@ReleaseId KieReleaseId releaseId, String processId);
	
	/**
	 * Starts a process with provided variables
	 * 
	 * @param releaseId Deployment information for the process's kjar
	 * @param processId The process's name 
	 * @param parameters Process variables to start with
	 * @return Process instance information
	 */
	@PreprocessClassloader
	ProcessInstance startProcess(@ReleaseId KieReleaseId releaseId, String processId, @LazilyDeserialized Map<String, Object> parameters);
	
	/**
	 * Signal an event to a single process
	 * 
	 * @param type The event's ID in the process
	 * @param event The event object to be passed in with the event
	 * @param processInstanceId The process instance's unique identifier
	 */
	void signalEvent(@ProcessInstanceId long processInstanceId, String type, Object event);
	
	
	/**
	 * Returns process instance information. Will return null if no
	 * active process with that id is found
	 * 
	 * @param processInstanceId The process instance's unique identifier
	 * @return Process instance information
	 */
	ProcessInstance getProcessInstance(@ProcessInstanceId long processInstanceId);
	
	/**
	 * Aborts the specified process
	 * 
	 * @param processInstanceId The process instance's unique identifier
	 */
	void abortProcessInstance(@ProcessInstanceId long processInstanceId);
	
	
	/**
	 * Sets a process variable.
	 * @param processInstanceId The process instance's unique identifier.
	 * @param variableName The variable name to set.
	 * @param variable The variable value.
	 */
	@PreprocessClassloader
	void setProcessInstanceVariable(@ProcessInstanceId long processInstanceId, String variableName, @LazilyDeserialized Object variable);

	/**
	 * Gets a process instance's variable.
	 * @param processInstanceId The process instance's unique identifier.
	 * @param variableName The variable name to get from the process.
	*/	
	Object getProcessInstanceVariable(@ProcessInstanceId long processInstanceId, String variableName);

	/**
	 * Gets a process instance's variable values.
	 * @param processInstanceId The process instance's unique identifier.
	*/
	Map<String, Object> getProcessInstanceVariables(@ProcessInstanceId long processInstanceId);

	/**
	 * Gets the release id for the process instance.
	 * @param processInstanceId Process Instance ID
	 * @return
	 */
	KieReleaseId getReleaseId(@ProcessInstanceId long processInstanceId);

}
