/*
 * MockProcessExecuter.java
 * Created on Jun 23, 2005
 * 
 * 
 */
package org.aries.launcher;

import java.io.File;

import org.aries.launcher.ProcessExecuter;


/**
 * <code>MockProcessExecuter</code> - 
 * @author tfisher
 * Jun 23, 2005
 */
public class MockProcessExecuter extends ProcessExecuter {
    
    private boolean wasRun;
    
    private Process processToReturn;

    
    public boolean wasRun() {
        return wasRun;
    }
    
    public void setProcessToReturn(Process process) {
        processToReturn = process;
    }
    
    public Process exec(String command[], String environment[], File location) {
        wasRun = true;
        if (processToReturn != null)
            return processToReturn;
        return new MockProcess();
    }
}
