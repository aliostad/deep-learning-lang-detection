package com.kiss.server;

import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.handler.ContextHandler;
import org.eclipse.jetty.server.handler.DefaultHandler;
import org.eclipse.jetty.server.handler.HandlerList;
import org.eclipse.jetty.server.handler.ResourceHandler;
import org.eclipse.jetty.servlet.ServletContextHandler;
import org.eclipse.jetty.servlet.ServletHolder;
import org.eclipse.jetty.websocket.servlet.WebSocketServlet;
import org.eclipse.jetty.websocket.servlet.WebSocketServletFactory;

import com.kiss.handler.CaroWebSocket;

public class CaroWebServer {
	public static int SERVER_PORT = 8080;
	
	public static void main(String[] args) throws Exception {
		Server server = new Server(SERVER_PORT);
		ServletContextHandler servletHandler = new ServletContextHandler(ServletContextHandler.SESSIONS);
		
		servletHandler.setContextPath("/caro");
		WebSocketServlet webHandler = new WebSocketServlet() {			
			/**
			 * 
			 */
			private static final long serialVersionUID = 1L;

			@Override
			public void configure(WebSocketServletFactory factory) {
				factory.getPolicy().setIdleTimeout(300000);//5 min timeout
				factory.register(CaroWebSocket.class);				
			}
		};	
		
		ServletHolder holder = new ServletHolder(webHandler);
		
		servletHandler.addServlet(holder, "/");
		
		ResourceHandler resourceHandler = new ResourceHandler();
		resourceHandler.setResourceBase("resource");		
		resourceHandler.setDirectoriesListed(true);
		
		ContextHandler resourceContextHandler = new ContextHandler("/");
		resourceContextHandler.setHandler(resourceHandler);
		
		
		HandlerList handlerList = new HandlerList();
		handlerList.setHandlers(new Handler[]{servletHandler, resourceContextHandler, new DefaultHandler()});
		
		server.setHandler(handlerList);
		server.start();
		server.join();
	}
}
