package com.example.websocket;

import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.handler.DefaultHandler;
import org.eclipse.jetty.server.handler.HandlerList;
import org.eclipse.jetty.server.handler.ResourceHandler;
import org.eclipse.jetty.servlet.ServletHandler;
import org.eclipse.jetty.util.resource.Resource;


public class Main 
{
    public static void main(String... arg) throws Exception
    {
        
        int port=arg.length>1?Integer.parseInt(arg[1]):8080;
        Server server = new Server(port);

       
        ServletHandler servletHandler = new ServletHandler();
        servletHandler.addServletWithMapping(GameServlet.class,"/chat/*");

      
        ResourceHandler resourceHandler = new ResourceHandler();
        resourceHandler.setBaseResource(Resource.newClassPathResource("com/example/docroot/"));

      
        DefaultHandler defaultHandler = new DefaultHandler();
        
     
        HandlerList handlers = new HandlerList();
        handlers.setHandlers(new Handler[] {servletHandler,resourceHandler,defaultHandler});
        server.setHandler(handlers);
        
      
        server.start();
        server.join();
    }
}
