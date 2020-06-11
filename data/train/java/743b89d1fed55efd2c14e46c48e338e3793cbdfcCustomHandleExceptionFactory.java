package com.nucleo.MB.exception;

import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerFactory;

public class CustomHandleExceptionFactory extends ExceptionHandlerFactory {
	
	private ExceptionHandlerFactory handlerFactory;
	
	public CustomHandleExceptionFactory(ExceptionHandlerFactory exceptionHandler) {
		this.handlerFactory =  exceptionHandler;
	}
	@Override
	public ExceptionHandler getExceptionHandler() {
		ExceptionHandler exceptionHandler = new CustomHandleException(handlerFactory.getExceptionHandler());
		return exceptionHandler;
	}


}
