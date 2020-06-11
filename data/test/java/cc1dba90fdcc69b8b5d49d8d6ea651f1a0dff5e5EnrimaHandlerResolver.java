package at.ac.iiasa.ime.enrima.client;

import java.util.ArrayList;
import java.util.List;

import javax.xml.ws.handler.Handler;
import javax.xml.ws.handler.HandlerResolver;
import javax.xml.ws.handler.PortInfo;

import at.ac.iiasa.ime.enrima.client.log.EnrimaSOAPLoggingHandler;

//author Hongtao Ren
public class EnrimaHandlerResolver implements HandlerResolver {

	
	@SuppressWarnings("rawtypes")
	@Override
	public List<Handler> getHandlerChain(PortInfo portInfo) {
		List<Handler> handlerList = new ArrayList<Handler>();
		//MD5Encoder encoder = new MD5Encoder();
		//handlerList.add(new EnrimaSecurityHandlerSolver(username,encoder.encodePassword(password)));
		handlerList.add(new EnrimaSOAPLoggingHandler());
		return handlerList;

	}

	

}
