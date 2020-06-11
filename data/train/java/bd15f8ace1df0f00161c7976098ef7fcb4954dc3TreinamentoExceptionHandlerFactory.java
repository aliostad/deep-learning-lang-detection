package br.com.vortice.pullrequest.web.faces.util;

import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerFactory;

public class TreinamentoExceptionHandlerFactory extends ExceptionHandlerFactory {

	 private ExceptionHandlerFactory parent;
	 
	    public TreinamentoExceptionHandlerFactory(ExceptionHandlerFactory parent) {
	        this.parent = parent;
	    }
	 
	    @Override
	    public ExceptionHandler getExceptionHandler() {
	        ExceptionHandler handler = new TreinamentoExceptionHandler(parent.getExceptionHandler());
	        return handler;
	    }

}
