package org.jbpm.ee.exception;

import javax.ejb.ApplicationException;

/**
 * Thrown when the client tries to act on a completed process
 * 
 * @author bdavis
 *
 */
@ApplicationException(rollback=false)
public class InactiveProcessInstance extends RuntimeException {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4248542124773720848L;
	private Long processInstanceId;
	
	public InactiveProcessInstance(Long processInstanceId, String message, Throwable t) {
		super(message, t);
		this.processInstanceId = processInstanceId;
	}

	public InactiveProcessInstance(Long processInstanceId) {
		super("Inactive process instance: "+processInstanceId);
		this.processInstanceId = processInstanceId;
	}
	
	public Long getProcessInstanceId() {
		return processInstanceId;
	}
	
}
