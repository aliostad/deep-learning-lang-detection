package com.integros.common;

import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerFactory;


public class GlobalExceptionHandlerFactory extends ExceptionHandlerFactory {
	
	private ExceptionHandlerFactory exceptionHandlerFactory;
	
	public GlobalExceptionHandlerFactory(ExceptionHandlerFactory exceptionHandlerFactory) {	
		this.exceptionHandlerFactory = exceptionHandlerFactory;
	}
	
	@Override
	public ExceptionHandler getExceptionHandler() {
		ExceptionHandler result = exceptionHandlerFactory.getExceptionHandler();
		result = new GlobalExceptionHandler(result);
		return result;
	}

}