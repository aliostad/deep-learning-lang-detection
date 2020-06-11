package com.algaworks.cursojavaee.util.jsf;

import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerFactory;

public class JsfExceptionHandlerFactory  extends ExceptionHandlerFactory{

	private ExceptionHandlerFactory parent;
	
	
	
	public JsfExceptionHandlerFactory(ExceptionHandlerFactory parent) {
		super();
		this.parent = parent;
	}



	@Override
	public ExceptionHandler getExceptionHandler() {
		
		return new JsfExceptionHandler(parent.getExceptionHandler());
	}

}
