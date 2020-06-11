package argusviewer.view.listeners;

import toolbus.process.ProcessInstance;

/**
 * Listener for ProcessInstance related control notifications.
 * 
 * @author J. van den Bos
 * @author T. Van Laer
 */
public interface IProcessInstanceControlListener{
	/**
	 * Process instance is added on the toolbus
	 * 
	 * @param processInstance
	 *            the new processInstance
	 */
	void addProcessInstance(ProcessInstance processInstance);

	/**
	 * Process instance is removed on the toolbus
	 * 
	 * @param processInstance
	 *            the removed processInstance
	 */
	void removeProcessInstance(ProcessInstance processInstance);
}
