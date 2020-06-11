/*
 * Created on Jan 5, 2005
 */
package org.mindswap.exceptions;

import org.mindswap.owls.process.Process;

/**
 * @author Evren Sirin
 *
 */
public class ServiceNotAvailableException extends ExecutionException {
    protected Process process;
    
    public ServiceNotAvailableException( Process process ) {
        this.process = process;
    }

    public ServiceNotAvailableException( Process process, Exception e ) {
        super( e );
        
        this.process = process;
    }

    public Process getProcess() {
        return process;
    }
}
