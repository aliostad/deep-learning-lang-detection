/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package exceptions;

import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerFactory;

/**
 *
 * @author Chris Allen Barroso
 */
public class CustomExceptionHandlerFactory  extends ExceptionHandlerFactory{
    
    private ExceptionHandlerFactory parent;
 
    public CustomExceptionHandlerFactory(ExceptionHandlerFactory parent) {
        this.parent = parent;
    }
 
    @Override
    public ExceptionHandler getExceptionHandler() {
        ExceptionHandler handler = new CustomExceptionHandler(parent.getExceptionHandler());
        return handler;
    }
    
}
