package it.univr.exceptions;

import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerFactory;

/**
 * Personalizzazione della factory di default per cambiare l'exception handler.
 * 
 * @author Matteo Olivato
 * @author Federico Bianchi
 */

public class CustomExceptionHandlerFactory extends ExceptionHandlerFactory {
    
    private ExceptionHandlerFactory parent;

    
    public CustomExceptionHandlerFactory(ExceptionHandlerFactory parent) {
        this.parent = parent;
    }

    @Override
    public ExceptionHandler getExceptionHandler() {
        
        ExceptionHandler handler =
                new CustomExceptionHandler(parent.getExceptionHandler());

        return handler;
    }
    
}
