/**
 * 
 */
package kroki.profil;

import bp.model.data.Process;

/**
 * @author specijalac
 *
 */
public abstract class BusinessProcessModelingSubject extends VisibleElement {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	/**
	 * Business process model container.
	 */
	protected transient Process process;
	
	/**
	 * 
	 */
	public BusinessProcessModelingSubject() {
	}

	/**
	 * @param label
	 * @param visible
	 * @param componentType
	 */
	public BusinessProcessModelingSubject(String label, boolean visible,
			ComponentType componentType) {
		super(label, visible, componentType);
	}

	/**
	 * @return the process
	 */
	public Process getProcess() {
		return process;
	}

	/**
	 * @param process the process to set
	 */
	public void setProcess(Process process) {
		this.process = process;
	}

}
