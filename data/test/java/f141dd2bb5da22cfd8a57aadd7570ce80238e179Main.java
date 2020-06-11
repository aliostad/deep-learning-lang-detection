package com.enter4ward.testbeth;

import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.handler.HandlerList;
import org.eclipse.jetty.server.handler.ResourceHandler;
import org.eclipse.jetty.servlet.ServletHandler;

public class Main {

	public static void main(String[] args) throws Exception {

	
		// call
		ServletHandler handlerCall = new ServletHandler();
		{
			handlerCall.addServletWithMapping(CallServlet.class, "/call");
		}
		// resources
		ResourceHandler handlerAssets = new ResourceHandler();
		{
			handlerAssets.setDirectoriesListed(true);
			handlerAssets.setWelcomeFiles(new String[]{ "index.html" });
			handlerAssets.setResourceBase("src/main/resources");			
		}
		// mixing all stuff
		HandlerList handlerList = new HandlerList();
		{
			handlerList.setHandlers(new Handler[] { handlerAssets,handlerCall });
		}
		// start server
		Server server = new Server(8080);
		server.setHandler(handlerList);
		server.start();
		server.join();

	}

}
