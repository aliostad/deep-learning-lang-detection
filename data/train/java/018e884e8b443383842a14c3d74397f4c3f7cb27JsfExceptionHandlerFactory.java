package br.com.agilles.tudaki.utils;

import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerFactory;

/**
 *
 * @author Agilles
 */
public class JsfExceptionHandlerFactory extends ExceptionHandlerFactory {
    
    private ExceptionHandlerFactory parent;

    public JsfExceptionHandlerFactory(ExceptionHandlerFactory parent) {
        this.parent = parent;
    }
    
    
    @Override
    public ExceptionHandler getExceptionHandler() {
        return new JsfExcepctionHandler(parent.getExceptionHandler());
    }

}
