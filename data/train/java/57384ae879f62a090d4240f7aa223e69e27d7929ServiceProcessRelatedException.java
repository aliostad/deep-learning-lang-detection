package org.adiusframework.processmanager.exception;

import org.adiusframework.processmanager.domain.ServiceProcess;

/**
 * The ServiceProcessRelatedException is thrown when an exception occurs, that
 * is related to a special ServiceProcess.
 */
public class ServiceProcessRelatedException extends ProcessManagerException implements IsServiceProcessRelated {

	/**
	 * UID for serialization
	 */
	private static final long serialVersionUID = -6443651068622451794L;

	/**
	 * Stores the ServiceProcess that is related to the exception.
	 */
	private ServiceProcess serviceProcess;

	/**
	 * Creates a new ServiceProcessRelatedException with a message that contains
	 * special information about this exception and the ServiceProcess that is
	 * related to it.
	 * 
	 * @param message
	 *            The special information.
	 * @param process
	 *            The related ServiceProcess.
	 */
	public ServiceProcessRelatedException(String message, ServiceProcess process) {
		super(message);
		setServiceProcess(process);
	}

	@Override
	public ServiceProcess getServiceProcess() {
		return serviceProcess;
	}

	/**
	 * Sets a new ServiceProcess that is related to this exception.
	 * 
	 * @param serviceProcess
	 *            The related ServiceProcess.
	 */
	protected void setServiceProcess(ServiceProcess serviceProcess) {
		this.serviceProcess = serviceProcess;
	}

}