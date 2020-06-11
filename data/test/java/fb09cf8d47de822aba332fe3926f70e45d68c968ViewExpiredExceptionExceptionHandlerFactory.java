package de.thomasasel.jsf.example;

import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerFactory;

public class ViewExpiredExceptionExceptionHandlerFactory extends ExceptionHandlerFactory {

	private ExceptionHandlerFactory parent;

	public ViewExpiredExceptionExceptionHandlerFactory(final ExceptionHandlerFactory parent) {
		this.parent = parent;
	}

	@Override
	public ExceptionHandler getExceptionHandler() {
		ExceptionHandler handler = parent.getExceptionHandler();
		handler = new ViewExpiredExcpetionHandler(handler);
		return handler;
	}

}
