package br.com.scrumming.web.infra.exception;

import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerFactory;

public class ApplicationExceptionHandlerFactory extends ExceptionHandlerFactory {

	private final ExceptionHandlerFactory exceptionHandlerFactory;

	public ApplicationExceptionHandlerFactory(ExceptionHandlerFactory exceptionHandlerFactory) {
		this.exceptionHandlerFactory = exceptionHandlerFactory;
	}

	@Override
	public ExceptionHandler getExceptionHandler() {
		return new ApplicationExceptionHandler(exceptionHandlerFactory.getExceptionHandler());
	}
}