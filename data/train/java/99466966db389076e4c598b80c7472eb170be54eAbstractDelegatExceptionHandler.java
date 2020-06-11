package com.rosettastone.succor.backgroundtask.impl;

import com.rosettastone.succor.backgroundtask.ExceptionHandler;
import com.rosettastone.succor.backgroundtask.model.Task;

public abstract class AbstractDelegatExceptionHandler implements ExceptionHandler {

    private ExceptionHandler defaultExceptionHandler;

    @Override
    public long handleException(Task task, Throwable exception) {
        return findDelegatExceptionHandler(exception).handleException(task, exception);
    }

    private ExceptionHandler findDelegatExceptionHandler(Throwable exception) {
        ExceptionHandler delegat = doFindDelegatExceptionHandler(exception);
        if (delegat == null) {
            delegat = defaultExceptionHandler;
        }
        return delegat;
    }

    protected abstract ExceptionHandler doFindDelegatExceptionHandler(Throwable exception);

    public void setDefaultExceptionHandler(AbstractExceptionHandler defaultExceptionHandler) {
        this.defaultExceptionHandler = defaultExceptionHandler;
    }

}
