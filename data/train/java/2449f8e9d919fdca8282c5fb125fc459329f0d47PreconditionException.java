/*
 * Created on Jan 5, 2005
 */
package org.mindswap.exceptions;

import org.mindswap.owls.process.Condition;
import org.mindswap.owls.process.Process;

/**
 * @author Evren Sirin
 *
 */
public abstract class PreconditionException extends ExecutionException {
    protected Process process;
    protected Condition condition;
    
    public PreconditionException(Process process, Condition condition) {
        this.process = process;
        this.condition = condition;
    }

    public Process getProcess() {
        return process;
    }

    public Condition getCondition() {
        return condition;
    }
}
