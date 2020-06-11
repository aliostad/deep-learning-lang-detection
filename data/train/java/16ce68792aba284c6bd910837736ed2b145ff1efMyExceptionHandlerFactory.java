package br.com.tidius.delfos.controller.util;

import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerFactory;

/**
 * @author roberto.alencar
 * 
 */
public class MyExceptionHandlerFactory extends ExceptionHandlerFactory {

    private ExceptionHandlerFactory parent;

    // this injection handles jsf
    public MyExceptionHandlerFactory(ExceptionHandlerFactory parent) {
	this.parent = parent;
    }

    @Override
    public ExceptionHandler getExceptionHandler() {

	ExceptionHandler handler = new MyExceptionHandler(parent.getExceptionHandler());
	return handler;
    }

}