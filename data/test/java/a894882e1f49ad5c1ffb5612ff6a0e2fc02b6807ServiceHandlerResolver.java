package com.mrprez.gencross.editor.service;

import java.util.ArrayList;
import java.util.List;

import javax.xml.ws.handler.Handler;
import javax.xml.ws.handler.HandlerResolver;
import javax.xml.ws.handler.PortInfo;

public class ServiceHandlerResolver implements HandlerResolver {

	@SuppressWarnings("rawtypes")
	@Override
	public List<Handler> getHandlerChain(PortInfo portInfo) {
		List<Handler> handlerChain = new ArrayList<Handler>();
		handlerChain.add(new ServiceHandler());
		return handlerChain;
	}

}
