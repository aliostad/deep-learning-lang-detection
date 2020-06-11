package com.jexbox.connector;

import java.lang.Thread.UncaughtExceptionHandler;

public class ExceptionHandler implements UncaughtExceptionHandler {
    private UncaughtExceptionHandler _handler;
    private JexboxConnectorImpl _jexbox;

    public ExceptionHandler(UncaughtExceptionHandler handler, JexboxConnectorImpl notifier) {
        _handler = handler;
        _jexbox = notifier;
    }
    
    public static void install(JexboxConnectorImpl notifier) {
        UncaughtExceptionHandler currentHandler = Thread.getDefaultUncaughtExceptionHandler();
        if(currentHandler instanceof ExceptionHandler) {
            currentHandler = ((ExceptionHandler)currentHandler)._handler;
        }
        Thread.setDefaultUncaughtExceptionHandler(new ExceptionHandler(currentHandler, notifier));
    }

    public static void remove() {
        UncaughtExceptionHandler currentHandler = Thread.getDefaultUncaughtExceptionHandler();
        if(currentHandler instanceof ExceptionHandler) {
            Thread.setDefaultUncaughtExceptionHandler(((ExceptionHandler)currentHandler)._handler);
        }
    }

    public void uncaughtException(Thread thread, Throwable ex) {
    	_jexbox.send(ex);
    	if(_handler != null)
    		_handler.uncaughtException(thread, ex);
    }
}