package br.com.dbsoft.ui.exception;

import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerFactory;


public class DBSFacesExceptionHandlerFactory  extends ExceptionHandlerFactory {

	   private ExceptionHandlerFactory wParent;
	   
	   public DBSFacesExceptionHandlerFactory(ExceptionHandlerFactory pParent) {
		   wParent = pParent;
	   }
	 
	    @Override
	    public ExceptionHandler getExceptionHandler() {
	 
	        ExceptionHandler handler = new DBSFacesExceptionHandler(wParent.getExceptionHandler());
	 
	        return handler;
	    }


}
