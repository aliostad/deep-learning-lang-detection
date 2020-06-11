package eu.ebdit.sqleasy.handlers;

public final class ExceptionHandlers {

	public static ExceptionHandler defaultHandler(){
		return DefaultExceptionHandler.INSTANCE;
	}
	
	public static ExceptionHandler stackTraceHandler(){
		return StackTraceExceptionHandler.INSTANCE;
	}
	
	public static ExceptionHandler wrappringExceptionHandler(){
		return WrappingExceptionHandler.INSTANCE;
	}

	public static ExceptionHandler nullSafe(ExceptionHandler handler) {
		return handler == null ? ExceptionHandlers.defaultHandler() : handler;
	}
}
