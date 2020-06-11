package com.onetouch.view.exception;

import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerFactory;

public class OnetouchExceptionHandlerFactory extends ExceptionHandlerFactory {
	   private ExceptionHandlerFactory parent;
	 
	   // this injection handles jsf
	   public OnetouchExceptionHandlerFactory(ExceptionHandlerFactory parent) {
	    this.parent = parent;
	   }
	 
	    @Override
	    public ExceptionHandler getExceptionHandler() {
	 
	        ExceptionHandler handler = new  OnetouchExceptionHandler(parent.getExceptionHandler());
	 
	        return handler;
	    }
	 
	}