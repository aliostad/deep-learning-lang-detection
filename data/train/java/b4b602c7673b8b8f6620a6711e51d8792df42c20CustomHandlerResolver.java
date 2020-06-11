package com.msgidtest.handlers;

import java.util.ArrayList;
import java.util.List;

import javax.xml.ws.handler.Handler;
import javax.xml.ws.handler.HandlerResolver;
import javax.xml.ws.handler.PortInfo;

public class CustomHandlerResolver implements HandlerResolver{

	@SuppressWarnings("rawtypes")
	@Override
	public List<Handler> getHandlerChain(PortInfo portInfo) {
		 List<Handler> handlerChain = new ArrayList<Handler>();
         CustomClientHandler cch = new CustomClientHandler();
         handlerChain.add(cch);
		return handlerChain;
	}

}
