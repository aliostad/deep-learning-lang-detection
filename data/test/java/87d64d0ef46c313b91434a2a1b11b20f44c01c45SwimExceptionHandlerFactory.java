package exception;

import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerFactory;

public class SwimExceptionHandlerFactory extends ExceptionHandlerFactory {
	 
	  private ExceptionHandlerFactory parent;
	 
	  // this injection handles jsf
	  public SwimExceptionHandlerFactory(ExceptionHandlerFactory parent) {
	    this.parent = parent;
	  }
	 
	  //create your own ExceptionHandler
	  @Override
	  public ExceptionHandler getExceptionHandler() {
	    ExceptionHandler result =
	        new SwimExceptionHandler(parent.getExceptionHandler());
	    return result;
	  }

}
