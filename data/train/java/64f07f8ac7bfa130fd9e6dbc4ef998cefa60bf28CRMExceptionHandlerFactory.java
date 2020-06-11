package com.knowledgehut.crm.common;

import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerFactory;

/**
 * Custom exception handler factory for handling all UnCatched exceptions.
 *  
 * @author Tanuj.Batra
 *
 */
public class CRMExceptionHandlerFactory extends ExceptionHandlerFactory {

	private ExceptionHandlerFactory parent;

	public CRMExceptionHandlerFactory(ExceptionHandlerFactory parent) {
		this.parent = parent;
	}

	//create your own ExceptionHandler
	@Override
	public ExceptionHandler getExceptionHandler() {
		ExceptionHandler result = new CRMExceptionHandler(parent.getExceptionHandler());
		return result;
	}
}
