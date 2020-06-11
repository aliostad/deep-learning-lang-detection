package com.cm4j.test.designpattern.chain;

public class Woman implements IWoman {

	private Class<? extends Handler> handler;

	private String request = "";

	/**
	 * 
	 * @param handler
	 *            指定的处理handler
	 * @param request
	 *            请求
	 */
	public Woman(Class<? extends Handler> handler, String request) {
		super();
		this.handler = handler;
		this.request = request;
	}

	public Class<? extends Handler> getHandler() {
		return handler;
	}

	@Override
	public String getRequest() {
		return this.request;
	}

}
