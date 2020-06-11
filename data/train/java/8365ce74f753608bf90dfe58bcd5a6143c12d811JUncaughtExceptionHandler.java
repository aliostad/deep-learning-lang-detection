package org.jbrt.client.handler;

import java.lang.Thread.UncaughtExceptionHandler;
import org.jbrt.client.JBrt;

/**
 * Implementation of uncaught exception handler. Implements
 * JErrorHandler, it can be registered to JBrt as exception
 * handler module.
 * 
 * Beware!!!
 * You should read part about DefaultUncaughtExceptionHandler and 
 * UncaughtExceptionHandler in java.lang.Thread
 * Default handler is called if handler on thread is not set. 
 * It means beware of overriding errorhandler on thread.
 * 
 * If you want to change default error handler and not harm
 * this handler , use setOtherHandler please.
 * 
 *
 * @author Cipov Peter
 * @version 1.0
 */
public class JUncaughtExceptionHandler implements JErrorHandler {
    
    private Thread.UncaughtExceptionHandler thisHandler = null;
    private Thread.UncaughtExceptionHandler otherHandler = null;
    private boolean printStackTace = true;

    public JUncaughtExceptionHandler() {
        // saving user setting
        otherHandler = Thread.getDefaultUncaughtExceptionHandler();
        printStackTace = true;
    }

    /**
     * Create object.
     * @param printStack If true every exception will be print to err stream.
     */
    public JUncaughtExceptionHandler(boolean printStack) {
        // saving user setting
        otherHandler = Thread.getDefaultUncaughtExceptionHandler();
        this.printStackTace = printStack;
    }

    public void initialize() {
        
        this.thisHandler = new Thread.UncaughtExceptionHandler() {

            public void uncaughtException(Thread t, Throwable e) {
                try {
                    
                    JBrt.commit(e);
                    if (printStackTace) {
                        
                        e.printStackTrace();
                    }
                } finally {
                    if (otherHandler != null) {
                        //we do not need the same handler 
                        if (!(otherHandler instanceof JUncaughtExceptionHandler)) {
                            otherHandler.uncaughtException(t, e);
                        }
                    }
                }
            }
        };
        // setting this handler as default one.
        Thread.setDefaultUncaughtExceptionHandler(this.thisHandler);
        
    }

    public void remove() {
        if(this.thisHandler == null) { return; }
        UncaughtExceptionHandler handler = Thread.getDefaultUncaughtExceptionHandler();
        //handler could be changed while running
        if(handler.equals(this.thisHandler)) {
            Thread.setDefaultUncaughtExceptionHandler(this.otherHandler);
        }
    }

    public UncaughtExceptionHandler getOtherHandler() {
        return otherHandler;
    }

    public void setOtherHandler(UncaughtExceptionHandler otherHandler) {
        if(otherHandler.equals(this.thisHandler)) {
            //duplicate handler.
            return;
        }
        this.otherHandler = otherHandler;
    }
}
