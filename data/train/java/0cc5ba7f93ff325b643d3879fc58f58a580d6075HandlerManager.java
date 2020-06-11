package splot.core;

import java.util.HashMap;
import java.util.Map;

public class HandlerManager {

	private static Map<String,Handler> handlers;
	
	private static HandlerManager manager = null;
	
	private HandlerManager() {		
		handlers = new HashMap<String, Handler>(); 
	}
	
	public static HandlerManager getInstance() {
		if ( manager == null ) {
			manager = new HandlerManager();
		}
		return manager;
	}
	
	public void addHandler(Handler handler) {
		handlers.put(handler.getName(), handler);
	}
	
	public Handler getHandler(String handlerName) {
		return handlers.get(handlerName);
	}
}
