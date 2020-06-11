package org.statelet.core.exception;

public class HandlerInitiationException extends StateletException {
	private Class handler;
	
	public HandlerInitiationException() {
		super();
	}
	
	public HandlerInitiationException(Class handler) {
		super("Cannot instantiate a handler : " + handler.getCanonicalName());
		this.handler = handler;
	}
	
	public HandlerInitiationException(Class handler, Throwable cause) {
		super("Cannot instantiate a handler : " + handler.getCanonicalName(), cause);
		this.handler = handler;
	}

	public Class getHandlerClass() {
		return handler;
	}
}
