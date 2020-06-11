/**
 * 
 */
package ec.com.gesso.domain.impl;

import ec.com.gesso.domain.IHandlerEntity;
import ec.com.gesso.model.entity.Process;
import ec.com.gesso.model.entity.SubProcess;
import ec.com.gesso.repository.exception.ValidationEntity;

/**
 * @author Gabriel
 *
 */
public class HandlerProcess extends BaseHandlerEntity<Process> {
	
	private IHandlerEntity<SubProcess> handlerSubProcess;
	
	public Process register(final Process process) {
		if(null == process) {
			throw new ValidationEntity("No se puede insert un valor null");
		}
		if(null == process.getName()) {
			throw new ValidationEntity("El campo name es null");
		}
		
		if(null == process.getDescription()) {
			throw new ValidationEntity("El campo Description es null");
		}
		
		process.setStatus(Boolean.TRUE);
		if (process.getId() == null) {
			this.repositoryEntity.add(process);
		} else {
			this.repositoryEntity.update(process);
		}
		
		if(process.getSubLevels() != null && !process.getSubLevels().isEmpty()) {
			
			for(final Process subLevel : process.getSubLevels()) {
				subLevel.setIdRoot(process.getId());
				this.register(subLevel);
			}
		}
		
		if(process.getSubProcesses() != null && !process.getSubProcesses().isEmpty()) {
			
			for(final SubProcess subProcess : process.getSubProcesses()) {
				subProcess.setIdProcess(process.getId());
				this.handlerSubProcess.register(subProcess);
			}
		}
		
		return process;
	}

	/**
	 * @param handlerSubProcess the handlerSubProcess to set
	 */
	public void setHandlerSubProcess(IHandlerEntity<SubProcess> handlerSubProcess) {
		this.handlerSubProcess = handlerSubProcess;
	}

}
