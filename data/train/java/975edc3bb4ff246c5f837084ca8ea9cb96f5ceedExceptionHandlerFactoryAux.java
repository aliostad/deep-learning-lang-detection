package com.tritreck.web.handler;

import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerFactory;

/**
 * Gestiona las excepciones de JSF.
 */
public class ExceptionHandlerFactoryAux extends ExceptionHandlerFactory {

    private ExceptionHandlerFactory parent;

    public ExceptionHandlerFactoryAux(ExceptionHandlerFactory parent) {
        this.parent = parent;
    }

    @Override
    public ExceptionHandler getExceptionHandler() {
        ExceptionHandler result = new ExceptionHandlerWrappeAux(parent.getExceptionHandler());
        return result;
    }
}