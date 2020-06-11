package be.webfactor.sitecubes.faces.helper.exception;

import javax.faces.context.ExceptionHandler;

public class ExceptionHandlerFactory extends javax.faces.context.ExceptionHandlerFactory {

	private final javax.faces.context.ExceptionHandlerFactory factory;

	public ExceptionHandlerFactory(javax.faces.context.ExceptionHandlerFactory factory) {
		this.factory = factory;
	}

	@Override
	public ExceptionHandler getExceptionHandler() {
		return new ExceptionHandlerWrapper(factory.getExceptionHandler());
	}

}
