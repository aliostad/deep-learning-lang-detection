package com.forest.exception;

import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerFactory;

/**
 *
 * @author markito
 */
public class CustomExceptionHandlerFactory extends ExceptionHandlerFactory {

   private ExceptionHandlerFactory parent;

   // this injection handles jsf
   public CustomExceptionHandlerFactory(ExceptionHandlerFactory parent) {
    this.parent = parent;
   }
  
    @Override
    public ExceptionHandler getExceptionHandler() {
        
        ExceptionHandler handler = new CustomExceptionHandler(parent.getExceptionHandler());
        
        return handler;
    }
    
}
