/*
 * Created on Dec 12, 2004
 */
package org.mindswap.exceptions;

import org.mindswap.owls.process.AtomicProcess;
import org.mindswap.owls.process.Process;

/**
 * @author Evren Sirin
 */
public class ExecutionException extends RuntimeException {
	private AtomicProcess atomicProcess;
	private Process process;
	
    public ExecutionException() {
        super();
    }

    public ExecutionException(String message) {
        super(message);
    }

    public ExecutionException(String message, Process process) {
        super(message);
        setProcess(process);
    }
    
    public ExecutionException(Exception e) {
        super(e);
    }

    /**
     * Returns the atomic process whose execution failed 
     * @return the atomic process whose execution failed or null if other failure ocurred
     */
	public AtomicProcess getAtomicProcess() {
		return atomicProcess;
	}

	/**
	 * Sets the atomic process whose execution failed
	 * @param atomicProcess the atomic process whose execution failed
	 */
	public void setAtomicProcess(AtomicProcess atomicProcess) {
		this.atomicProcess = atomicProcess;
	}

	/**
	 * Returns the overall process whose execution failed
	 * @return the overall process whose execution failed 
	 */
	public Process getProcess() {
		return process;
	}

	/**
	 * Sets the overall process whose execution failed
	 * @param process the overall process whose execution failed
	 */
	public void setProcess(Process process) {
		this.process = process;
	}   
    
    
    
}
