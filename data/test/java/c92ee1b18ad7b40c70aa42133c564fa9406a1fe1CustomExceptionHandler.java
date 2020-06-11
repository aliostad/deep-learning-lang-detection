package info.rayan.util;

import javax.faces.FacesException;
import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerWrapper;

public class CustomExceptionHandler extends ExceptionHandlerWrapper {
	private ExceptionHandler exceptionHandler;

	public CustomExceptionHandler(ExceptionHandler exceptionHandler) {
		this.exceptionHandler = exceptionHandler;
	}

	@Override
	public ExceptionHandler getWrapped() {
		return exceptionHandler;
	}

	@Override
	public void handle() throws FacesException {
		super.handle();
	}

}
