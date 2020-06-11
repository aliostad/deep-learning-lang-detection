package at.ac.iiasa.ime.enrima.example.client;

import java.util.ArrayList;
import java.util.List;

import javax.xml.ws.handler.Handler;
import javax.xml.ws.handler.HandlerResolver;
import javax.xml.ws.handler.PortInfo;

public class EnrimaHandlerSolver implements HandlerResolver {

	private String username;
	private String password;
	public EnrimaHandlerSolver(String username,String password)
	{
		this.username=username;
		this.password=password;
	}
	@SuppressWarnings("rawtypes")
	@Override
	public List<Handler> getHandlerChain(PortInfo portInfo) {
		List<Handler> handlerList = new ArrayList<Handler>();
		handlerList.add(new EnrimaSecurityHandlerSolver(username, MD5Util.getMD5(password)));
		handlerList.add(new EnrimaSOAPLoggingHandler());
		return handlerList;

	}

}
