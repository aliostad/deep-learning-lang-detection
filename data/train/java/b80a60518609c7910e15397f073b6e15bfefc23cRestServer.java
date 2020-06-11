package com.cloud.server;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.handler.ContextHandler;
import org.eclipse.jetty.server.handler.ContextHandlerCollection;

public class RestServer {
	public static void start(String[] args) {
		Server restServer = new Server(10000);
		ContextHandler vmCreateHandler= new ContextHandler();
		vmCreateHandler.setContextPath("/vm/create");
		vmCreateHandler.setHandler(new CreateHandler());

		ContextHandler vmQueryHandler = new ContextHandler();
		vmQueryHandler.setContextPath("/vm/query");
		vmQueryHandler.setHandler(new QueryHandler());

		ContextHandler vmDestroyHandler = new ContextHandler();
		vmDestroyHandler.setContextPath("/vm/destroy");
		vmDestroyHandler.setHandler(new DestroyHandler());

		ContextHandler vmTypeHandler = new ContextHandler();
		vmTypeHandler.setContextPath("/vm/types");
		vmTypeHandler.setHandler(new VMTypeHandler());

		ContextHandler imageListHandler = new ContextHandler();
		imageListHandler.setContextPath("/image/list");
		imageListHandler.setHandler(new ImageTypeHandler());
		
		/// Storage Request Handler
		
		ContextHandler volumeCreateHandler = new ContextHandler();
		volumeCreateHandler.setContextPath("/volume/create");
		volumeCreateHandler.setHandler(new VolumeCreateHandler());
		
		ContextHandler volumeAttachHandler = new ContextHandler();
		volumeAttachHandler.setContextPath("/volume/attach");
		volumeAttachHandler.setHandler(new VolumeAttachHandler());
		
		ContextHandler volumeDestroyHandler = new ContextHandler();
		volumeDestroyHandler.setContextPath("/volume/destroy");
		volumeDestroyHandler.setHandler(new VolumeDestroyHandler());

		ContextHandler volumeDetachHandler = new ContextHandler();
		volumeDetachHandler.setContextPath("/volume/detach");
		volumeDetachHandler.setHandler(new VolumeDetachHandler());
		
		ContextHandler volumeQueryHandler = new ContextHandler();
		volumeQueryHandler.setContextPath("/volume/query");
		volumeQueryHandler.setHandler(new VolumeQueryHandler());
		

		ContextHandlerCollection collection = new ContextHandlerCollection();
		ContextHandler [] contextualHandles = {vmCreateHandler, 
																		vmDestroyHandler,
																		   vmQueryHandler,
																		   	  vmTypeHandler,
																		   	     imageListHandler,
																		   	        volumeCreateHandler,
																		   	           volumeAttachHandler,
																		   	               volumeDestroyHandler,
																		   	                 volumeDetachHandler,
																		   	               		volumeQueryHandler};
		collection.setHandlers(contextualHandles);

		restServer.setHandler(collection);
		try {
			restServer.start();
			restServer.join();
		} 
		catch (Exception e) {
			e.printStackTrace();
		}
	}
}
