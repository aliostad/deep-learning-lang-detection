package com.impler.less;

import java.util.concurrent.ConcurrentHashMap;

import com.impler.less.handler.JsonHandler;
import com.impler.less.handler.TxtHandler;

public class LessHandlerFactory {
	
	private static final ConcurrentHashMap<String, LessHandler> handlers = new ConcurrentHashMap<String, LessHandler>();
	
	static {
		registLessHandler(new TxtHandler());
		registLessHandler(new JsonHandler());
	}
	
	public static LessHandler getLessHandler(int type){
		return handlers.get(LessCodec.NAME+type);
	}
	
	public static void registLessHandler(LessHandler handler){
		if(handler!=null)
			handlers.putIfAbsent(LessCodec.NAME+handler.getType(), handler);
	}
	
	public static void unregistLessHandler(LessHandler handler){
		if(handler!=null)
			unregistLessHandler(handler.getType());
	}
	
	public static void unregistLessHandler(int type){
		handlers.remove(LessCodec.NAME+type);
	}

}
