package com.kanchan.java.designpatterns.chainofresponsibilities;
/**
 * 
 */

/**
 * @author kumark
 *
 */
public abstract class RequestHandler {
	
	private RequestHandler requestHandler;

	/**
	 * @return the requestHandler
	 */
	public RequestHandler getRequestHandler() {
		return requestHandler;
	}

	/**
	 * @param requestHandler the requestHandler to set
	 */
	public void setRequestHandler(RequestHandler requestHandler) {
		this.requestHandler = requestHandler;
	}
	
	public abstract void processRequest(RequestObject requestObject);

}
