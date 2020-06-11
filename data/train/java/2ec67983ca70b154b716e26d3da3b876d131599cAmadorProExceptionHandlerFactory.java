package br.com.srnimbus.amadorpro.exception.handler;

import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerFactory;

public class AmadorProExceptionHandlerFactory extends ExceptionHandlerFactory {

	private ExceptionHandlerFactory parent;

	// this injection handles jsf
	public AmadorProExceptionHandlerFactory(ExceptionHandlerFactory parent) {
		this.parent = parent;
	}

	// create your own ExceptionHandler
	@Override
	public ExceptionHandler getExceptionHandler() {
		ExceptionHandler result = new AmadorProExceptionHandler(parent.getExceptionHandler());
		return result;
	}

}
