package org.esupportail.catapp.admin.web.exceptions;

import org.primefaces.extensions.component.ajaxerrorhandler.AjaxExceptionHandlerFactory;

public class ExceptionHandlerFactory extends AjaxExceptionHandlerFactory {

	public ExceptionHandlerFactory(
			javax.faces.context.ExceptionHandlerFactory wrapped) {
		super(wrapped);
	}
	
	/**
	 * Returns a new instance {@link ExceptionHandler}.
	 */
	@Override
	public javax.faces.context.ExceptionHandler getExceptionHandler() {
		return new ExceptionHandler(super.getExceptionHandler());
	}
}
