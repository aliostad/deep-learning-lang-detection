package com.telenav.cserver.framework.executor.impl;

import java.util.List;

import com.telenav.cserver.framework.handler.DataHandler;


public class ResponseDataHandlerItem 
{
	String handlerType;
	
	List<DataHandler> handlers;
	
	public String getHandlerType() {
		return handlerType;
	}

	public void setHandlerType(String handlerType) {
		this.handlerType = handlerType;
	}

	public List<DataHandler> getHandlers() {
		return handlers;
	}

	public void setHandlers(List<DataHandler> handlers) {
		this.handlers = handlers;
	}
}
